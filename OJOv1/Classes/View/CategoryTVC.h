//
//  CategoryTVC.h
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *fullAndOpen;
@property (weak, nonatomic) IBOutlet UILabel *firstStar;
@property (weak, nonatomic) IBOutlet UILabel *secondStar;
@property (weak, nonatomic) IBOutlet UILabel *thirdStar;
@property (weak, nonatomic) IBOutlet UILabel *fourthStar;
@property (weak, nonatomic) IBOutlet UILabel *fifthStar;

- (void) starZero;
- (void) starOne;
- (void) starTwo;
- (void) starThree;
- (void) starFour;
- (void) starFive;

@end
