//
//  BartInventory.h
//  OJOv1
//
//  Created by MilosHavel on 06/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEClient.h"

@interface BartInventory : UIViewController<UITextViewDelegate, UITextFieldDelegate, BLEDelegate, CBPeripheralDelegate>

@end
