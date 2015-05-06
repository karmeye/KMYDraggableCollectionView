//
//  Copyright (c) 2015 Karmeye
//  https://github.com/karmeye/KMYDraggableCollectionView
//  Distributed under MIT license
//

#import <Foundation/Foundation.h>

@protocol KMYDraggableCollectionViewDataSource <UICollectionViewDataSource>

@required

/// @return YES to allow the user to begin to move the item at @c indexPath.
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;

/// Called when the user confirmes the move and the animation will start. Change the datasource order here.
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@optional

/// @return YES to allow the user to move the item currently at @c indexPath to @c toIndexPath.
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath;

/// Called after @c moveItemAtIndexPath:toIndexPath: and after the animation has finished.
- (void)collectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end
