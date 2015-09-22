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

#import "BMAExampleTableViewController.h"
#import "BMACollectionUpdates.h"  // BMAUpdatableCollectionItem, BMAUpdatableCollectionSection
#import "UITableView+BMABatchUpdates.h"

@interface BMAExampleTableViewController () <UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@end

@implementation BMAExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, [[self class] contentInsets]) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    [self.view insertSubview:self.tableView atIndex:0];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[[self class] reusableCellIdentifier]];
}

- (void)performBatchUpdates:(NSArray *)updates forSections:(NSArray *)sections {
    [self.tableView bma_performBatchUpdates:updates applyChangesToModelBlock:^{
        self.primitiveSections = sections;
    } reloadCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
        [self reloadCell:cell atIndexPath:indexPath];
    } completionBlock:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    id<BMAUpdatableCollectionSection> section = self.sections[sectionIndex];
    return section.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] reusableCellIdentifier]
                                                            forIndexPath:indexPath];
    [self reloadCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Utilities

- (void)reloadCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    id<BMAUpdatableCollectionSection> section = self.sections[indexPath.section];
    id<BMAUpdatableCollectionItem> item = section.items[indexPath.row];
    UIColor *color = self.itemColors[@([item.uid integerValue] % self.itemColors.count)];
    cell.backgroundColor = color;

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

+ (NSString *)reusableCellIdentifier {
    return @"cell";
}

@end
