//
//  MoveItem.h
//  OJOv1
//
//  Created by MilosHavel on 29/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveItem : NSObject

@property (strong, nonatomic) NSString *moveItemName;
@property (strong, nonatomic) NSString *moveAmount;
@property (strong, nonatomic) NSString *sendLocation;
@property (strong, nonatomic) NSString *receiveLocation;
@property (strong, nonatomic) NSString *senderName;

- (instancetype) initWithMoveItemName:(NSString *) moveItemName
                    andWithMoveAmount:(NSString *) moveAmount
                andWithSenderLocation:(NSString *) sendLocation
               andWithReceiveLocation:(NSString *) receiveLocation
                        andSenderName:(NSString *) senderName;

@end
