//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

@interface KMYCollectionViewDraggingCoordinator : NSObject

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView layoutModifiers:(NSArray*)layoutModifiers;

@property (nonatomic, assign)               UIEdgeInsets                    scrollingEdgeInsets;
@property (nonatomic, assign)               CGFloat                         scrollingSpeed;
@property (nonatomic, assign)               BOOL                            enabled;
@property (nonatomic, strong, readonly)     UILongPressGestureRecognizer    *longPressGestureRecognizer;

@end
