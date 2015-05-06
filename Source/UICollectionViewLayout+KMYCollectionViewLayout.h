//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <UIKit/UIKit.h>

@interface UICollectionViewLayout (KMYCollectionViewLayout)

- (NSArray *)kmy_modifiedLayoutAttributes:(NSArray*)layoutAttributes forElementsInRect:(CGRect)rect withModifiers:(NSArray*)layoutModifiers;

@end
