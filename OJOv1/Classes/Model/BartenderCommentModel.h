//
//  BartenderCommentModel.h
//  OJOv1
//
//  Created by MilosHavel on 10/23/17.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BartenderCommentModel : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *weightOpenBottle;
@property (strong, nonatomic) NSString *countFullBottles;

- (instancetype) initWithItemName:(NSString *) itemName
              andWeightOpenBottle:(NSString *) weightOpenBottle
              andCountFullBottles:(NSString *) countFullBottles;

@end
