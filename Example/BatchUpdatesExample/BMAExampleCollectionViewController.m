/*
 The MIT License (MIT)
 
 Copyright (c) 2015-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "BMAExampleCollectionViewController.h"
#import "BMACollectionUpdates.h"  // BMAUpdatableCollectionItem, BMAUpdatableCollectionSection
#import "UICollectionView+BMABatchUpdates.h"

@interface BMAExampleCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic) UICollectionView *collectionView;

@end

@implementation BMAExampleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewLayout.itemSize = CGSizeMake(100, 100);
    self.collectionViewLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 10);
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.collectionView = [[UICollectionView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, [[self class] contentInsets]) collectionViewLayout:self.collectionViewLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    [self.view insertSubview:self.collectionView atIndex:0];

    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:[[self class] cellReuseIdentifier]];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[[self class] headerReuseIdentifier]];
}

- (void)performBatchUpdates:(NSArray *)updates forSections:(NSArray *)sections {
    [self.collectionView bma_performBatchUpdates:updates applyChangesToModelBlock:^{
        self.primitiveSections = sections;
    } reloadCellBlock:^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
        [self reloadCell:cell atIndexPath:indexPath];
    } completionBlock:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectionIndex {
    id<BMAUpdatableCollectionSection> section = self.sections[sectionIndex];
    return section.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [self reloadCell:cell atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                   withReuseIdentifier:[[self class] headerReuseIdentifier]
                                                                                          forIndexPath:indexPath];
        header.backgroundColor = self.itemColors[@(indexPath.section % self.itemColors.count)];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)sectionIndex {
    return CGSizeMake(self.collectionView.frame.size.width, 10);
}

#pragma mark - Utilities

- (void)reloadCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    id<BMAUpdatableCollectionSection> section = self.sections[indexPath.section];
    id<BMAUpdatableCollectionItem> item = section.items[indexPath.row];
    UIColor *color = self.itemColors[@(item.uid.integerValue % self.itemColors.count)];
    cell.backgroundColor = color;
    cell.layer.cornerRadius = CGRectGetWidth(cell.bounds) / 2;

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        label.tag = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [item.userInfo boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
        label.font = [UIFont boldSystemFontOfSize:32];
        [cell.contentView addSubview:label];
    }
    label.text = item.uid;
}

+ (NSString *)cellReuseIdentifier {
    return @"cell";
}

+ (NSString *)headerReuseIdentifier {
    return @"header";
}

@end
