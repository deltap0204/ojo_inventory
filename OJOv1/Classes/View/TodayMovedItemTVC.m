//
//  TodayMovedItemTVC.m
//  OJOv1
//
//  Created by MilosHavel on 10/05/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "TodayMovedItemTVC.h"

@implementation TodayMovedItemTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellView.layer.cornerRadius = 15.0f;
    self.cellView.layer.shadowOffset = CGSizeMake(0.5, 4.0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
