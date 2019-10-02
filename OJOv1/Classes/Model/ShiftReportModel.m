

//
//  ShiftReportModel.m
//  OJOv1
//
//  Created by Chris Palo on 16/02/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "ShiftReportModel.h"

@implementation ShiftReportModel

- (instancetype) initWithItemName:(NSString *) itemName
                   andWithMovedIn:(NSString *) movedIn
                  andWithMovedOut:(NSString *) movedOut
              andWithMovingOrigin:(NSString *) movingOrgin
                andWithMovingTime:(NSString *) movingTIme
                  andWithItemFull:(NSString *) itemFull
                  andWithItemOpen:(NSString *) itemOpen
               andWithItemPreFull:(NSString *) itemPreFull
               andWithItemPreOpen:(NSString *) itempreOpen
              andWithMissingToPar:(NSString *) missingToPar
               andWithServingSold:(NSString *) servingSold
              andWithLiquidWeight:(NSString *) liquidWeight
                 andWithItemPrice:(NSString *) itemPrice
                andWithCashDetail:(NSString *) cashDetail {
    
    
    
    self = [super init];
    
    if(self) {
    
        self.itemName = itemName;
        self.movedIn = movedIn;
        self.movedOut = movedOut;
        self.movingOrigin = movingOrgin;
        self.movingTime = movingTIme;
        self.itemFull = itemFull;
        self.itemOpen = itemOpen;
        self.itemPreFull = itemPreFull;
        self.itemPreOpen = itempreOpen;
        self.missingToPar = missingToPar;
        self.servingSold = servingSold;
        self.itemPrice = itemPrice;
        self.liquidWeight = liquidWeight;
        self.cashDetail = cashDetail;
    }
    
    return self;
}

@end
