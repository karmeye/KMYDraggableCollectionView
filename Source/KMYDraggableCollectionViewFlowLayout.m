//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import "KMYDraggableCollectionViewFlowLayout.h"
#import "UICollectionViewLayout+KMYCollectionViewLayout.h"

@implementation KMYDraggableCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self kmy_modifiedLayoutAttributes:[super layoutAttributesForElementsInRect:rect] forElementsInRect:rect withModifiers:self.layoutModifiers];
}

@end
