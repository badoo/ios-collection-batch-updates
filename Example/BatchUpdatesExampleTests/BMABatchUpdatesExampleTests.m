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

@interface BMAExampleItemsSection : NSObject <BMAUpdatableCollectionSection>
- (instancetype)initWithId:(NSString *)sectionId items:(NSArray *)items;
@end

@interface BMAExampleItem : NSObject <BMAUpdatableCollectionItem>
- (instancetype)initWithId:(NSNumber *)itemId userInfo:(id)userInfo;
@end

#define ITEM_WITH_INFO(ID, USER_INFO) [[BMAExampleItem alloc] initWithId:@(ID) userInfo:@(USER_INFO)]
#define ITEM(ID) [[BMAExampleItem alloc] initWithId:@(ID) userInfo:nil]

@implementation BMABatchUpdatesExampleTests

- (void)invokeTest {
    if (![[self class] shouldRunTests]) {
        return;
    }

    [super invokeTest];
}

- (void)setUp {
    [super setUp];

    _containsUniqueUsers = YES;
    _sections = @[];
}

- (void)tearDown {
    [self teardownController];
    [super tearDown];
}

#pragma mark -

- (void)setupController {
    XCTFail(@"To be overridden");
}

- (void)teardownController {
    XCTFail(@"To be overridden");
}

+ (BOOL)shouldRunTests {
    return NO;
}

#pragma mark - Change model

- (void)setInternalSections:(NSArray *)sections {
    _sections = sections;
}

- (NSArray *)internalSections {
    return _sections;
}

- (void)setSections:(NSArray *)newSections {
    XCTFail(@"To be overridden");
}

#pragma mark - Given Empty Model

- (void)testThat_GivenEmptyModel_WhenInsertNewSection_ThenCollectionViewUpdatesSuccessfully {
    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
        ]));
}

- (void)testThat_GivenEmptyModel_WhenInsertNewSectionWith1Item_ThenCollectionViewUpdatesSuccessfully {
    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_GivenEmptyModel_WhenInsertNewSectionWith3Items_ThenCollectionViewUpdatesSuccessfully {
    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(1), ITEM(2) ]]
        ]));
}

#pragma mark - Given Model With 1 Empty Section

- (void)testThat_Given1EmptySection_WhenInsertItem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_Given1EmptySection_WhenInsert3Items_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(1), ITEM(2) ]]
        ]));
}

- (void)testThat_Given1EmptySection_WhenInsertNewSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given1EmptySection_WhenInsert1SectionWith1Item_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_Given1EmptySection_WhenInsert1SectionWith3Items_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0), ITEM(1), ITEM(2) ]]
        ]));
}

- (void)testThat_Given1EmptySection_WhenInsert1SectionWith1ItemAndNewItem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_Given1EmptySection_WhenRemoveSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[]));
}

#pragma mark - Given Model With 1 Section and 1 Item

- (void)testThat_Given1SectionWith1Item_WhenInsertItemInTheEnd_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(1) ]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsertItemInTheBeginning_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1), ITEM(0) ]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenRemoveItem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenRemoveSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsertNewSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionWith1Item_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionInTheBeginning_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionAndMoveItemIntoIt_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionAndRemoveItem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsertItemAtTheEndAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES), ITEM(1) ]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsertItemInTheBeginningAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1), ITEM_WITH_INFO(0, YES) ]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsertNewSectionAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionWith1ItemAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionInTheBeginningAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionAndMoveItemIntoItAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(0, YES) ]],
        ]));
}

- (void)testThat_Given1SectionWith1Item_WhenInsert1SectionAndRemoveItemAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(0, YES) ]],
        ]));
}

#pragma mark - Given Model With 2 Empty Sections

- (void)testThat_Given2EmptySections_WhenInsertItemIn1stSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenInsertItemIn2ndSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenInsertItemInBothSections_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenInsertItemsInBothSections_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(2), ITEM(3) ]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenSwapThem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenSwapThemAndInsertItem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenSwapThemAndInsertItems_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenRemove1stSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenRemove2ndSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given2EmptySections_WhenRemoveOneSectionAndInsertItem_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]]
        ]));
}

#pragma mark - Given Model With 2 Sections

- (void)testThat_Given2Sections_WhenInsertItemIn1stSection_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(2) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapSections_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapSectionsAndSwapItems_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapItems_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenRemoveItemAndMoveAnother_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given2Sections_WhenRemoveItemAndInserNew_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(2) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapItemsAndInserNew_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given2Sections_WhenRemoveItems_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given2Sections_WhenRemoveSections_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheEnd_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheMiddle_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheBeginning_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheEndWithItems_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(1), ITEM(2) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheEndAndItems_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(2) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1), ITEM(3) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(1), ITEM(4) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertItemIn1stSectionAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES), ITEM(2) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapSectionsAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapSectionsAndSwapItemsAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(1, YES) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenSwapItemsAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(1, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(0, YES) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenRemoveItemAndMoveAnotherAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
        ]));
}

