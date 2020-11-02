//
//  DeviceTVC.m
//  OJOv1
//
//  Created by Eagle on 29/10/20.
//  Copyright © 2020 MilosHavel. All rights reserved.
//

#import "DeviceTVC.h"

@implementation DeviceTVC




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDeviceInfo: (BLEDeviceModel *) peripheral {
    [self.deviceNameLabel setText:peripheral.deviceName];
    [self.deviceIDLabel setText:[NSString stringWithFormat:@"Device ID: %@", peripheral.deviceID]];
    if (peripheral.isConnected) {
        [self.statusLabel setText:@"Connected"];
        [self.statusLabel setTextColor:[UIColor whiteColor]
         ];
    } else {
        [self.statusLabel setText:@"Not Connected"];
        [self.statusLabel setTextColor:[UIColor lightGrayColor]
         ];
    }
}

@end
