//
//  KMYCollectionViewDraggingCoordinator.m
//  Pods
//
//  Created by Rassol Raissi on 05/05/15.
//
//

#import "KMYCollectionViewDraggingCoordinator.h"
#import "KMYDraggableCollectionViewDataSource.h"
#import "LSCollectionViewLayoutHelper.h"

static int kObservingCollectionViewLayoutContext;

#ifndef CGGEOMETRY__SUPPORT_H_
CG_INLINE CGPoint
_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

typedef NS_ENUM(NSInteger, _ScrollingDirection) {
    _ScrollingDirectionUnknown = 0,
    _ScrollingDirectionUp,
    _ScrollingDirectionDown,
    _ScrollingDirectionLeft,
    _ScrollingDirectionRight
};

@interface KMYCollectionViewDraggingCoordinator () <UIGestureRecognizerDelegate>
{
    NSIndexPath *lastIndexPath;
    UIView      *_mockCell;
    CGPoint mockCenter;
    CGPoint fingerTranslation;
    CADisplayLink *timer;
    _ScrollingDirection scrollingDirection;
    BOOL canWarp;
    BOOL canScroll;
}

@property (nonatomic, strong, readonly)     LSCollectionViewLayoutHelper    *layoutHelper;
@property (nonatomic, strong, readonly)     UICollectionView                *collectionView;
@property (nonatomic, strong, readonly) 	UIGestureRecognizer             *panPressGestureRecognizer;

@end

#pragma mark -

@implementation KMYCollectionViewDraggingCoordinator

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView layoutHelper:(LSCollectionViewLayoutHelper*)layoutHelper
{
    self = [super init];

    if (self)
    {
        _layoutHelper = layoutHelper;
        _collectionView = collectionView;

        // TODO: Support changing layout
//        [_collectionView addObserver:self
//                          forKeyPath:@"collectionViewLayout"
//                             options:0
//                             context:&kObservingCollectionViewLayoutContext];

        _scrollingEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
        _scrollingSpeed = 300.f;

        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [_collectionView addGestureRecognizer:_longPressGestureRecognizer];

        _panPressGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panPressGestureRecognizer.delegate = self;
        [_collectionView addGestureRecognizer:_panPressGestureRecognizer];

        for (UIGestureRecognizer *gestureRecognizer in _collectionView.gestureRecognizers)
        {
            if (gestureRecognizer != _longPressGestureRecognizer && [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
            {
                [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
                break;
            }
        }

        [self layoutChanged];
    }
    return self;
}

#pragma mark - Public -

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    _longPressGestureRecognizer.enabled = canWarp && enabled;
    _panPressGestureRecognizer.enabled = canWarp && enabled;
}

#pragma mark - Private -

- (void)layoutChanged
{
    canWarp = YES; //TODO: [self.collectionView.collectionViewLayout conformsToProtocol:@protocol(UICollectionViewLayout_Warpable)];
    canScroll = [self.collectionView.collectionViewLayout respondsToSelector:@selector(scrollDirection)];
    _longPressGestureRecognizer.enabled = _panPressGestureRecognizer.enabled = canWarp && self.enabled;
}

- (UIView*)snapshotViewOfView:(UIView*)view
{
    UIView *replicantView;

    // TODO: Support setting a subview as the snapshot

#if 1

    replicantView = [view snapshotViewAfterScreenUpdates:YES];

#else

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    replicantView = [[UIImageView alloc] initWithImage:image];

#endif

    replicantView.frame = view.frame;
    return replicantView;
}

- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point
{
    NSArray *layoutAttrsInRect;
    NSInteger closestDist = NSIntegerMax;
    NSIndexPath *indexPath;
    NSIndexPath *toIndexPath = self.layoutHelper.toIndexPath;

    // We need original positions of cells
    self.layoutHelper.toIndexPath = nil;
    layoutAttrsInRect = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:self.collectionView.bounds];
    self.layoutHelper.toIndexPath = toIndexPath;

    // What cell are we closest to?
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttrsInRect) {
        CGFloat xd = layoutAttr.center.x - point.x;
        CGFloat yd = layoutAttr.center.y - point.y;
        NSInteger dist = sqrtf(xd*xd + yd*yd);
        if (dist < closestDist) {
            closestDist = dist;
            indexPath = layoutAttr.indexPath;
        }
    }

    // Are we closer to being the last cell in a different section?
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < sections; ++i) {
        if (i == self.layoutHelper.fromIndexPath.section) {
            continue;
        }
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:items inSection:i];
        UICollectionViewLayoutAttributes *layoutAttr;
        CGFloat xd, yd;

        if (items > 0) {
            layoutAttr = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:nextIndexPath];
            xd = layoutAttr.center.x - point.x;
            yd = layoutAttr.center.y - point.y;
        } else {
            // Trying to use layoutAttributesForItemAtIndexPath while section is empty causes EXC_ARITHMETIC (division by zero items)
            // So we're going to ask for the header instead. It doesn't have to exist.
            layoutAttr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                  atIndexPath:nextIndexPath];
            xd = layoutAttr.frame.origin.x - point.x;
            yd = layoutAttr.frame.origin.y - point.y;
        }

        NSInteger dist = sqrtf(xd*xd + yd*yd);
        if (dist < closestDist) {
            closestDist = dist;
            indexPath = layoutAttr.indexPath;
        }
    }

    return indexPath;
}

