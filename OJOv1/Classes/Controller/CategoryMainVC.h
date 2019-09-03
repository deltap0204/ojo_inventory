//
//  CategoryMainVC.h
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSMutableArray *categories;


@interface CategoryMainVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *categoryArray;


- (void) loadAllData;

@end
