//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "ViewController.h"
#import "Cell.h"
#import "DraggableCircleLayout.h"

#import "KMYCollectionViewDraggingCoordinator.h"
#import "KMYCollectionViewLayoutMoveModifier.h"
#import "KMYDraggableCollectionViewDataSource.h"

@interface ViewController () <KMYDraggableCollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *data;
}

@property (nonatomic, strong)                   KMYCollectionViewDraggingCoordinator        *draggingCoordinator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.draggingCoordinator.enabled                = YES;

    data = [[NSMutableArray alloc] initWithCapacity:20];
    for(int i = 0; i < 20; i++) {
        [data addObject:@(i)];
    }
}

- (KMYCollectionViewDraggingCoordinator*)draggingCoordinator
{
    if (!_draggingCoordinator) {
        KMYCollectionViewLayoutMoveModifier *layoutHelper = [[KMYCollectionViewLayoutMoveModifier alloc] initWithCollectionViewLayout:self.collectionView.collectionViewLayout];
        _draggingCoordinator = [[KMYCollectionViewDraggingCoordinator alloc] initWithCollectionView:self.collectionView layoutModifiers:@[layoutHelper]];
    }
    return _draggingCoordinator;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSNumber *index = [data objectAtIndex:indexPath.item];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)index.integerValue];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSNumber *index = [data objectAtIndex:fromIndexPath.item];
    [data removeObjectAtIndex:fromIndexPath.item];
    [data insertObject:index atIndex:toIndexPath.item];
}

@end
