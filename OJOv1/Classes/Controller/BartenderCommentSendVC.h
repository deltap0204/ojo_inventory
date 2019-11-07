//
//  BartenderCommentSendVC.h
//  OJOv1
//
//  Created by MilosHavel on 6/12/18.
//  Copyright © 2018 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BartenderCommentSendVC : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inventoryTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end
