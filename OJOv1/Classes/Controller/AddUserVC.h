//
//  AddUserVC.h
//  OJOv1
//
//  Created by MilosHavel on 07/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AddUserVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) User *selectedUser;
@property (strong, nonatomic) NSString *fromVC;

@end
