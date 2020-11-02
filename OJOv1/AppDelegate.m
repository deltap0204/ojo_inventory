//
//  AppDelegate.m
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [Fabric with:@[[Crashlytics class]]];
    

    
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (IS_IPAD) {
        [userDefaults setObject:@"iPad" forKey:DEVICETYPE];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [userDefaults setObject:@"iPad" forKey:DEVICETYPE];
    } else{
    
        [userDefaults setObject:@"iPhone" forKey:DEVICETYPE];
    }
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%@", @"this is test area");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%@", @"this is test area");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@", @"this is test area");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@", @"this is test area");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%@", @"this is test area");
}


@end
