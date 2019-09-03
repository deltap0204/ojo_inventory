//
//  User.m
//  OJOv1
//
//  Created by MilosHavel on 06/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithName:(NSString *)name
             andWithUsername:(NSString *)username
             andWithPassword:(NSString *)password
                andWithEmail:(NSString *)email
                 andWithRole:(NSString *)role
               andContorller:(NSString *) controller
         andWtihWithLocation:(NSString *)location
               andWithPreName:(NSString *)preName{
    
    self = [super init];
    
    if (self){
        
        self.name = name;
        self.username = username;
        self.password = password;
        self.email = email;
        self.role = role;
        self.contoller = controller;
        self.location = location;
        self.preName = preName;
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.name = dictionary[NAME];
        self.username = dictionary[USERNAME];
        self.password = dictionary[PASSWORD];
        self.email = dictionary[EMAIL];
        self.role = dictionary[ROLE];
        self.contoller = dictionary[CONTROLLER];
        self.location = dictionary[LOCATION];
        
    }
    return self;
    
}

@end
