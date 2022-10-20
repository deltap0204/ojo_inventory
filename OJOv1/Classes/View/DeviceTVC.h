//
//  DeviceTVC.h
//  OJOv1
//
//  Created by Eagle on 29/10/20.
//  Copyright © 2020 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEDeviceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)setDeviceInfo: (BLEDeviceModel *) peripheral;

@end

NS_ASSUME_NONNULL_END