- (void)warpToIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath == nil || [lastIndexPath isEqual:indexPath]) {
        return;
    }
    lastIndexPath = indexPath;

    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:toIndexPath:)] == YES
        && [(id<KMYDraggableCollectionViewDataSource>)self.collectionView.dataSource
            collectionView:self.collectionView
            canMoveItemAtIndexPath:self.layoutHelper.fromIndexPath
            toIndexPath:indexPath] == NO) {
            return;
        }
    [self.collectionView performBatchUpdates:^{
        self.layoutHelper.hideIndexPath = indexPath;
        self.layoutHelper.toIndexPath = indexPath;
    } completion:nil];
}

#pragma mark - Scroll Timer

- (void)invalidatesScrollTimer
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    scrollingDirection = _ScrollingDirectionUnknown;
}

- (void)setupScrollTimerInDirection:(_ScrollingDirection)direction
{
    scrollingDirection = direction;
    if (timer == nil) {
        timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
        [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)handleScroll:(NSTimer *)timer
{
    if (scrollingDirection == _ScrollingDirectionUnknown) {
        return;
    }

    // Prevent NSInternalInconsistencyException  'layout attributes for supplementary item at index path ... without invalidating the layout' when adding layout attributes in layoutAttributesForElementsInRect, e.g. for decoration views.
    [self.collectionView.collectionViewLayout invalidateLayout];

    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat distance = self.scrollingSpeed / 60.f;
    CGPoint translation = CGPointZero;

    switch(scrollingDirection) {
        case _ScrollingDirectionUp: {
            distance = -distance;
            if ((contentOffset.y + distance) <= 0.f) {
                distance = -contentOffset.y;
            }
            translation = CGPointMake(0.f, distance);
        } break;
        case _ScrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height;
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            translation = CGPointMake(0.f, distance);
        } break;
        case _ScrollingDirectionLeft: {
            distance = -distance;
            if ((contentOffset.x + distance) <= 0.f) {
                distance = -contentOffset.x;
            }
            translation = CGPointMake(distance, 0.f);
        } break;
        case _ScrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width;
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            translation = CGPointMake(distance, 0.f);
        } break;
        default: break;
    }

    mockCenter  = _CGPointAdd(mockCenter, translation);
    _mockCell.center = _CGPointAdd(mockCenter, fingerTranslation);
    self.collectionView.contentOffset = _CGPointAdd(contentOffset, translation);

    // Warp items while scrolling
    NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:_mockCell.center];
    [self warpToIndexPath:indexPath];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingCollectionViewLayoutContext) {
        [self layoutChanged];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Gesture Recognizers

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return self.layoutHelper.fromIndexPath != nil;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isEqual:_longPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:_panPressGestureRecognizer];
    }

    if ([gestureRecognizer isEqual:_panPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:_longPressGestureRecognizer];
    }

    return NO;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        return;
    }

    // TODO: Uncomment
