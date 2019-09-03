//
//  WebClient.h
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface WebClient : NSObject


+ (void)requestPostUrl:(NSString *)strURL
            parameters:(NSDictionary *)dicParams
               suceess:(void(^)(NSArray * response))success
               failure:(void(^)(NSError *error))failure;

@end
