//
//  User.h
//  OJOv1
//
//  Created by MilosHavel on 06/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSString *contoller;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *preName;

- (instancetype) initWithName:(NSString *) name
              andWithUsername:(NSString *) username
              andWithPassword:(NSString *) password
                 andWithEmail:(NSString *) email
                  andWithRole:(NSString *) role
                andContorller:(NSString *) controller
          andWtihWithLocation:(NSString *) location
               andWithPreName:(NSString *) preName;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
