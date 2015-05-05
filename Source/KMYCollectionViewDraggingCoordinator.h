//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

@class LSCollectionViewLayoutHelper;

@interface KMYCollectionViewDraggingCoordinator : NSObject

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView layoutHelper:(LSCollectionViewLayoutHelper*)layoutHelper;

@property (nonatomic, assign) UIEdgeInsets      scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat           scrollingSpeed;
@property (nonatomic, assign) BOOL              enabled;

@end
