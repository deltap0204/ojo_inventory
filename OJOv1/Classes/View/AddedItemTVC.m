//
//  AddedItemTVC.m
//  OJOv1
//
//  Created by MilosHavel on 27/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AddedItemTVC.h"

@implementation AddedItemTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.currentAmountMark setFont:[UIFont fontWithName:@"fontawesome" size:15.0]];
    [self.currentAmountMark setText:@"\uf07a"];
    
    [self.refilledAmountMark setFont:[UIFont fontWithName:@"fontawesome" size:15.0]];
    [self.refilledAmountMark setText:@"\uf217"];
    
    [self.totalPriceMark setFont:[UIFont fontWithName:@"fontawesome" size:13.0]];
    [self.totalPriceMark setText:@"\uf0d6"];
    
    [self.pricePerUnitMark setFont:[UIFont fontWithName:@"fontawesome" size:13.0]];
    [self.pricePerUnitMark setText:@"\uf0d6"];
    
    [self.rateOfSaleMark setFont:[UIFont fontWithName:@"fontawesome" size:13.0]];
    [self.rateOfSaleMark setText:@"\uf295"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
