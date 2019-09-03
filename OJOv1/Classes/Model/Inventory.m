//
//  Inventory.m
//  OJOv1
//
//  Created by MilosHavel on 16/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "Inventory.h"

@implementation Inventory

- (instancetype) initWithItemName:(NSString *) itemName
                 andWithFrequency:(NSInteger) frequency
                  andWithFullOpen:(NSInteger) fullOpen
             andWithOpenBottleWet:(NSString *) openBottleWet
                       andWithPar:(NSString *) par
                 andWithItemPrice:(NSString *) itemPrice
                        andAmount:(NSString *) amount
                      andCategory:(NSString *) category {

    self = [super init];
    if (self) {
        self.itemName = itemName;
        self.frequency = frequency;
        self.fullOpen = fullOpen;
        self.openBottleWet = openBottleWet;
        self.par = par;
        self.itemPrice = itemPrice;
        self.amount = amount;
        self.category = category;
    }
    return  self;

}

- (instancetype) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    if (self) {
        self.itemName = dictionary[INVENTORY_ITEM_NAME];
        self.frequency =[dictionary[INVENTORY_FRUQUENCY] intValue];
        self.openBottleWet = dictionary[INVENTORY_OPEN_BOTTLE_WET];
        self.par = dictionary[INVENTORY_PAR];
        self.amount = dictionary[INVENTORY_AMOUNT];
    }
    return self;
}

@end
