//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

@protocol KMYCollectionViewLayoutModifier <NSObject>

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements;

@end
