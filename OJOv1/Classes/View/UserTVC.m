//
//  UserTVC.m
//  OJOv1
//
//  Created by MilosHavel on 07/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "UserTVC.h"

@implementation UserTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellCoverView.layer.cornerRadius = 5.0;
    
    [self.usernameMark setFont:[UIFont fontWithName:@"fontawesome" size:25.0]];
    [self.usernameMark setText:@"\uf007"];
    
    [self.passwordMark setFont:[UIFont fontWithName:@"fontawesome" size:25.0]];
    [self.passwordMark setText:@"\uf023"];
    
    [self.locationMark setFont:[UIFont fontWithName:@"fontawesome" size:25.0]];
    [self.locationMark setText:@"\uf124"];
    
    [self.emailMark setFont:[UIFont fontWithName:@"fontawesome" size:25.0]];
    [self.emailMark setText:@"\uf0e0"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
