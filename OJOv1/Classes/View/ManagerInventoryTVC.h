//
//  ManagerInventoryTVC.h
//  OJOv1
//
//  Created by MilosHavel on 23/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerInventoryTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *par;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *firstStar;
@property (weak, nonatomic) IBOutlet UILabel *secondStar;
@property (weak, nonatomic) IBOutlet UILabel *thirdStar;
@property (weak, nonatomic) IBOutlet UILabel *forthStar;
@property (weak, nonatomic) IBOutlet UILabel *fifthStar;
@property (assign, nonatomic) BOOL isPAD;


- (void) starZero:(CGFloat)fontSize;
- (void) starOne:(CGFloat)fontSize;
- (void) starTwo:(CGFloat)fontSize;
- (void) starThree:(CGFloat)fontSize;
- (void) starFour:(CGFloat)fontSize;
- (void) starFive:(CGFloat)fontSize;

@end
