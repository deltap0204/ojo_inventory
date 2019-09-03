//
//  BartenderCommentTVC.h
//  OJOv1
//
//  Created by MilosHavel on 10/23/17.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BartenderCommentTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *weightOpenBottle;
@property (weak, nonatomic) IBOutlet UILabel *countFullBottle;

@end
