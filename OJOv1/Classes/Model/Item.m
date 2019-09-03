//
//  Item.m
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "Item.h"

@implementation Item

-(instancetype) initWithItemName:(NSString *) itemName
              andWithFullAndOpen:(NSInteger) fullAndOpen
             andWithCategoryName:(NSString *) categoryName
                    andFrequency:(NSInteger) frequency
                        andPrice:(NSString *) price {
    self = [super init];
    if (self) {
        self.itemName = itemName;
        self.fullAndOpen = fullAndOpen;
        self.categoryName = categoryName;
        self.frequency = frequency;
        self.price = price;
    }
    
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.itemName = dictionary[ITEM_NAME];
        self.fullAndOpen = [dictionary[FULL_OPEN] intValue];
        self.categoryName = dictionary[ITEM_CATEGORY];
        self.frequency = [dictionary[FREQUENCY] intValue];
        self.price = dictionary[PRICE];
    }
    return self;
}

@end
