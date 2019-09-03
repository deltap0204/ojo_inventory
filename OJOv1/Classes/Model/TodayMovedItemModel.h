//
//  TodayMovedItemModel.h
//  OJOv1
//
//  Created by MilosHavel on 10/05/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayMovedItemModel : NSObject

@property (strong, nonatomic) NSString *movedItemName;
@property (strong, nonatomic) NSString *movedItemAmount;
@property (strong, nonatomic) NSString *movedTimeAgo;
@property (strong, nonatomic) NSString *movedUsername;
@property (strong, nonatomic) NSString *movedOrginLocation;
@property (strong, nonatomic) NSString *movedTargetLocation;
@property (strong, nonatomic) NSString *movedStatus;

- (instancetype) initWithMovedItemName:(NSString *) movedItemName
                andWithMovedItemAmount:(NSString *) movedItemAmount
                   andWithMovedTimeAgo:(NSString *) movedTimeAgo
                  andWithMovedUsername:(NSString *) movedUsername
                  andWithOrginLocation:(NSString *) movedOrginLocation
                 andWithTargetLocation:(NSString *) movedTargetLocation
                    andWithMovedStatus:(NSString *) movedStatus;


@end
