//
//  UserTVC.h
//  OJOv1
//
//  Created by MilosHavel on 07/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *locationMark;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameMark;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordMark;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailMark;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roleImageView;
@property (weak, nonatomic) IBOutlet UIView *cellCoverView;


@end
