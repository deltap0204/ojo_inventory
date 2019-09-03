//
//  ManagerInventoryCommentVC.h
//  OJOv1
//
//  Created by MilosHavel on 24/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ManagerInventoryCommentVC : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *reportArray;

@end
