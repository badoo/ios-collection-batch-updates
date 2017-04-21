# BMACollectionBatchUpdates [![Build Status](https://api.travis-ci.org/badoo/ios-collection-batch-updates.svg)](https://travis-ci.org/badoo/ios-collection-batch-updates)  [![codecov.io](https://codecov.io/github/badoo/ios-collection-batch-updates/coverage.svg?branch=master)](https://codecov.io/github/badoo/ios-collection-batch-updates?branch=master) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/BMACollectionBatchUpdates.svg)](https://img.shields.io/cocoapods/v/BMACollectionBatchUpdates.svg)
`BMACollectionBatchUpdates` is a set of classes to generate updates and extensions to `UICollectionView` and `UITableView` to perform them safely in a batch manner.

<div align="center">
<img src="./demoimages/demo.gif" />
</div>

## How to use

In order to generate the mentioned updates it has to make collection item and section conform the `BMAUpdatableCollectionItem` and`BMAUpdatableCollectionItem` protocols respectively:

```objectivec
@interface BMAExampleItemsSection : NSObject <BMAUpdatableCollectionSection>
@end

@interface BMAExampleItem : NSObject <BMAUpdatableCollectionItem>
@end
```

Once both old and new data models are available, it has to calculate changes and apply them:

```objectivec
@implementation BMAExampleCollectionViewController

- (void)setSections:(NSArray *)sections {
	[BMACollectionUpdate calculateUpdatesForOldModel:self.sections
                                            newModel:sections
                               sectionsPriorityOrder:nil
                                eliminatesDuplicates:YES
                                          completion:^(NSArray *sections, NSArray *updates) {
                                          		[self.collectionView bma_performBatchUpdates:updates applyChangesToModelBlock:^{
											        _sections = sections;
											    } reloadCellBlock:^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
											        [self reloadCell:cell atIndexPath:indexPath];
											    } completionBlock:nil];
                                          }];
}

@end
```

```objectivec
@implementation BMAExampleTableViewController

- (void)setSections:(NSArray *)sections {
	[BMACollectionUpdate calculateUpdatesForOldModel:self.sections
                                            newModel:sections
                               sectionsPriorityOrder:nil
                                eliminatesDuplicates:YES
                                          completion:^(NSArray *sections, NSArray *updates) {
                                          		[self.collectionView bma_performBatchUpdates:updates applyChangesToModelBlock:^{
											        _sections = sections;
											    } reloadCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
											        [self reloadCell:cell atIndexPath:indexPath];
											    } completionBlock:nil];
                                          }];
}

@end
```

### Generating cell update for existing BMAUpdatableCollectionItem

`BMAUpdatableCollectionItem` conforms to `NSObject` protocol and by doing so it provides `isEqual` method for comparing items. In most cases comparing uids in `isEqual` will be enough, but sometimes your model may contain additional properties that can change and requie cell update.

Simple example: online status which can be either online or offline. When it changes we need to gerenrate cell update for this item. To detect this change `isEqual` can be implemented in following way:

```objectivec
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    BMAExampleItem *item = (BMAExampleItem *)object;
    return [self.uid isEqual:item.uid] && self.isOnline == item.isOnline;
}

@end
```

## How to install

### Using CocoaPods


1. Include the following line in your `Podfile`:

    ```
    pod 'BMACollectionBatchUpdates', '~> 1.1'
    ```

	If you like to live on the bleeding edge, you can use the `master` branch with:

    ```
    pod 'BMACollectionBatchUpdates', :git => 'https://github.com/badoo/ios-collection-batch-updates'
    ```

2. Run `pod install`

### Manually

1. Clone, add as a submodule or [download.](https://github.com/badoo/ios-collection-batch-updates/archive/master.zip)
2. Add all the files under `BMACollectionBatchUpdates` to your project.
3. Make sure your project is configured to use ARC.

## License

Source code is distributed under MIT license.

## Blog
Read more on our [tech blog](http://techblog.badoo.com/) or explore our other [open source projects](https://github.com/badoo)
