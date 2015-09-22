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

#import "BMACollectionUpdates.h"
#import <UIKit/UIKit.h>

@interface BMACollectionUpdate ()

@property (nonatomic, readwrite) BMACollectionUpdateType type;
@property (nonatomic, readwrite) id object;

@end

@implementation BMACollectionUpdate

- (instancetype)initWithType:(BMACollectionUpdateType)type object:(id)object {
    self = [super init];
    if (self) {
        _type = type;
        _object = object;
    }
    return self;
}

+ (void)calculateUpdatesForOldModel:(NSArray /*<BMAUpdatableCollectionSection *>*/ *)oldSections
                           newModel:(NSArray /*<BMAUpdatableCollectionSection *>*/ *)newSections
              sectionsPriorityOrder:(NSArray /*<NSString *>*/ *)sectionsPriorityOrder
               eliminatesDuplicates:(BOOL)eliminatesDuplicates
                         completion:(void (^)(NSArray /*<BMAUpdatableCollectionSection *>*/ *sections, NSArray /*<BMACollectionUpdate *>*/ *updates))completion {
    @autoreleasepool {
        // Define section updates: UICollectionView and UITableView cannot deal with simultaneous updates for both items and sections (internal exceptions are generated leading to inconsistent states), so once a section change is detected perform full content reload instead of batch updates.

        // Find inserted sections
        for (NSInteger newIndex = 0; newIndex < newSections.count; ++newIndex) {
            id<BMAUpdatableCollectionSection> newSection = newSections[newIndex];
            NSInteger oldIndex = NSNotFound;
            if (oldSections) {
                oldIndex = [oldSections indexOfObjectPassingTest:^BOOL(id<BMAUpdatableCollectionSection> oldSection, NSUInteger idx, BOOL *stop) {
                    return [newSection.uid isEqualToString:oldSection.uid];
                }];
            }

            if (oldIndex == NSNotFound) {
                completion(newSections, nil);
                return;
            }
        }

        // Find deleted or moved sections
        for (NSInteger oldIndex = 0; oldIndex < oldSections.count; ++oldIndex) {
            id<BMAUpdatableCollectionSection> oldSection = oldSections[oldIndex];
            NSInteger newIndex = [newSections indexOfObjectPassingTest:^BOOL(id<BMAUpdatableCollectionSection> newSection, NSUInteger idx, BOOL *stop) {
                return [newSection.uid isEqualToString:oldSection.uid];
            }];

            if (oldIndex != newIndex) {
                completion(newSections, nil);
                return;
            }
        }

        // Calculate new sections processing order
        NSMutableArray *newSectionsProcessingOrder = [[NSMutableArray alloc] init];
        if (sectionsPriorityOrder) {
            for (NSString *sectionId in sectionsPriorityOrder) {
                NSInteger index = [newSections indexOfObjectPassingTest:^BOOL(id<BMAUpdatableCollectionSection> newSection, NSUInteger idx, BOOL *stop) {
                    return [newSection.uid isEqualToString:sectionId];
                }];
                if (index != NSNotFound) {
                    NSNumber *sectionIndex = @(index);
                    if (![newSectionsProcessingOrder containsObject:sectionIndex]) {
                        [newSectionsProcessingOrder addObject:sectionIndex];
                    }
                }
            }
        }

        for (NSInteger i = 0; i < newSections.count; ++i) {
            NSNumber *sectionIndex = @(i);
            if (![newSectionsProcessingOrder containsObject:sectionIndex]) {
                [newSectionsProcessingOrder addObject:sectionIndex];
            }
        }

        // Guarantee items uniqueness
        NSMutableSet *newItemsSet = [[NSMutableSet alloc] init];
        for (NSNumber *sectionIndex in newSectionsProcessingOrder) {
            id<BMAUpdatableCollectionSection> newSection = newSections[sectionIndex.integerValue];
            NSMutableIndexSet *notUniqueItemIndexes;
            for (NSInteger j = 0; j < newSection.items.count; ++j) {
                id<BMAUpdatableCollectionItem> item = newSection.items[j];
                if ([newItemsSet containsObject:item.uid]) {
                    if (!notUniqueItemIndexes) {
                        notUniqueItemIndexes = [[NSMutableIndexSet alloc] init];
                    }
                    [notUniqueItemIndexes addIndex:j];
                } else {
                    [newItemsSet addObject:item.uid];
                }
            }
            if (notUniqueItemIndexes) {
                // Remove occurence of not unique items from result sections
                NSMutableArray *updatedItems = [[NSMutableArray alloc] initWithArray:newSection.items];
                [updatedItems removeObjectsAtIndexes:notUniqueItemIndexes];
                newSection.items = [updatedItems copy];
            }
            if (!eliminatesDuplicates) {
                [newItemsSet removeAllObjects];
            }
        }

        // Pre-calculate new items indexPaths lookup table
        NSMutableDictionary *newItemsLookupTable = [[NSMutableDictionary alloc] init];
        for (NSInteger i = 0; i < newSections.count; ++i) {
            id<BMAUpdatableCollectionSection> newSection = newSections[i];
            NSMutableDictionary *newItemsInSection;
            if (eliminatesDuplicates) {
                newItemsInSection = newItemsLookupTable;
            } else {
                newItemsInSection = [[NSMutableDictionary alloc] init];
                newItemsLookupTable[newSection.uid] = newItemsInSection;
            }
            for (NSInteger j = 0; j < newSection.items.count; ++j) {
                id<BMAUpdatableCollectionItem> item = newSection.items[j];
                newItemsInSection[item.uid] = [NSIndexPath indexPathForItem:j inSection:i];
            }
        }

        // Pre-calculate old items indexPaths lookup table
        NSMutableDictionary *oldItemsLookupTable = [[NSMutableDictionary alloc] init];
        for (NSInteger i = 0; i < oldSections.count; ++i) {
            id<BMAUpdatableCollectionSection> oldSection = oldSections[i];
            NSMutableDictionary *oldItemsInSection;
            if (eliminatesDuplicates) {
                oldItemsInSection = oldItemsLookupTable;
            } else {
                oldItemsInSection = [[NSMutableDictionary alloc] init];
                oldItemsLookupTable[oldSection.uid] = oldItemsInSection;
            }
            for (NSInteger j = 0; j < oldSection.items.count; ++j) {
                id<BMAUpdatableCollectionItem> item = oldSection.items[j];
                oldItemsInSection[item.uid] = [NSIndexPath indexPathForItem:j inSection:i];
            }
        }

        // Calculate updates
        NSMutableArray *updates = [[NSMutableArray alloc] init];

        // Calculate inserted items
        for (NSInteger i = 0; i < newSections.count; ++i) {
            id<BMAUpdatableCollectionSection> newSection = newSections[i];
            NSDictionary *lookupTable;
            if (eliminatesDuplicates) {
                lookupTable = oldItemsLookupTable;
            } else {
                lookupTable = oldItemsLookupTable[newSection.uid];
            }
            for (NSInteger j = 0; j < newSection.items.count; ++j) {
                id<BMAUpdatableCollectionItem> item = newSection.items[j];
                NSIndexPath *oldIndexPath = lookupTable[item.uid];
                if (!oldIndexPath) {
                    [updates addObject:[BMACollectionItemUpdate updateWithType:BMACollectionUpdateTypeInsert
                                                                     indexPath:nil
                                                                  newIndexPath:[NSIndexPath indexPathForItem:j inSection:i]
                                                                        object:item.uid]];
                }
            }
        }

        // Calculate deleted and moved items
        NSMutableSet *indexPathsForDeletedItems = [NSMutableSet set];
        NSMutableSet *indexPathsForMovedItems = [NSMutableSet set];

        for (NSInteger oldSectionIndex = 0; oldSectionIndex < oldSections.count; ++oldSectionIndex) {
            id<BMAUpdatableCollectionSection> oldSection = oldSections[oldSectionIndex];
            NSDictionary *lookupTable;
            if (eliminatesDuplicates) {
                lookupTable = newItemsLookupTable;
            } else {
                lookupTable = newItemsLookupTable[oldSection.uid];
            }
            for (NSInteger oldIndex = 0; oldIndex < oldSection.items.count; ++oldIndex) {
                id<BMAUpdatableCollectionItem> item = oldSection.items[oldIndex];
                NSIndexPath *newIndexPath = lookupTable[item.uid];
                if (!newIndexPath) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:oldIndex inSection:oldSectionIndex];
                    [indexPathsForDeletedItems addObject:indexPath];
                    [updates addObject:[BMACollectionItemUpdate updateWithType:BMACollectionUpdateTypeDelete
                                                                     indexPath:[NSIndexPath indexPathForItem:oldIndex inSection:oldSectionIndex]
                                                                  newIndexPath:nil
                                                                        object:item.uid]];
                } else {
                    id<BMAUpdatableCollectionSection> newSection = newSections[newIndexPath.section];
                    if ([newSection.uid isEqualToString:oldSection.uid] && oldIndex == newIndexPath.item) {
                        // Item remains at the same place
                        continue;
                    }

                    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:oldIndex inSection:oldSectionIndex];
                    [indexPathsForMovedItems addObject:oldIndexPath];

                    [updates addObject:[BMACollectionItemUpdate updateWithType:BMACollectionUpdateTypeMove
                                                                     indexPath:oldIndexPath
                                                                  newIndexPath:newIndexPath
                                                                        object:item.uid]];
                }
            }
        }

        // Calculate items to be reload
        for (NSInteger i = 0; i < oldSections.count; ++i) {
            id<BMAUpdatableCollectionSection> oldSection = oldSections[i];

            NSDictionary *lookupTable;
            if (eliminatesDuplicates) {
                lookupTable = newItemsLookupTable;
            } else {
                lookupTable = newItemsLookupTable[oldSection.uid];
            }

            for (NSInteger j = 0; j < oldSection.items.count; ++j) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                // UITableView and UICollectionView have issues with updates for items which are being moved or deleted, so skip generation of such changes as according to tests moved items get updated during transition
                if ([indexPathsForDeletedItems containsObject:indexPath] || [indexPathsForMovedItems containsObject:indexPath]) {
                    continue;
                }

                id<BMAUpdatableCollectionItem> item = oldSection.items[j];
                NSIndexPath *newIndexPath = lookupTable[item.uid];
                if (!newIndexPath) {
                    continue;
                }

                id<BMAUpdatableCollectionSection> newSection = newSections[newIndexPath.section];
                id<BMAUpdatableCollectionItem> newItem = newSection.items[newIndexPath.item];

                if (![item isEqual:newItem]) {
                    [updates addObject:[BMACollectionItemUpdate updateWithType:BMACollectionUpdateTypeReload
                                                                     indexPath:indexPath
                                                                  newIndexPath:nil
                                                                        object:item.uid]];
                }
            }
        }

        completion(newSections, updates);
    }
}

