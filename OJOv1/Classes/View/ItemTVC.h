//
//  ItemTVC.h
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemFullOpen;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *priceStr;

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
