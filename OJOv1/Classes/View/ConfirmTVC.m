//
//  ConfirmTVC.m
//  OJOv1
//
//  Created by MilosHavel on 01/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ConfirmTVC.h"

@implementation ConfirmTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) acceptState{
    self.acceptButton.layer.borderWidth = 1.0;
    self.acceptButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.acceptButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.acceptButton setTitle:[NSString stringWithFormat:@"%@%@", @"\uf164", @"     ACCEPT"] forState:UIControlStateNormal];
    [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fromLocationMark setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.fromLocationMark setText:@"\uf041"];
    [self.fromLocationMark setTextColor:[UIColor whiteColor]];
    
    [self.senderMark setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.senderMark setText:@"\uf1d8"];
    [self.senderMark setTextColor:[UIColor whiteColor]];
    
    [self.movedTimeMark setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.movedTimeMark setText:@"\uf017"];
    [self.movedTimeMark setTextColor:[UIColor whiteColor]];

}

- (void) acceptedState{
    self.acceptButton.layer.borderWidth = 1.0;
    self.acceptButton.layer.borderColor = [[UIColor greenColor] CGColor];
    
    [self.acceptButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.acceptButton setTitle:[NSString stringWithFormat:@"%@%@", @"\uf164", @"     ACCEPTED"] forState:UIControlStateNormal];
    [self.acceptButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
}

- (void) rejectState{
    self.rejectButton.layer.borderWidth = 1.0;
    self.rejectButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.rejectButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.rejectButton setTitle:[NSString stringWithFormat:@"%@%@", @"\uf165", @"     REJECT"] forState:UIControlStateNormal];
    [self.rejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void) rejectedState{
    self.rejectButton.layer.borderWidth = 1.0;
    self.rejectButton.layer.borderColor = [[UIColor greenColor] CGColor];
    
    [self.rejectButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:self.fontSize]];
    [self.rejectButton setTitle:[NSString stringWithFormat:@"%@%@", @"\uf165", @"     REJECTED"] forState:UIControlStateNormal];
    [self.rejectButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

}

@end
