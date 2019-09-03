//
//  AddedItemTVC.h
//  OJOv1
//
//  Created by MilosHavel on 27/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddedItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *currentAmount;
@property (weak, nonatomic) IBOutlet UILabel *addedAmount;
@property (weak, nonatomic) IBOutlet UILabel *distributorLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateOfSaleLabel;


@property (weak, nonatomic) IBOutlet UILabel *currentAmountMark;
@property (weak, nonatomic) IBOutlet UILabel *refilledAmountMark;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceMark;
@property (weak, nonatomic) IBOutlet UILabel *pricePerUnitMark;
@property (weak, nonatomic) IBOutlet UILabel *rateOfSaleMark;

@property (assign, nonatomic) BOOL iPadTrue;

@end
