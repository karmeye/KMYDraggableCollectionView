KMYDraggableCollectionView
=====================================

Fork from [lukescott/DraggableCollectionView](https://github.com/lukescott/DraggableCollectionView) but now lives its own life.

## Setup

Use `KMYDraggableCollectionViewFlowLayout` for the layout. 

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
Examples tested on Xcode 6.3.

## License

KMYDraggableCollectionView is available under the [MIT license](LICENSE).
