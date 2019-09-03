//
//  RefillItem.m
//  OJOv1
//
//  Created by MilosHavel on 20/08/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "RefillItem.h"

@implementation RefillItem

- (instancetype) initWithItemName:(NSString *)itemName
                           andPar:(NSString *)par
                 andCurrentAmount:(NSString *)currentAmount
                andRefilledAmount:(NSString *)refilledAmount
                    andPriceTotal:(NSString *)priceTotal
                  andPricePerUnit:(NSString *)pricePerUnit
                     andPriceRate:(NSString *)priceRate
                   andDistributor:(NSString *)distributor{
    self = [super init];
    if (self) {
        self.itemName = itemName;
        self.par = par;
        self.currentAmount = currentAmount;
        self.refilledAmount = refilledAmount;
        self.priceTotal = priceTotal;
        self.pricePerUnit = pricePerUnit;
        self.priceRate = priceRate;
        self.distributor = distributor;
    }
    return self;
}


@end
