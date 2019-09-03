//
//  RefillItem.h
//  OJOv1
//
//  Created by MilosHavel on 20/08/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefillItem : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *par;
@property (strong, nonatomic) NSString *currentAmount;
@property (strong, nonatomic) NSString *refilledAmount;
@property (strong, nonatomic) NSString *priceTotal;
@property (strong, nonatomic) NSString *pricePerUnit;
@property (strong, nonatomic) NSString *priceRate;
@property (strong, nonatomic) NSString *distributor;

- (instancetype) initWithItemName:(NSString *) itemName
                           andPar:(NSString *) par
                 andCurrentAmount:(NSString *) currentAmount
                andRefilledAmount:(NSString *) refilledAmount
                    andPriceTotal:(NSString *) priceTotal
                  andPricePerUnit:(NSString *) pricePerUnit
                     andPriceRate:(NSString *) priceRate
                   andDistributor:(NSString *) distributor;


@end
