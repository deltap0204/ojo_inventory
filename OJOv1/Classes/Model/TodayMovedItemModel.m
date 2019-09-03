//
//  TodayMovedItemModel.m
//  OJOv1
//
//  Created by MilosHavel on 10/05/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "TodayMovedItemModel.h"

@implementation TodayMovedItemModel

- (instancetype) initWithMovedItemName:(NSString *)movedItemName
                andWithMovedItemAmount:(NSString *)movedItemAmount
                   andWithMovedTimeAgo:(NSString *)movedTimeAgo
                  andWithMovedUsername:(NSString *)movedUsername
                  andWithOrginLocation:(NSString *)movedOrginLocation
                 andWithTargetLocation:(NSString *)movedTargetLocation
                    andWithMovedStatus:(NSString *)movedStatus{

    self = [super init];
    if (self) {
        self.movedItemName = movedItemName;
        self.movedItemAmount = movedItemAmount;
        self.movedTimeAgo = movedTimeAgo;
        self.movedUsername = movedUsername;
        self.movedOrginLocation = movedOrginLocation;
        self.movedTargetLocation = movedTargetLocation;
        self.movedStatus = movedStatus;
    }
    return self;
}

@end
