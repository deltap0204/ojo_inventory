//
//  BartenderCommentModel.m
//  OJOv1
//
//  Created by MilosHavel on 10/23/17.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "BartenderCommentModel.h"

@implementation BartenderCommentModel

- (instancetype) initWithItemName:(NSString *)itemName
              andWeightOpenBottle:(NSString *)weightOpenBottle
              andCountFullBottles:(NSString *)countFullBottles{
    
    self = [super init];
    
    if (self) {
        self.itemName = itemName;
        self.weightOpenBottle = weightOpenBottle;
        self.countFullBottles = countFullBottles;
    }
    
    return self;
}

@end
