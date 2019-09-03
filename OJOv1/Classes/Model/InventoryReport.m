//
//  InventoryReport.m
//  OJOv1
//
//  Created by MilosHavel on 09/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "InventoryReport.h"

@implementation InventoryReport


- (instancetype) initWithItemName:(NSString *)itemName
                 andWithFrequency:(NSInteger)frequency
                  andWithFullOpen:(NSInteger)fullOpen
             andWithOpenBottleWet:(NSString *)openBottleWet
                    andWithAmount:(NSString *)amount
                       andWithPar:(NSString *)par
         andWithNewsOpenBottleWet:(NSString *)newsOpenBottleWet
                andWithNewsAmount:(NSString *)newsAmount
         andWithItemBottleFullWet:(NSString *)itemBottleFullWet
          andWithItemBottleEmpWet:(NSString *)itemBottleEmpWet
                andWithItemLiqWet:(NSString *)itemLiqWet
                andWithItemServBt:(NSString *)itemServBt
               andWithItemServWet:(NSString *)itemServWet
                 andWithItemPrice:(NSString *)itemPrice
                andWithCashDetail:(NSString *)cashDetail{
    
    
    
    self = [super init];
    if (self) {
        self.itemName = itemName;
        self.frequency = frequency;
        self.fullOpen = fullOpen;
        self.openBottleWet = openBottleWet;
        self.amount = amount;
        self.par = par;
        self.newsOpenBottleWet = newsOpenBottleWet;
        self.newsAmount = newsAmount;
        self.itemBottleFullWet = itemBottleFullWet;
        self.itemBottleEmpWet = itemBottleEmpWet;
        self.itemLiqWet = itemLiqWet;
        self.itemServBt = itemServBt;
        self.itemServWet = itemServWet;
        self.itemPrice = itemPrice;
        self.cashDetail = cashDetail;
    }
    
    return self;
    
}

@end
