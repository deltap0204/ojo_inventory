//
//  ConfirmTVC.h
//  OJOv1
//
//  Created by MilosHavel on 01/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *fromLocationMark;
@property (weak, nonatomic) IBOutlet UILabel *senderMark;
@property (weak, nonatomic) IBOutlet UILabel *movedTimeMark;
@property (weak, nonatomic) IBOutlet UILabel *movedTime;
@property (weak, nonatomic) IBOutlet UILabel *fromLocation;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UILabel *movingAmount;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (assign, nonatomic) CGFloat fontSize;
@property (strong, nonatomic) NSString *currentStatus;


- (void) acceptState;
- (void) acceptedState;
- (void) rejectState;
- (void) rejectedState;

@end
