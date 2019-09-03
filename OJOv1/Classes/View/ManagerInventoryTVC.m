//
//  ManagerInventoryTVC.m
//  OJOv1
//
//  Created by MilosHavel on 23/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ManagerInventoryTVC.h"



@implementation ManagerInventoryTVC



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) starZero:(CGFloat)fontSize{
    
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.firstStar setText:@"\uf006"];
    
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.secondStar setText:@"\uf006"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.thirdStar setText:@"\uf006"];
    [self.forthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.forthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.fifthStar setText:@"\uf006"];
    
}

- (void) starOne:(CGFloat)fontSize{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.firstStar setText:@"\uf005"];
    
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.secondStar setText:@"\uf006"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.thirdStar setText:@"\uf006"];
    [self.forthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.forthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.fifthStar setText:@"\uf006"];
    
}
- (void) starTwo:(CGFloat)fontSize{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.thirdStar setText:@"\uf006"];
    [self.forthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.forthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.fifthStar setText:@"\uf006"];
}
- (void) starThree:(CGFloat)fontSize{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.thirdStar setText:@"\uf005"];
    [self.forthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.forthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.fifthStar setText:@"\uf006"];
}
- (void) starFour:(CGFloat)fontSize{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.thirdStar setText:@"\uf005"];
    [self.forthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.forthStar setText:@"\uf005"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.fifthStar setText:@"\uf006"];
}
- (void) starFive:(CGFloat)fontSize{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.thirdStar setText:@"\uf005"];
    [self.forthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.forthStar setText:@"\uf005"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.fifthStar setText:@"\uf005"];
}
@end
