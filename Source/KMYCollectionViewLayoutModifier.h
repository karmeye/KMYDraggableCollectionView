//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KMYCollectionViewLayoutModifierType)
{
    KMYCollectionViewLayoutModifierTypeUndefined,
    KMYCollectionViewLayoutModifierTypeMove
};

@protocol KMYCollectionViewLayoutModifying <NSObject>

/// Array of @c id<KMYCollectionViewModifier>
@property (nonatomic, strong)   NSArray     *layoutModifiers;

@end

@protocol KMYCollectionViewLayoutModifier <NSObject>

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements;

@end
