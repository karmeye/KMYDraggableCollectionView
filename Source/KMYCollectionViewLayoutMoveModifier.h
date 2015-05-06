//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>
#import "KMYCollectionViewLayoutModifier.h"

@interface KMYCollectionViewLayoutMoveModifier : NSObject <KMYCollectionViewLayoutModifier>

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;

@property (nonatomic, weak)     UICollectionViewLayout  *collectionViewLayout;

@property (nonatomic, strong)   NSIndexPath             *fromIndexPath;
@property (nonatomic, strong)   NSIndexPath             *toIndexPath;
@property (nonatomic, strong)   NSIndexPath             *hideIndexPath;

@end
