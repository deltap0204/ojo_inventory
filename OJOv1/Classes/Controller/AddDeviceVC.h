//
//  AddDeviceVC.h
//  OJOv1
//
//  Created by MilosHavel on 25.11.2019.
//  Copyright © 2019 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulsingHaloLayer.h"
#import "BLEClient.h"
#import "DeviceTVC.h"
#import "BLEDeviceModel.h"


@interface AddDeviceVC : UIViewController<BLEDelegate, UITableViewDelegate, UITableViewDataSource>

@end

