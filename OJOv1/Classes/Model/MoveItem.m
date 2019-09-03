//
//  MoveItem.m
//  OJOv1
//
//  Created by MilosHavel on 29/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "MoveItem.h"

@implementation MoveItem

- (instancetype) initWithMoveItemName:(NSString *)moveItemName
                    andWithMoveAmount:(NSString *)moveAmount
                andWithSenderLocation:(NSString *)sendLocation
               andWithReceiveLocation:(NSString *)receiveLocation
                        andSenderName:(NSString *)senderName{
    self = [super init];
    
    if (self) {
        self.moveItemName = moveItemName;
        self.moveAmount = moveAmount;
        self.sendLocation = sendLocation;
        self.receiveLocation = receiveLocation;
        self.senderName = senderName;
    }
    return self;

}

@end