//    if (![self.collectionView.dataSource conformsToProtocol:@protocol(KMYDraggableCollectionViewDataSource)]) {
//        return;
//    }

    NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:[sender locationInView:self.collectionView]];

    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath == nil) {
                return;
            }
            if (![(id<KMYDraggableCollectionViewDataSource>)self.collectionView.dataSource
                  collectionView:self.collectionView
                  canMoveItemAtIndexPath:indexPath]) {
                return;
            }
            // Create mock cell to drag around
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            cell.highlighted = NO;
            [_mockCell removeFromSuperview];
            _mockCell = [self snapshotViewOfView:cell];
            mockCenter = _mockCell.center;
            [self.collectionView addSubview:_mockCell];
            [UIView
             animateWithDuration:0.3
             animations:^{
                 _mockCell.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
             }
             completion:nil];

            // Start warping
            lastIndexPath = indexPath;
            self.layoutHelper.fromIndexPath = indexPath;
            self.layoutHelper.hideIndexPath = indexPath;
            self.layoutHelper.toIndexPath = indexPath;
            [self.collectionView.collectionViewLayout invalidateLayout];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if(self.layoutHelper.fromIndexPath == nil) {
                return;
            }
            // Need these for later, but need to nil out layoutHelper's references sooner
            NSIndexPath *fromIndexPath = self.layoutHelper.fromIndexPath;
            NSIndexPath *toIndexPath = self.layoutHelper.toIndexPath;
            // Tell the data source to move the item
            id<KMYDraggableCollectionViewDataSource> dataSource = (id<KMYDraggableCollectionViewDataSource>)self.collectionView.dataSource;
            [dataSource collectionView:self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];

            // Move the item
            [self.collectionView performBatchUpdates:^{
                [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                self.layoutHelper.fromIndexPath = nil;
                self.layoutHelper.toIndexPath = nil;
            } completion:^(BOOL finished) {
                if (finished) {
                    if ([dataSource respondsToSelector:@selector(collectionView:didMoveItemAtIndexPath:toIndexPath:)]) {
                        [dataSource collectionView:self.collectionView didMoveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                    }
                }
            }];

            // Switch mock for cell
            UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:self.layoutHelper.hideIndexPath];
            [UIView
             animateWithDuration:0.3
             animations:^{
                 _mockCell.center = layoutAttributes.center;
                 _mockCell.transform = CGAffineTransformMakeScale(1.f, 1.f);
             }
             completion:^(BOOL finished) {
                 [_mockCell removeFromSuperview];
                 _mockCell = nil;
                 self.layoutHelper.hideIndexPath = nil;
                 [self.collectionView.collectionViewLayout invalidateLayout];
             }];

            // Reset
            [self invalidatesScrollTimer];
            lastIndexPath = nil;
        } break;
        default: break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateChanged) {
        // Move mock to match finger
        fingerTranslation = [sender translationInView:self.collectionView];
        _mockCell.center = _CGPointAdd(mockCenter, fingerTranslation);

        // Scroll when necessary
        if (canScroll) {
            UICollectionViewFlowLayout *scrollLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
            if([scrollLayout scrollDirection] == UICollectionViewScrollDirectionVertical) {
                if (_mockCell.center.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingEdgeInsets.top)) {
                    [self setupScrollTimerInDirection:_ScrollingDirectionUp];
                }
                else {
                    if (_mockCell.center.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingEdgeInsets.bottom)) {
                        [self setupScrollTimerInDirection:_ScrollingDirectionDown];
                    }
                    else {
                        [self invalidatesScrollTimer];
                    }
                }
            }
            else {
                if (_mockCell.center.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingEdgeInsets.left)) {
                    [self setupScrollTimerInDirection:_ScrollingDirectionLeft];
                } else {
                    if (_mockCell.center.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingEdgeInsets.right)) {
                        [self setupScrollTimerInDirection:_ScrollingDirectionRight];
                    } else {
                        [self invalidatesScrollTimer];
                    }
                }
            }
        }

        // Avoid warping a second time while scrolling
        if (scrollingDirection > _ScrollingDirectionUnknown) {
            return;
        }

        // Warp item to finger location
        CGPoint point = [sender locationInView:self.collectionView];
        NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:point];
        [self warpToIndexPath:indexPath];
    }
}

@end































