KMYDraggableCollectionView
=====================================

## Setup

```objc
#import <KMYDraggableCollectionView/KMYDraggableCollectionView.h>
```

Use `KMYDraggableCollectionViewFlowLayout` for the layout. 
For custom layouts, conform to `KMYCollectionViewLayoutModifying` protocol. See the _CircleLayout_ example. 

Keep a strong reference to a coordinator.

```objc
@property (nonatomic, strong) KMYCollectionViewDraggingCoordinator *draggingCoordinator;
```

After the `UICollectionView` and its layout has loaded, for example in `viewDidLoad:`.

```objc
KMYCollectionViewLayoutMoveModifier *moveModifier = [[KMYCollectionViewLayoutMoveModifier alloc] initWithCollectionViewLayout:self.collectionView.collectionViewLayout];
self.draggingCoordinator = [[KMYCollectionViewDraggingCoordinator alloc] initWithCollectionView:self.collectionView layoutModifiers:@[moveModifier]];

self.draggingCoordinator.enabled                = YES;
self.draggingCoordinator.scrollingEdgeInsets    = UIEdgeInsetsMake(100.0f, 100.0f, 100.0f, 100.0f);
self.draggingCoordinator.scrollingSpeed         = 600;

```

## Compability

iOS 7 and later.

## License

KMYDraggableCollectionView is available under the [MIT license](LICENSE).
