//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import "KMYDraggableCollectionViewFlowLayout.h"

@implementation KMYDraggableCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];

    for (id<KMYCollectionViewLayoutModifier> modifier in self.layoutModifiers) {
        layoutAttributes = [modifier modifiedLayoutAttributesForElements:layoutAttributes];
    }

    return layoutAttributes;
}

@end
