//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <UIKit/UIKit.h>
#import "KMYCollectionViewLayoutModifier.h"

@interface KMYDraggableCollectionViewFlowLayout : UICollectionViewFlowLayout

/// Array of @c id<KMYCollectionViewModifier>
@property (nonatomic, strong)   NSArray     *layoutModifiers;

@end
