//
//  Category.m
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "Category.h"

@implementation Category

- (instancetype) initWithCategoryName:(NSString *)categoryName
                   andWithFullAndOpen:(NSInteger)fullAndOpen
                     andWithFrequency:(NSInteger)frequency{

    self = [super init];
    
    if (self) {
        self.categoryName = categoryName;
        self.fullAndOpen = fullAndOpen;
        self.frequency = frequency;
    }
    
    return  self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.categoryName = dictionary[CATEGORY_NAME];
        self.fullAndOpen = [dictionary[FULL_OPEN] intValue];
        self.frequency = [dictionary[FREQUENCY] intValue];
    }
    return self;
}

@end
