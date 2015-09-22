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

#import "BMACollectionUpdates.h"  // BMAUpdatableCollectionItem, BMAUpdatableCollectionSection
#import "BMAExampleViewController.h"

#define SHOW_CONFIGURATION_CONTROLS 0

@interface BMAExampleItemsSection : NSObject <BMAUpdatableCollectionSection>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *uid;
- (instancetype)initWithId:(NSString *)sectionId items:(NSArray *)items;
@end

@interface BMAExampleItem : NSObject <BMAUpdatableCollectionItem>
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) id userInfo;
- (instancetype)initWithId:(NSNumber *)itemId userInfo:(id)userInfo;
@end

#define ITEM(ID, USER_INFO) [[BMAExampleItem alloc] initWithId:@(ID) userInfo:@(USER_INFO)]

@interface BMAExampleViewController ()

@property (nonatomic) NSArray *sections;
@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) UISwitch *orderedSectionsSwitch;
@property (nonatomic) UISwitch *fixedSectionsSwitch;
@property (nonatomic) UISwitch *uniqueItemsSwitch;
@property (nonatomic) UISwitch *uniqueItemsInListSwitch;
@property (nonatomic) UISlider *amountSlider;
@property (nonatomic) UISlider *speedSlider;

@property (nonatomic, readwrite) NSDictionary *itemColors;
@property (nonatomic) NSArray *changeset;
@property (nonatomic) NSInteger index;

@end

@implementation BMAExampleViewController

- (void)performBatchUpdates:(NSArray *)updates forSections:(NSArray *)sections {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSArray *)primitiveSections {
    return _sections;
}

- (void)setPrimitiveSections:(NSArray *)sections {
    _sections = sections;
}

+ (UIEdgeInsets)contentInsets {
    const CGFloat topInset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + [self segmentedControlHeight];
    const CGFloat bottomInset = 50.0;
    return UIEdgeInsetsMake(topInset, 0.0, bottomInset, 0.0);
}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    self.itemColors = @{
        @0 : [UIColor purpleColor],
        @1 : [UIColor blueColor],
        @2 : [UIColor greenColor],
        @3 : [UIColor orangeColor],
        @4 : [UIColor brownColor],
        @5 : [UIColor grayColor],
    };

    const CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    const CGFloat viewHeight = CGRectGetHeight(self.view.bounds);

    // Predefined combinations
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9" ]];
    [self.segmentedControl addTarget:self action:@selector(changeData) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.frame = CGRectMake(10.0, 20.0, viewWidth - 20.0, [[self class] segmentedControlHeight]);

    // Keeps order of sections
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 170., viewHeight - 75.0, 100.0, 20.0)];
    orderLabel.textColor = [UIColor blackColor];
    orderLabel.text = @"Fixed Order";

    self.orderedSectionsSwitch = [[UISwitch alloc] init];
    self.orderedSectionsSwitch.on = YES;
    self.orderedSectionsSwitch.center = CGPointMake(viewWidth - 40, viewHeight - 65);

    // Fixed number of sections
    UILabel *fixedLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 180, viewHeight - 110, 130, 20)];
    fixedLabel.textColor = [UIColor blackColor];
    fixedLabel.text = @"Fixed Number";

    self.fixedSectionsSwitch = [[UISwitch alloc] init];
    self.fixedSectionsSwitch.on = YES;
    self.fixedSectionsSwitch.center = CGPointMake(viewWidth - 40, viewHeight - 100);

    // Unique items
    UILabel *uniqueItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 170, viewHeight - 145, 100, 20)];
    uniqueItemsLabel.textColor = [UIColor blackColor];
    uniqueItemsLabel.text = @"Uique Items";

    self.uniqueItemsSwitch = [[UISwitch alloc] init];
    self.uniqueItemsSwitch.on = YES;
    self.uniqueItemsSwitch.center = CGPointMake(viewWidth - 40, viewHeight - 135);

    // Only Unique items in List
    UILabel *uniqueItemsInListLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 180, viewHeight - 180, 120, 20)];
    uniqueItemsInListLabel.textColor = [UIColor blackColor];
    uniqueItemsInListLabel.text = @"Unique in List";

    self.uniqueItemsInListSwitch = [[UISwitch alloc] init];
    self.uniqueItemsInListSwitch.on = YES;
    self.uniqueItemsInListSwitch.center = CGPointMake(viewWidth - 40, viewHeight - 170);

    // Number of items
    self.amountSlider = [[UISlider alloc] initWithFrame:CGRectMake(viewWidth - 140, viewHeight - 210, 130, 20)];
    self.amountSlider.minimumValue = 5;
    self.amountSlider.maximumValue = 55;
    self.amountSlider.value = 30;

    // Speed
    self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(viewWidth - 140, viewHeight - 245, 130, 20)];
    self.speedSlider.minimumValue = 0.5;
    self.speedSlider.maximumValue = 5;
    self.speedSlider.value = 1.5;

