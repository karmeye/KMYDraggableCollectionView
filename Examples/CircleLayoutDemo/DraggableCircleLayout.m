//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "DraggableCircleLayout.h"
#import "UICollectionViewLayout+KMYCollectionViewLayout.h"

@interface DraggableCircleLayout ()
{

}
@end

@implementation DraggableCircleLayout

@synthesize layoutModifiers;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self kmy_modifiedLayoutAttributes:[super layoutAttributesForElementsInRect:rect] forElementsInRect:rect withModifiers:self.layoutModifiers];
}

@end
