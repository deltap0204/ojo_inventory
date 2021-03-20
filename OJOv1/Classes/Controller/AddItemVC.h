//
//  AddItemVC.h
//  OJOv1
//
//  Created by MilosHavel on 14/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemFull.h"

@interface AddItemVC : UIViewController


@property (strong, nonatomic) ItemFull *selectedItem;
@property (strong, nonatomic) NSString *fromVC;

@end
