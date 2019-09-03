//
//  CategoryTVC.m
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "CategoryTVC.h"

@implementation CategoryTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void) starZero{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.firstStar setText:@"\uf006"];
    
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.secondStar setText:@"\uf006"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.thirdStar setText:@"\uf006"];
    [self.fourthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fourthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fifthStar setText:@"\uf006"];

}


- (void) starOne{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.firstStar setText:@"\uf005"];
    
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.secondStar setText:@"\uf006"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.thirdStar setText:@"\uf006"];
    [self.fourthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fourthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fifthStar setText:@"\uf006"];
    
}
- (void) starTwo{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.thirdStar setText:@"\uf006"];
    [self.fourthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fourthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fifthStar setText:@"\uf006"];
}
- (void) starThree{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.thirdStar setText:@"\uf005"];
    [self.fourthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fourthStar setText:@"\uf006"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fifthStar setText:@"\uf006"];
}
- (void) starFour{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.thirdStar setText:@"\uf005"];
    [self.fourthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fourthStar setText:@"\uf005"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fifthStar setText:@"\uf006"];
}
- (void) starFive{
    [self.firstStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.firstStar setText:@"\uf005"];
    [self.secondStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.secondStar setText:@"\uf005"];
    [self.thirdStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.thirdStar setText:@"\uf005"];
    [self.fourthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fourthStar setText:@"\uf005"];
    [self.fifthStar setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
    [self.fifthStar setText:@"\uf005"];
}

@end
