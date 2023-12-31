//
//  ShiftReportModel.h
//  OJOv1
//
//  Created by Chris Palo on 16/02/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShiftReportModel : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *movedIn;
@property (strong, nonatomic) NSString *movedOut;
@property (strong, nonatomic) NSString *movingOrigin;
@property (strong, nonatomic) NSString *movingTime;
@property (strong, nonatomic) NSString *itemFull;
@property (strong, nonatomic) NSString *itemOpen;

@property (strong, nonatomic) NSString *itemPreFull;
@property (strong, nonatomic) NSString *itemPreOpen;

@property (strong, nonatomic) NSString *missingToPar;
@property (strong, nonatomic) NSString *servingSold;
@property (strong, nonatomic) NSString *cashDetail;
@property (strong, nonatomic) NSString *itemPrice;
@property (strong, nonatomic) NSString *liquidWeight;


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
                andWithCashDetail:(NSString *) cashDetail;

@end
