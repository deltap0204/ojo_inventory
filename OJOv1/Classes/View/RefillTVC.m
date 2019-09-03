//
//  RefillTVC.m
//  OJOv1
//
//  Created by MilosHavel on 25/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "RefillTVC.h"

@implementation RefillTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addButton.layer.borderWidth = 1.0f;
    self.addButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.addButton.layer.cornerRadius = 3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) buttonInitialize{
    self.addButton.layer.borderWidth = 1.0f;
    self.addButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.addButton.layer.cornerRadius = self.addButton.bounds.size.height / 5;

}


- (IBAction)onAdd:(id)sender {
    
}


@end
