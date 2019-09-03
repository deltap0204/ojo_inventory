//
//  InventoryTVC.h
//  OJOv1
//
//  Created by MilosHavel on 16/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstStar;
@property (weak, nonatomic) IBOutlet UILabel *secondStar;
@property (weak, nonatomic) IBOutlet UILabel *thirdStar;
@property (weak, nonatomic) IBOutlet UILabel *forthStar;
@property (weak, nonatomic) IBOutlet UILabel *fifthStar;

- (void) starZero;
- (void) starOne;
- (void) starTwo;
- (void) starThree;
- (void) starFour;
- (void) starFive;

@end