- (void)testThat_Given2Sections_WhenRemoveItemAndInserNewAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(2) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheEndAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheMiddleAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheBeginningAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]],
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheEndWithItemsAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM_WITH_INFO(1, YES), ITEM(2) ]]
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewSectionInTheEndAndItemsAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES), ITEM(2) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, YES), ITEM(3) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM_WITH_INFO(1, YES), ITEM(4) ]]
        ]));
}

#pragma mark - Special cases

- (void)testThat_Given3Sections_WhenMoveItemTo2ndSectionFrom3rdAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(11, NO), ITEM_WITH_INFO(12, NO), ITEM(13), ITEM(14) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(22), ITEM(23), ITEM(24), ITEM(25), ITEM(26), ITEM(27) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(32), ITEM(33), ITEM(34), ITEM(35), ITEM(36), ITEM(37), ITEM(38), ITEM_WITH_INFO(0, NO), ITEM(39) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(11, YES), ITEM_WITH_INFO(12, YES), ITEM(13), ITEM(14) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(0, YES), ITEM(22), ITEM(23), ITEM(24), ITEM(25), ITEM(26) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(32), ITEM(33), ITEM(34), ITEM(35) ]]
        ]));
}

- (void)testThat_Given1Sections_WhenInsertAndDeleteAndMoveAndUpdate_ThenCollectionViewUpdatesSuccessfully {
    // Since the issue may not be reproduced right away, run the same case 100 times
    for (NSUInteger i = 0; i < 100; ++i) {
        _sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(1), ITEM(2), ITEM_WITH_INFO(3, NO), ITEM(4), ITEM_WITH_INFO(5, NO), ITEM(6), ITEM(7), ITEM(8), ITEM(9) ]]
        ];

        [self setupController];

        XCTAssertNoThrow((
                             self.sections = @[
                                 [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(2), ITEM(0), ITEM(1), ITEM_WITH_INFO(3, YES), ITEM(10), ITEM_WITH_INFO(5, YES), ITEM(4), ITEM(6), ITEM(11), ITEM(7) ]]
                             ]),
                         @"Exception during CollectionView update");

        [self teardownController];
    }
}

#pragma mark - Not Unique items in Model

- (void)testThat_Given2Sections_WhenInsertNewItemsWithSimilarIds_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1), ITEM(1) ]],
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewItemsWithSimilarIdsInDifferentSections_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1), ITEM(0) ]],
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewItemsWithSimilarIdsAndDifferentInfo_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, NO), ITEM_WITH_INFO(0, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO), ITEM_WITH_INFO(1, NO) ]],
        ]));
}

- (void)testThat_Given2Sections_WhenInsertNewItemsWithSimilarIdsAndDifferentInfoInDifferentSections_ThenCollectionViewUpdatesSuccessfully {
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM_WITH_INFO(0, YES), ITEM_WITH_INFO(1, YES) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM_WITH_INFO(1, NO), ITEM_WITH_INFO(0, YES) ]],
        ]));
}

#pragma mark - Support Not Unique items in different sections

- (void)testThat_Given3SectionsThatSupportNotUniqueItems_WhenInsertNewItemsWithSimilarIdsInDifferentSections_ThenCollectionViewUpdatesSuccessfully {
    _containsUniqueUsers = NO;
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(0) ]]
        ]));

    XCTAssert(self.sections.count == 3);
    XCTAssert([self.sections[0] items].count == 1);
    XCTAssert([self.sections[1] items].count == 1);
    XCTAssert([self.sections[2] items].count == 1);
}

- (void)testThat_Given3SectionsThatSupportNotUniqueItems_WhenInsertNewItemsWithSimilarIds_ThenCollectionViewUpdatesSuccessfully {
    _containsUniqueUsers = NO;
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0), ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0), ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(0), ITEM(0) ]]
        ]));

    XCTAssert(self.sections.count == 3);
    XCTAssert([self.sections[0] items].count == 1);
    XCTAssert([self.sections[1] items].count == 1);
    XCTAssert([self.sections[2] items].count == 1);
}

- (void)testThat_Given3SectionsThatSupportNotUniqueItems_WhenInsertNewItemsWithSimilarIdsInOtherSections_ThenCollectionViewUpdatesSuccessfully {
    _containsUniqueUsers = NO;
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(0) ]]
        ]));

    XCTAssert(self.sections.count == 3);
    XCTAssert([self.sections[0] items].count == 1);
    XCTAssert([self.sections[1] items].count == 1);
    XCTAssert([self.sections[2] items].count == 1);
}

- (void)testThat_Given3SectionsThatSupportNotUniqueItems_WhenInsertNewItemsWithSimilarIdsInOtherSections_2_ThenCollectionViewUpdatesSuccessfully {
    _containsUniqueUsers = NO;
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(2), ITEM(0) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(3), ITEM(0) ]]
        ]));
}

- (void)testThat_Given3SectionsThatSupportNotUniqueItems_WhenInsertNewItemsWithSimilarIdsInOtherSections_3_ThenCollectionViewUpdatesSuccessfully {
    _containsUniqueUsers = NO;
    _sections = @[
        [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0) ]],
        [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
        [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(0) ]]
    ];

    [self setupController];

    XCTAssertNoThrow((
        self.sections = @[
            [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0), ITEM(2) ]],
            [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(3) ]]
        ]));
}

@end
