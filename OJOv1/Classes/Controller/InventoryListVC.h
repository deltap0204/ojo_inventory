//
//  InventoryListVC.h
//  OJOv1
//
//  Created by MilosHavel on 15/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryListVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *locationController;

@end
