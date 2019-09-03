//
//  MovedItemTVC.h
//  OJOv1
//
//  Created by MilosHavel on 29/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovedItemTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movedItemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *movedAmountLabel;

@end
