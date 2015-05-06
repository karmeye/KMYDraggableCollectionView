//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import "UICollectionViewLayout+KMYCollectionViewLayout.h"
#import "KMYCollectionViewLayoutModifier.h"

@implementation UICollectionViewLayout (KMYCollectionViewLayout)

- (NSArray *)kmy_modifiedLayoutAttributes:(NSArray*)layoutAttributes forElementsInRect:(CGRect)rect withModifiers:(NSArray*)layoutModifiers
{
    layoutAttributes = layoutAttributes ?: @[];

    for (id<KMYCollectionViewLayoutModifier> modifier in layoutModifiers) {
        layoutAttributes = [modifier modifiedLayoutAttributesForElements:layoutAttributes];
    }

    return layoutAttributes;
}

@end
