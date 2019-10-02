//
//  Confirm.m
//  OJOv1
//
//  Created by MilosHavel on 01/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "Confirm.h"

@implementation Confirm

- (instancetype) initWithMoveID:(NSString *)moveID
            andWithMoveItemName:(NSString *)moveItemName
              andWithMoveAmount:(NSString *)moveAmount
          andWithSenderLocation:(NSString *)senderLocation
         andWithReceiveLocation:(NSString *)receiverLocation
              andWithSenderName:(NSString *)senderName
              andWithAcceptTime:(NSString *)acceptTime{

    self = [super init];
    if (self) {
        self.moveID = moveID;
        self.moveItemName = moveItemName;
        self.moveAmount = moveAmount;
        self.senderLocation = senderLocation;
        self.senderName = senderName;
        self.receiverLocation = receiverLocation;
        self.acceptTime = acceptTime;
        
    }
    return self;

}

@end
