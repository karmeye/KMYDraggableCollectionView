//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import "KMYDraggableCollectionViewFlowLayout.h"
#import "UICollectionViewLayout+KMYCollectionViewLayout.h"

@implementation KMYDraggableCollectionViewFlowLayout

@synthesize layoutModifiers;

- (void)prepareLayout
{
    [super prepareLayout];

    for (id<KMYCollectionViewLayoutModifier> modifier in self.layoutModifiers) {
        [modifier prepareModifiedLayout];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self kmy_modifiedLayoutAttributes:[super layoutAttributesForElementsInRect:rect] forElementsInRect:rect withModifiers:self.layoutModifiers];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];

    if (!layoutAttributes)
    {
        for (id<KMYCollectionViewLayoutModifier> modifier in self.layoutModifiers)
        {
            layoutAttributes = [modifier modifiedLayoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];

            if (layoutAttributes) {
                break;
            }
        }
    }

    return layoutAttributes;
}

@end
