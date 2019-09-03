//
//  StartReportModel.m
//  OJOv1
//
//  Created by Chris Palo on 16/02/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "StartReportModel.h"

@implementation StartReportModel

- (instancetype) initWithItemName:(NSString *) itemName
              andWithMovingAmount:(NSString *) movingAmount
              andWithMovingOrigin:(NSString *) movingOrigin
                andWithMovingTime:(NSString *) movingTime
                  andWithItemFull:(NSString *) itemFull
                  andWithItemOpen:(NSString *) itemOpen
              andWithMissingToPar:(NSString *) missingToPar
             andWithItemFullCheck:(NSString *) itemFullCheck
             andWithItemOpenCheck:(NSString *) itemOpenCheck{

    self = [super init];
    if (self) {
        
        self.itemName = itemName;
        self.movingAmount = movingAmount;
        self.movingOrigin = movingOrigin;
        self.movingTime = movingTime;
        self.itemFull = itemFull;
        self.itemOpen = itemOpen;
        self.itemFullCheck = itemFullCheck;
        self.itemOpenCheck = itemOpenCheck;
        self.missingToPar = missingToPar;
    }
    return self;
}

@end
