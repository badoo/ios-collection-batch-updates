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

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class BMACollectionUpdate;

@interface UITableView (BMABatchUpdates)

/// Updates the receiver with specified changes in animated fashion
/// @param updates updates to be performed: array of BMACollectionUpdate instances, if nil reloads data
/// @param applyChangesToModelBlock block in which changes should be applied
/// @param reloadCellBlock optional block in which cells are to be updated
/// @param completionBlock optional completion block
- (void)bma_performBatchUpdates:(nullable NSArray<BMACollectionUpdate *> *)updates
       applyChangesToModelBlock:(nullable void (^)(void))applyChangesToModelBlock
                reloadCellBlock:(nullable void (^)(UITableViewCell *cell, NSIndexPath *indexPath))reloadCellBlock
                completionBlock:(nullable void (^)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