#if SHOW_CONFIGURATION_CONTROLS  // {
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:orderLabel];
    [self.view addSubview:self.orderedSectionsSwitch];
    [self.view addSubview:fixedLabel];
    [self.view addSubview:self.fixedSectionsSwitch];
    [self.view addSubview:uniqueItemsLabel];
    [self.view addSubview:self.uniqueItemsSwitch];
    [self.view addSubview:uniqueItemsInListLabel];
    [self.view addSubview:self.uniqueItemsInListSwitch];
    [self.view addSubview:self.amountSlider];
    [self.view addSubview:self.speedSlider];
#endif  // }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self nextChange];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super viewWillDisappear:animated];
}

- (void)nextChange {
    NSMutableArray *sections = [[NSMutableArray alloc] init];

    NSMutableArray *sectionIds = [[NSMutableArray alloc] init];
    NSInteger numberOfSections = (self.fixedSectionsSwitch.isOn ? 3 : arc4random() % 4);

    for (int i = 0; i < numberOfSections; ++i) {
        [sectionIds addObject:[NSString stringWithFormat:@"%d", i]];
    }

    NSMutableArray *itemsSet = [[NSMutableArray alloc] init];
    NSInteger numberOfItems = arc4random() % ((int)self.amountSlider.value);
    for (int i = 0; i < numberOfItems; ++i) {
        [itemsSet addObject:ITEM(i, arc4random() % 2 ? YES : NO)];
    }

    NSInteger maxNumberOfItemsInSection = (int)(self.amountSlider.value / 3) + 1;
    for (int i = 0; i < numberOfSections && sectionIds.count > 0; ++i) {
        int sectionIndex = (self.orderedSectionsSwitch.isOn ? 0 : arc4random() % sectionIds.count);

        NSString *sectionId = sectionIds[sectionIndex];
        [sectionIds removeObjectAtIndex:sectionIndex];
        NSMutableArray *items = [[NSMutableArray alloc] init];

        NSInteger numberOfItemsInSection = arc4random() % maxNumberOfItemsInSection;
        for (int i = 0; i < numberOfItemsInSection && itemsSet.count > 0; ++i) {
            if (self.uniqueItemsSwitch.isOn) {
                int itemIndex = arc4random() % itemsSet.count;
                BMAExampleItem *item = itemsSet[itemIndex];
                [itemsSet removeObjectAtIndex:itemIndex];
                [items addObject:item];
            } else {
                int itemIndex = arc4random() % numberOfItemsInSection;
                [items addObject:ITEM(itemIndex, arc4random() % 2 ? YES : NO)];
            }
        }

        BMAExampleItemsSection *section = [[BMAExampleItemsSection alloc] initWithId:sectionId items:items];
        [sections addObject:section];
    }
    self.sections = sections;

    [self performSelector:@selector(nextChange) withObject:nil afterDelay:self.speedSlider.value];
}

