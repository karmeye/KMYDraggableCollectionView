//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import "KMYCollectionViewLayoutMoveModifier.h"

@interface KMYCollectionViewLayoutMoveModifier ()

@property (nonatomic, readonly)     BOOL    isSystemVersionAtLeast9;

@end

@implementation KMYCollectionViewLayoutMoveModifier

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout
{
    self = [super init];

    if (self)
    {
        self.collectionViewLayout   = collectionViewLayout;
        _isSystemVersionAtLeast9    = [UIDevice currentDevice].systemVersion.floatValue >= 9.0;
    }

    return self;
}

- (void)prepareModifiedLayout
{
}

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements inRect:(CGRect)rect
{
    NSParameterAssert(self.collectionViewLayout && self.collectionViewLayout.collectionView);

    UICollectionView *collectionView    = self.collectionViewLayout.collectionView;
    NSIndexPath *fromIndexPath          = self.fromIndexPath;
    NSIndexPath *toIndexPath            = self.toIndexPath;
    NSIndexPath *hideIndexPath          = self.hideIndexPath;
    NSIndexPath *indexPathToRemove;

    if (toIndexPath == nil)
    {
        if (hideIndexPath == nil) {
            return elements;
        }

        for (UICollectionViewLayoutAttributes *layoutAttributes in elements)
        {
            if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
                continue;
            }

            layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:hideIndexPath];
        }

        [self rearrangeIndexPathOfLayoutAttributesForElements:elements];

        return elements;
    }

    [self rearrangeIndexPathOfLayoutAttributesForElements:elements];

    if (fromIndexPath.section != toIndexPath.section)
    {
        indexPathToRemove = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:fromIndexPath.section] - 1
                                                inSection:fromIndexPath.section];
    }

    for (UICollectionViewLayoutAttributes *layoutAttributes in elements)
    {
        if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }

        if([layoutAttributes.indexPath isEqual:indexPathToRemove])
        {
            // Remove item in source section and insert item in target section
            layoutAttributes.indexPath = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:toIndexPath.section]
                                                             inSection:toIndexPath.section];
            if (layoutAttributes.indexPath.item != 0) {
                layoutAttributes.center = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:layoutAttributes.indexPath].center;
            }
        }

        NSIndexPath *indexPath = layoutAttributes.indexPath;
        layoutAttributes.hidden = [indexPath isEqual:hideIndexPath];

        if([indexPath isEqual:toIndexPath])
        {
            // Item's new location
            layoutAttributes.indexPath = fromIndexPath;
        }
        else if(fromIndexPath.section != toIndexPath.section)
        {
            if(indexPath.section == fromIndexPath.section && indexPath.item >= fromIndexPath.item) {
                // Change indexes in source section
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
            else if(indexPath.section == toIndexPath.section && indexPath.item >= toIndexPath.item) {
                // Change indexes in destination section
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
        }
        else if(indexPath.section == fromIndexPath.section)
        {
            if(indexPath.item <= fromIndexPath.item && indexPath.item > toIndexPath.item) {
                // Item moved back
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
            else if(indexPath.item >= fromIndexPath.item && indexPath.item < toIndexPath.item) {
                // Item moved forward
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
        }
    }

    return elements;
}

- (UICollectionViewLayoutAttributes *)modifiedLayoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Private -

- (void)rearrangeIndexPathOfLayoutAttributesForElements:(NSArray *)elements
{
    if (self.isSystemVersionAtLeast9)
    {
        NSMutableArray *indexPathArray = [NSMutableArray array];

        for (UICollectionViewLayoutAttributes *layoutAttributes in elements)
        {
            // Ignore headers and footers
            if([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] || [layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                continue;
            }

            [indexPathArray addObject:layoutAttributes.indexPath];
        }

        NSArray *sortedArray = [indexPathArray sortedArrayUsingComparator:^(NSIndexPath *indexPath1, NSIndexPath *indexPath2) {

            if (indexPath1.section < indexPath2.section)
                return NSOrderedAscending;

            if (indexPath1.row < indexPath2.row)
                return NSOrderedAscending;

            return (NSComparisonResult)NSOrderedDescending;
        }];

        for (NSInteger index = 0; index < sortedArray.count; ++index) {
            ((UICollectionViewLayoutAttributes*)[elements objectAtIndex:index]).indexPath = (NSIndexPath *)[sortedArray objectAtIndex:index];
        }
    }
}

@end






































