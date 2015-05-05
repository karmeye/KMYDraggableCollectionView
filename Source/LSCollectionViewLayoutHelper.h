//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>
#import "KMYCollectionViewLayoutModifier.h"

@interface LSCollectionViewLayoutHelper : NSObject <KMYCollectionViewLayoutModifier>

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout;

@property (nonatomic, weak  )   UICollectionViewLayout *collectionViewLayout;

@property (nonatomic, strong)   NSIndexPath *fromIndexPath;
@property (nonatomic, strong)   NSIndexPath *toIndexPath;
@property (nonatomic, strong)   NSIndexPath *hideIndexPath;

@end
