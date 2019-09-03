//
//  Item.h
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (assign, nonatomic) NSInteger fullAndOpen;
@property (strong, nonatomic) NSString *categoryName;
@property (assign, nonatomic) NSInteger frequency;
@property (strong, nonatomic) NSString *price;

- (instancetype) initWithItemName:(NSString *) itemName
               andWithFullAndOpen:(NSInteger) fullAndOpen
              andWithCategoryName:(NSString *) categoryName
                     andFrequency:(NSInteger) frequency
                         andPrice:(NSString *)price;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

@end
