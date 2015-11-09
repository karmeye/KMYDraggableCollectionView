//
//  Copyright (c) 2013 Luke Scott
//  https://github.com/lukescott/DraggableCollectionView
//  Distributed under MIT license
//

#import "ViewController.h"
#import "Cell.h"

#import "KMYDraggableCollectionView.h"

#define SECTION_COUNT 5
#define ITEM_COUNT 20

@interface ViewController ()  <KMYDraggableCollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *sections;
}

@property (nonatomic, strong)                   KMYCollectionViewDraggingCoordinator        *draggingCoordinator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.draggingCoordinator.enabled                = YES;
    self.draggingCoordinator.scrollingEdgeInsets    = UIEdgeInsetsMake(100.0f, 100.0f, 100.0f, 100.0f);
    self.draggingCoordinator.scrollingSpeed         = 600;
    
    sections = [[NSMutableArray alloc] initWithCapacity:ITEM_COUNT];
    for(int s = 0; s < SECTION_COUNT; s++) {
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:ITEM_COUNT];
        for(int i = 0; i < ITEM_COUNT; i++) {
            [data addObject:[NSString stringWithFormat:@"%c %@", 65+s, @(i)]];
        }
        [sections addObject:data];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[sections objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableArray *data = [sections objectAtIndex:indexPath.section];
    
    cell.label.text = [data objectAtIndex:indexPath.item];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView*)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
// Prevent item from being moved to index 0
//    if (toIndexPath.item == 0) {
//        return NO;
//    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath completion:(void (^)(BOOL))completionHandler
{
    NSMutableArray *data1 = [sections objectAtIndex:fromIndexPath.section];
    NSMutableArray *data2 = [sections objectAtIndex:toIndexPath.section];
    NSString *index = [data1 objectAtIndex:fromIndexPath.item];
    
    [data1 removeObjectAtIndex:fromIndexPath.item];
    [data2 insertObject:index atIndex:toIndexPath.item];

    completionHandler(YES);
}

@end



































































