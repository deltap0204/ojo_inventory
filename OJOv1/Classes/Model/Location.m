//
//  Location.m
//  OJOv1
//
//  Created by MilosHavel on 08/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype) initWithLocationName:(NSString *)locationName{
    self = [super init];
    if (self) {
        self.locationName = locationName;
    }
    return self;
}



@end
