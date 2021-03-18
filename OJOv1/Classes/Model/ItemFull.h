//
//  ItemFull.h
//  OJOv1
//
//  Created by MilosHavel on 16.03.2021.
//  Copyright © 2021 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemFull : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (assign, nonatomic) NSInteger fullAndOpen;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *btFullWet;
@property (strong, nonatomic) NSString *btEmpWet;
@property (strong, nonatomic) NSString *liqWet;
@property (strong, nonatomic) NSString *servBt;
@property (strong, nonatomic) NSString *price;
@property (assign, nonatomic) NSInteger frequency;
@property (strong, nonatomic) NSMutableArray *activedLocationArray;



- (instancetype) initWithItemName:(NSString*)itemName
               andWithFullAndOpen:(NSInteger)fullAndOpen
              andWithCategoryName:(NSString*)categoryName
                 andWithBtFullWet:(NSString*)btFullWet
                  andWithBtEmpWet:(NSString*)btEmpWet
                    andWithLiqWet:(NSString*)liqWet
                    andWithServBt:(NSString*)servBt
                     andWithprice:(NSString*)price
                 andWithFrequence:(NSInteger)frequency
      andWithActivedLocationArray:(NSMutableArray*)activedLocationArray;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

@end
