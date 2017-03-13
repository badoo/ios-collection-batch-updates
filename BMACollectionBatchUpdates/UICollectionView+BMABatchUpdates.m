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

#import "UICollectionView+BMABatchUpdates.h"
#import "BMACollectionUpdates.h"

@implementation UICollectionView (BMABatchUpdates)

- (void)bma_performBatchUpdates:(NSArray<BMACollectionUpdate *> *)updates
       applyChangesToModelBlock:(void (^)(void))applyChangesToModelBlock
                reloadCellBlock:(void (^)(UICollectionViewCell *cell, NSIndexPath *indexPath))reloadCellBlock
                completionBlock:(void (^)(BOOL finished))completionBlock {
    if (!updates) {
        applyChangesToModelBlock();
        [self reloadData];
        if (completionBlock) {
            completionBlock(YES);
        }
    } else {
        [self performBatchUpdates:^{
            applyChangesToModelBlock();
            for (BMACollectionUpdate *update in updates) {
                if ([update isItemUpdate]) {
                    BMACollectionItemUpdate *itemUpdate = (BMACollectionItemUpdate *)update;
                    switch (update.type) {
                        case BMACollectionUpdateTypeReload: {
                            if (reloadCellBlock) {
                                UICollectionViewCell *cell = [self cellForItemAtIndexPath:itemUpdate.indexPath];
                                if (cell) {
                                    reloadCellBlock(cell, itemUpdate.indexPath);
                                }
                            }
                            
                            break;
                        }
                        case BMACollectionUpdateTypeDelete:
                            [self deleteItemsAtIndexPaths:@[ itemUpdate.indexPath ]];
                            break;
                        case BMACollectionUpdateTypeInsert:
                            [self insertItemsAtIndexPaths:@[ itemUpdate.indexPathNew ]];
                            break;
                        case BMACollectionUpdateTypeMove:
                            [self moveItemAtIndexPath:itemUpdate.indexPath toIndexPath:itemUpdate.indexPathNew];
                            break;
                        default:
                            break;
                    }
                } else if ([update isSectionUpdate]) {
                    BMACollectionSectionUpdate *sectionUpdate = (BMACollectionSectionUpdate *)update;
                    switch (update.type) {
                        case BMACollectionUpdateTypeReload:
                            [self reloadSections:[NSIndexSet indexSetWithIndex:sectionUpdate.sectionIndex]];
                            break;
                        case BMACollectionUpdateTypeDelete:
                            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionUpdate.sectionIndex]];
                            break;
                        case BMACollectionUpdateTypeInsert:
                            [self insertSections:[NSIndexSet indexSetWithIndex:sectionUpdate.sectionIndexNew]];
                            break;
                        case BMACollectionUpdateTypeMove:
                            [self moveSection:sectionUpdate.sectionIndex toSection:sectionUpdate.sectionIndexNew];
                            break;
                        default:
                            break;
                    }
                }
            }
        } completion:completionBlock];
    }
}

@end
