//
//  ItemFull.m
//  OJOv1
//
//  Created by MilosHavel on 16.03.2021.
//  Copyright © 2021 MilosHavel. All rights reserved.
//

#import "ItemFull.h"

@implementation ItemFull

- (instancetype) initWithDictionary:(NSDictionary *) dictionary{
    
    self = [super init];
    if (self) {
        self.itemName = dictionary[INVENTORY_ITEM_NAME];
        self.fullAndOpen = [dictionary[INVENTORY_FULL_OPEN] intValue];
        self.categoryName = dictionary[INVENTORY_CATEGORY];
        self.btFullWet = dictionary[INVENTORY_BT_FULL_WET];
        self.btEmpWet = dictionary[INVENTORY_BT_EMP_WET];
        self.liqWet = dictionary[INVENTORY_LIQ_WET];
        self.servBt = dictionary[INVENTORY_SERV_BT];
        self.servWet = dictionary[INVENTORY_SERV_WET];
        self.price = dictionary[INVENTORY_ITEM_PRICE];
        self.frequency =[dictionary[INVENTORY_FRUQUENCY] intValue];
        self.activedLocationArray = dictionary[INVENTORY_ACTIVED_LOCATIONS];
        

    }
    return self;
}

- (instancetype) initWithItemId: (NSInteger) itemId
                andWithItemName:(NSString*)itemName
             andWithFullAndOpen:(NSInteger)fullAndOpen
            andWithCategoryName:(NSString*)categoryName
               andWithBtFullWet:(NSString*)btFullWet
                andWithBtEmpWet:(NSString*)btEmpWet
                  andWithLiqWet:(NSString*)liqWet
                  andWithServBt:(NSString*)servBt
                 andWithServWet:(NSString*)servWet
                   andWithprice:(NSString*)price
               andWithFrequence:(NSInteger)frequency
    andWithActivedLocationArray:(NSMutableArray*)activedLocationArray{
    
    
    self = [super init];
    if (self) {
        self.itemId = itemId;
        self.itemName = itemName;
        self.fullAndOpen = fullAndOpen;
        self.categoryName = categoryName;
        self.btFullWet = btFullWet;
        self.btEmpWet = btEmpWet;
        self.liqWet = liqWet;
        self.servBt = servBt;
        self.servWet = servWet;
        self.price = price;
        self.frequency = frequency;
        self.activedLocationArray = activedLocationArray;
    }
    
    return self;
    
}

@end
