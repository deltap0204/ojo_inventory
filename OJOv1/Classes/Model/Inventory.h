//
//  Inventory.h
//  OJOv1
//
//  Created by MilosHavel on 16/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Inventory : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (assign, nonatomic) NSInteger frequency;
@property (strong, nonatomic) NSString *openBottleWet;
@property (strong, nonatomic) NSString *par;
@property (strong, nonatomic) NSString *amount;
@property (assign, nonatomic) NSInteger fullOpen;
@property (strong, nonatomic) NSString *itemPrice;
@property (strong, nonatomic) NSString *category;

- (instancetype) initWithItemName:(NSString *) itemName
                 andWithFrequency:(NSInteger) frequency
                  andWithFullOpen:(NSInteger) fullOpen
             andWithOpenBottleWet:(NSString *) openBottleWet
                       andWithPar:(NSString *) par
                 andWithItemPrice:(NSString *) itemPrice
                        andAmount:(NSString *) amount
                      andCategory:(NSString *) category;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;


@end
