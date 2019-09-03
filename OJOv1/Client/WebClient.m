//
//  WebClient.m
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebClient.h"

@implementation WebClient

+ (void) requestPostUrl:(NSString *)strURL
             parameters:(NSDictionary *)dicParams
                suceess:(void (^)(NSArray *))success
                failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    
    [httpManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [httpManager POST:strURL
           parameters:dicParams
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject){
                NSString* response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  NSLog(@"\n---Server reponse---\n %@", response);
                  if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                      if (success) {
                          success(responseObject);
                      }
                  } else {
                      NSArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                      success(response);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if (failure) {
                      failure(error);
                  }
              }];
}


@end