@end

static inline NSString *NSStringFromBMACollectionUpdateType(BMACollectionUpdateType type) {
    if (type == BMACollectionUpdateTypeInsert) {
        return @"insert";
    } else if (type == BMACollectionUpdateTypeDelete) {
        return @"delete";
    } else if (type == BMACollectionUpdateTypeMove) {
        return @"move";
    } else if (type == BMACollectionUpdateTypeReload) {
        return @"reload";
    }
    return @"unknown";
}

@implementation BMACollectionItemUpdate

+ (instancetype)updateWithType:(BMACollectionUpdateType)type
                     indexPath:(NSIndexPath *)indexPath
                  newIndexPath:(NSIndexPath *)newIndexPath
                        object:(id)object {
    return [[self alloc] initWithType:type
                            indexPath:indexPath
                         newIndexPath:newIndexPath
                               object:object];
}

- (instancetype)initWithType:(BMACollectionUpdateType)type
                   indexPath:(NSIndexPath *)indexPath
                newIndexPath:(NSIndexPath *)newIndexPath
                      object:(id)object {
    self = [self initWithType:type object:object];
    if (self) {
        _indexPath1 = indexPath;
        _indexPath2 = newIndexPath;
    }
    return self;
}

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"%@ { %@: ", super.description, NSStringFromBMACollectionUpdateType(self.type)];
    NSString *indexPath1Description = self.indexPath1 ? [NSString stringWithFormat:@"'%lu - %lu'", (unsigned long)self.indexPath1.section, (unsigned long)self.indexPath1.item] : nil;
    NSString *indexPath2Description = self.indexPath2 ? [NSString stringWithFormat:@"'%lu - %lu'", (unsigned long)self.indexPath2.section, (unsigned long)self.indexPath2.item] : nil;
    if (indexPath1Description && indexPath2Description) {
        description = [description stringByAppendingFormat:@"%@ -> %@ }", indexPath1Description, indexPath2Description];
    } else if (indexPath1Description) {
        description = [description stringByAppendingFormat:@"%@ }", indexPath1Description];
    } else if (indexPath2Description) {
        description = [description stringByAppendingFormat:@"%@ }", indexPath2Description];
    }
    return description;
}

- (BOOL)isItemUpdate {
    return YES;
}

@end

@implementation BMACollectionSectionUpdate

+ (instancetype)updateWithType:(BMACollectionUpdateType)type
                  sectionIndex:(NSUInteger)sectionIndex
               newSectionIndex:(NSUInteger)newSectionIndex
                        object:(id)object {
    return [[self alloc] initWithType:type
                         sectionIndex:sectionIndex
                      newSectionIndex:newSectionIndex
                               object:object];
}

- (instancetype)initWithType:(BMACollectionUpdateType)type
                sectionIndex:(NSUInteger)sectionIndex
             newSectionIndex:(NSUInteger)newSectionIndex
                      object:(id)object {
    self = [self initWithType:type object:object];
    if (self) {
        _section1 = sectionIndex;
        _section2 = newSectionIndex;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ { %@: %lu -> %lu }", super.description, NSStringFromBMACollectionUpdateType(self.type), (unsigned long)self.section1, (unsigned long)self.section2];
}

- (BOOL)isSectionUpdate {
    return YES;
}

@end