- (void)changeData {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1, YES), ITEM(2, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0, NO) ]]
            ];
            break;
        case 1:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0, YES), ITEM(2, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1, NO), ITEM(2, YES) ]]
            ];
            break;
        case 2:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1, YES), ITEM(3, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(2, NO), ITEM(3, YES), ITEM(1, YES), ITEM(1, YES) ]],
            ];
            break;
        case 3:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1, YES) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(3, YES), ITEM(4, YES), ITEM(5, NO) ]]
            ];
            break;
        case 4:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1, YES) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(4, NO), ITEM(3, NO) ]]
            ];
            break;
        case 5:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(1, YES) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(2, NO) ]],
            ];
            break;
        case 6:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0, NO), ITEM(1, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(2, NO), ITEM(3, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(4, NO), ITEM(5, NO) ]],
            ];
            break;
        case 7:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(0, NO), ITEM(1, NO), ITEM(2, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(3, NO), ITEM(4, NO), ITEM(5, NO) ]],
            ];
            break;
        case 8:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[ ITEM(1, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[ ITEM(4, NO) ]],
            ];
            break;
        case 9:
            self.sections = @[
                [[BMAExampleItemsSection alloc] initWithId:@"0" items:@[]],
                [[BMAExampleItemsSection alloc] initWithId:@"1" items:@[ ITEM(0, NO), ITEM(1, NO), ITEM(2, NO), ITEM(3, NO), ITEM(4, NO), ITEM(5, NO) ]],
                [[BMAExampleItemsSection alloc] initWithId:@"2" items:@[]]
            ];
            break;
        default:
            break;
    }
}

+ (NSString *)descriptionForSections:(NSArray *)sections {
    NSMutableString *description = [[NSMutableString alloc] init];
    for (NSUInteger i = 0, count = sections.count; i < count; ++i) {
        BMAExampleItemsSection *section = sections[i];
        [description appendString:[[section.items valueForKey:@"uid"] componentsJoinedByString:@" "]];
        if (i != count - 1) {
            [description appendString:@" — "];
        }
    }
    return description;
}

- (void)setSections:(NSArray *)newSections {
    NSLog(@"Old: %@", self.title);

    self.title = [[self class] descriptionForSections:newSections];
    NSLog(@"New: %@", self.title);

    NSArray *oldSections = [self.sections copy];
    [BMACollectionUpdate calculateUpdatesForOldModel:oldSections
                                            newModel:newSections
                               sectionsPriorityOrder:nil
                                eliminatesDuplicates:[self.uniqueItemsInListSwitch isOn]
                                          completion:^(NSArray *sections, NSArray *updates) {
                                              NSLog(@"%@", updates);
                                              self.title = [[self class] descriptionForSections:sections];
                                              NSLog(@"Result: %@", self.title);
                                              [self performBatchUpdates:updates forSections:sections];
                                          }];
}

#pragma mark - Constants

+ (CGFloat)segmentedControlHeight {
#if SHOW_CONFIGURATION_CONTROLS  //
    return 44.0;
#endif  // }
    return 0.0;
}

@end

#pragma mark -

@implementation BMAExampleItemsSection

- (instancetype)initWithId:(NSString *)sectionId items:(NSArray *)items {
    self = [super init];
    if (self) {
        self.uid = sectionId;
        self.items = items;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ { uid = %@, items = %@ }", super.description, self.uid, self.items];
}

@end

#pragma mark -

@implementation BMAExampleItem

- (instancetype)initWithId:(NSNumber *)itemId userInfo:(id)userInfo {
    self = [super init];
    if (self) {
        _uid = itemId.stringValue;
        _userInfo = userInfo;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToItem:(BMAExampleItem *)object];
}

- (BOOL)isEqualToItem:(BMAExampleItem *)item {
    return [self.uid isEqual:item.uid] && (self.userInfo == item.userInfo || [self.userInfo isEqual:item.userInfo]);
}

- (NSUInteger)hash {
    return self.uid.hash ^ [self.userInfo hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ { %@ }", super.description, self.uid];
}

@end
