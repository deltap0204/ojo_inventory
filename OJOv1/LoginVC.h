//
//  ViewController.h
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "User.h"

@interface LoginVC : UIViewController<UITextFieldDelegate>

+ (User *)getLoggedinUser;

@end
