//
//  StartReportModel.h
//  OJOv1
//
//  Created by Chris Palo on 16/02/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartReportModel : NSObject

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *movingAmount;
@property (strong, nonatomic) NSString *movingOrigin;
@property (strong, nonatomic) NSString *movingTime;
@property (strong, nonatomic) NSString *itemFull;
@property (strong, nonatomic) NSString *itemOpen;
@property (strong, nonatomic) NSString *missingToPar;
@property (strong, nonatomic) NSString *itemFullCheck;
@property (strong, nonatomic) NSString *itemOpenCheck;

- (instancetype) initWithItemName:(NSString *) itemName
              andWithMovingAmount:(NSString *) movingAmount
              andWithMovingOrigin:(NSString *) movingOrigin
                andWithMovingTime:(NSString *) movingTime
                  andWithItemFull:(NSString *) itemFull
                  andWithItemOpen:(NSString *) itemOpen
              andWithMissingToPar:(NSString *) missingToPar
             andWithItemFullCheck:(NSString *) itemFullCheck
             andWithItemOpenCheck:(NSString *) itemOpenCheck;


@end
