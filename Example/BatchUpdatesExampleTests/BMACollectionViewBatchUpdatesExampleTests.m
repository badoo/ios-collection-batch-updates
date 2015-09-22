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

#import "BMABatchUpdatesExampleTests.h"
#import "BMACollectionUpdates.h"
#import "UICollectionView+BMABatchUpdates.h"

@interface BMACollectionViewBatchUpdatesExampleTests : BMABatchUpdatesExampleTests <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewController *controller;

@end

@implementation BMACollectionViewBatchUpdatesExampleTests

- (void)setupController {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.itemSize = CGSizeMake(100, 100);
    collectionViewLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 10);
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.controller = [[UICollectionViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
    self.controller.view.frame = [UIScreen mainScreen].bounds;
    self.controller.collectionView.dataSource = self;
    self.controller.collectionView.delegate = self;
    [self.controller.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.controller.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    [[[UIApplication sharedApplication] keyWindow] addSubview:self.controller.view];
}

- (void)teardownController {
    [self.controller.view removeFromSuperview];
    self.controller.collectionView.dataSource = nil;
    self.controller.collectionView.delegate = nil;
    self.controller = nil;
}

+ (BOOL)shouldRunTests {
    return YES;
}

- (void)setSections:(NSArray *)newSections {
    NSArray *oldSections = [self.sections copy];
    [BMACollectionUpdate calculateUpdatesForOldModel:oldSections
                                            newModel:newSections
                               sectionsPriorityOrder:nil
                                eliminatesDuplicates:self.containsUniqueUsers
                                          completion:^(NSArray *sections, NSArray *updates) {
                                            [self.controller.collectionView bma_performBatchUpdates:updates
                                                                           applyChangesToModelBlock:^{
                                                                               self.internalSections = sections;
                                                                           } reloadCellBlock:^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
                                                                               NSLog(@"UPDATING CELL %@ AT INDEX PATH %@", cell, indexPath);
                                                                           } completionBlock:nil];
                                          }];
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
    UICollectionViewCell *cell = [self.controller.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    id<BMAUpdatableCollectionSection> section = self.sections[indexPath.section];
    id<BMAUpdatableCollectionItem> item = section.items[indexPath.row];

    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        label.tag = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:32];
        [cell.contentView addSubview:label];
    }
    label.text = item.uid;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [self.controller.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)sectionIndex {
    return CGSizeMake(self.controller.collectionView.frame.size.width, 10);
}

@end
