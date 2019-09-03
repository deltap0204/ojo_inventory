//
//  AloneItem.m
//  OJOv1
//
//  Created by MilosHavel on 15/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AloneItem.h"

@implementation AloneItem

-(instancetype) initWithItemName:(NSString *)itemName{
    self = [super init];
    if (self) {
        self.itemName = itemName;
    }
    return self;

}

@end
