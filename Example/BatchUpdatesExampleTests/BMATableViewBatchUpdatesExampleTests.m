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
#import "UITableView+BMABatchUpdates.h"

@interface BMATableViewBatchUpdatesExampleTests : BMABatchUpdatesExampleTests <UITableViewDataSource>

@property (nonatomic, strong) UITableViewController *controller;

@end

@implementation BMATableViewBatchUpdatesExampleTests

- (void)setupController {
    self.controller = [[UITableViewController alloc] init];
    self.controller.view.frame = [UIScreen mainScreen].bounds;
    self.controller.tableView.dataSource = self;
    [self.controller.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [[[UIApplication sharedApplication] keyWindow] addSubview:self.controller.view];
}

- (void)teardownController {
    [self.controller.view removeFromSuperview];
    self.controller.tableView.dataSource = nil;
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
                                            [self.controller.tableView bma_performBatchUpdates:updates
                                                                      applyChangesToModelBlock:^{
                                                self.internalSections = sections;
                                            } reloadCellBlock:^(UITableViewCell *cell, NSIndexPath *indexPath) {
                                                NSLog(@"UPDATING CELL %@ AT INDEX PATH %@", cell, indexPath);
                                            } completionBlock:nil];
                                          }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<BMAUpdatableCollectionSection> sectionItem = self.sections[section];
    return sectionItem.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.controller.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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

@end
