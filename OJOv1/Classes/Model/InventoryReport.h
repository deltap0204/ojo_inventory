//
//  InventoryReport.h
//  OJOv1
//
//  Created by MilosHavel on 09/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryReport : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (assign, nonatomic) NSInteger frequency;
@property (assign, nonatomic) NSInteger fullOpen;
@property (strong, nonatomic) NSString *openBottleWet;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *par;
@property (strong, nonatomic) NSString *newsOpenBottleWet;
@property (strong, nonatomic) NSString *newsAmount;
@property (strong, nonatomic) NSString *itemBottleFullWet;
@property (strong, nonatomic) NSString *itemBottleEmpWet;
@property (strong, nonatomic) NSString *itemLiqWet;
@property (strong, nonatomic) NSString *itemServBt;
@property (strong, nonatomic) NSString *itemServWet;
@property (strong, nonatomic) NSString *itemPrice;
@property (strong, nonatomic) NSString *cashDetail;

- (instancetype) initWithItemName:(NSString *) itemName
                 andWithFrequency:(NSInteger) frequency
                  andWithFullOpen:(NSInteger) fullOpen
             andWithOpenBottleWet:(NSString *) openBottleWet
                    andWithAmount:(NSString *) amount
                       andWithPar:(NSString *) par
         andWithNewsOpenBottleWet:(NSString *) newsOpenBottleWet
                andWithNewsAmount:(NSString *) newsAmount
         andWithItemBottleFullWet:(NSString *) itemBottleFullWet
          andWithItemBottleEmpWet:(NSString *) itemBottleEmpWet
                andWithItemLiqWet:(NSString *) itemLiqWet
                andWithItemServBt:(NSString *) itemServBt
               andWithItemServWet:(NSString *) itemServWet
                 andWithItemPrice:(NSString *) itemPrice
                andWithCashDetail:(NSString *) cashDetail;


@end
