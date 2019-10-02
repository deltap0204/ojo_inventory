//
//  Confirm.h
//  OJOv1
//
//  Created by MilosHavel on 01/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Confirm : NSObject

@property (strong, nonatomic) NSString *moveID;
@property (strong, nonatomic) NSString *moveItemName;
@property (strong, nonatomic) NSString *moveAmount;
@property (strong, nonatomic) NSString *senderLocation;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *receiverLocation;
@property (strong, nonatomic) NSString *acceptTime;


- (instancetype) initWithMoveID:(NSString *)moveID
            andWithMoveItemName:(NSString *)moveItemName
              andWithMoveAmount:(NSString *)moveAmount
          andWithSenderLocation:(NSString *)senderLocation
         andWithReceiveLocation:(NSString *)receiverLocation
              andWithSenderName:(NSString *)senderName
              andWithAcceptTime:(NSString *)acceptTime;

@end
