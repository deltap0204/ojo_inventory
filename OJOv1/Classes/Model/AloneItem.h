//
//  AloneItem.h
//  OJOv1
//
//  Created by MilosHavel on 15/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AloneItem : NSObject

@property (strong, nonatomic) NSString *itemName;

- (instancetype) initWithItemName:(NSString *)itemName;

@end
