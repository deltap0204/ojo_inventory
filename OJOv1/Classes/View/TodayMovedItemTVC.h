//
//  TodayMovedItemTVC.h
//  OJOv1
//
//  Created by MilosHavel on 10/05/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayMovedItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *movedItemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movedAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *movedTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movedStatus;
@property (weak, nonatomic) IBOutlet UILabel *orginLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLocationLabel;

@end
