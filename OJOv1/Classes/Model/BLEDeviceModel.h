//
//  BLEDeviceModel.h
//  OJOv1
//
//  Created by Eagle on 1/11/20.
//  Copyright © 2020 MilosHavel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEDeviceModel : NSObject

@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) NSString *deviceName;
@property (assign, nonatomic) BOOL isConnected;

- (instancetype) initWithDeviceIdentifier:(NSString *)deviceID
                                  andName:(NSString *)deviceName
                             andConnected:(BOOL) connected;

@end

NS_ASSUME_NONNULL_END


