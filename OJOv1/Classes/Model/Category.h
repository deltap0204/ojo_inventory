//
//  Category.h
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (strong, nonatomic) NSString *categoryName;
@property (assign, nonatomic) NSInteger fullAndOpen;
@property (assign, nonatomic) NSInteger frequency;

- (instancetype) initWithCategoryName:(NSString *) categoryName
                   andWithFullAndOpen:(NSInteger) fullAndOpen
                     andWithFrequency:(NSInteger) frequency;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
