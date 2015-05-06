//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KMYCollectionViewLayoutModifierType)
{
    KMYCollectionViewLayoutModifierTypeUndefined,
    KMYCollectionViewLayoutModifierTypeMove,
    KMYCollectionViewLayoutModifierTypeDecoration
};

@protocol KMYCollectionViewLayoutModifying <NSObject>

/// Array of @c id<KMYCollectionViewModifier>
@property (nonatomic, strong)   NSArray     *layoutModifiers;

@end

@protocol KMYCollectionViewLayoutModifier <NSObject>

//@optional

/// Called from within @c prepareLayout:
- (void)prepareModifiedLayout;

/// Called from within @c layoutAttributesForElementsInRect:
- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements inRect:(CGRect)rect;

/// Called from within @c layoutAttributesForDecorationViewOfKind:atIndexPath:
/// @return Nil if not applicable
- (UICollectionViewLayoutAttributes *)modifiedLayoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath;

@end
