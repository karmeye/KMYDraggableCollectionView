//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import "KMYCollectionViewLayoutMoveModifier.h"

@implementation KMYCollectionViewLayoutMoveModifier

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout
{
    self = [super init];

    if (self) {
        self.collectionViewLayout = collectionViewLayout;
    }

    return self;
}

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements
{
    NSParameterAssert(self.collectionViewLayout && self.collectionViewLayout.collectionView);

    UICollectionView *collectionView    = self.collectionViewLayout.collectionView;
    NSIndexPath *fromIndexPath          = self.fromIndexPath;
    NSIndexPath *toIndexPath            = self.toIndexPath;
    NSIndexPath *hideIndexPath          = self.hideIndexPath;
    NSIndexPath *indexPathToRemove;

    if (toIndexPath == nil) {
        if (hideIndexPath == nil) {
            return elements;
        }
        for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
            if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
                continue;
            }
            if ([layoutAttributes.indexPath isEqual:hideIndexPath]) {
                layoutAttributes.hidden = YES;
            }
        }
        return elements;
    }

    if (fromIndexPath.section != toIndexPath.section) {
        indexPathToRemove = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:fromIndexPath.section] - 1
                                                inSection:fromIndexPath.section];
    }

    for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
        if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if([layoutAttributes.indexPath isEqual:indexPathToRemove]) {
            // Remove item in source section and insert item in target section
            layoutAttributes.indexPath = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:toIndexPath.section]
                                                             inSection:toIndexPath.section];
            if (layoutAttributes.indexPath.item != 0) {
                layoutAttributes.center = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:layoutAttributes.indexPath].center;
            }
        }
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        if ([indexPath isEqual:hideIndexPath]) {
            layoutAttributes.hidden = YES;
        }
        if([indexPath isEqual:toIndexPath]) {
            // Item's new location
            layoutAttributes.indexPath = fromIndexPath;
        }
        else if(fromIndexPath.section != toIndexPath.section) {
            if(indexPath.section == fromIndexPath.section && indexPath.item >= fromIndexPath.item) {
                // Change indexes in source section
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
            else if(indexPath.section == toIndexPath.section && indexPath.item >= toIndexPath.item) {
                // Change indexes in destination section
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
        }
        else if(indexPath.section == fromIndexPath.section) {
            if(indexPath.item <= fromIndexPath.item && indexPath.item > toIndexPath.item) {
                // Item moved back
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
            else if(indexPath.item >= fromIndexPath.item && indexPath.item < toIndexPath.item) {
                // Item moved forward
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
        }
    }

    return elements;
}

@end