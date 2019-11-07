//
//  RefillTVC.h
//  OJOv1
//
//  Created by MilosHavel on 25/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefillTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *par;
@property (weak, nonatomic) IBOutlet UILabel *missingPar;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (void) buttonInitialize;

@end
