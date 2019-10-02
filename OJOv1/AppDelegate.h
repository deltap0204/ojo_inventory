//
//  AppDelegate.h
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *allItemArray;
@property (strong, nonatomic) NSMutableArray *movedTempArray;

@property (strong, nonatomic) NSMutableArray *refilledArray;
@property (strong, nonatomic) NSMutableArray *bartInventoryArray;
@property (strong, nonatomic) NSMutableArray *allowedArray;
@property (strong, nonatomic) NSString *inventoryType;
@property (strong, nonatomic) NSString *currentDominicaTime;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *totalCash;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *preUserName;
@property (strong, nonatomic) NSMutableArray *startReport;
@property (strong, nonatomic) NSMutableArray *shiftReport;

// This array is used for only bartender page
@property (strong, nonatomic) NSMutableArray *unreadReceivedItemArray;
@property (strong, nonatomic) NSMutableArray *unreadSentItemArray;
@property (strong, nonatomic) NSMutableArray *unreportedArray;

@end

