//
//  Location.h
//  OJOv1
//
//  Created by MilosHavel on 08/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (strong, nonatomic) NSString *locationName;

- (instancetype) initWithLocationName:(NSString *) locationName;

@end
