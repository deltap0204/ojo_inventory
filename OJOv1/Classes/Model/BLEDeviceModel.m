//
//  BLEDeviceModel.m
//  OJOv1
//
//  Created by Eagle on 1/11/20.
//  Copyright © 2020 MilosHavel. All rights reserved.
//

#import "BLEDeviceModel.h"

@implementation BLEDeviceModel

-(instancetype) initWithDeviceIdentifier:(NSString *)deviceID andName:(NSString *)deviceName andConnected:(BOOL)connected {
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
        self.deviceName = deviceName;
        self.isConnected = connected;
    }
    return  self;
}
@end
