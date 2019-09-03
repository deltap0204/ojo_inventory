//
//  BartenderCommentTVC.m
//  OJOv1
//
//  Created by MilosHavel on 10/23/17.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "BartenderCommentTVC.h"

@implementation BartenderCommentTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellView.layer.cornerRadius = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
