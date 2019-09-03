//
//  ManagerInventoryVC.m
//  OJOv1
//
//  Created by MilosHavel on 23/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ManagerInventoryVC.h"
#import "ManagerInventoryTVC.h"
#import "Inventory.h"

@interface ManagerInventoryVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (strong, nonatomic) NSString *controller;
@property (strong, nonatomic) NSString *locaction;
@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *inventorySearchList;
@property (assign, nonatomic) BOOL isFiltered;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString *deviceType;

@end

@implementation ManagerInventoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inventoryList = [[NSMutableArray alloc] init];
    self.inventorySearchList = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.controller = [userDefaults objectForKey:CONTROLLER];
    self.locaction = [userDefaults objectForKey:SEL_LOCATION];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", @"INVENTORY LIST OF ", self.locaction];

    CGFloat awesomeFontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) awesomeFontSize = 40.0f;
    else awesomeFontSize = 20.0f;
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:awesomeFontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self getAllItemOfLocation];

}

- (void) getAllItemOfLocation{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.controller, @"/getAllInventory"];
        [ojoClicent getInventoryAllItemOfBar:url
                              andFinishBlock:^(NSArray *data) {
                                  NSDictionary *dicData = (NSDictionary *)data;
                                  NSString *stateCode = [dicData objectForKey:STATE];
                                  if ([stateCode isEqualToString:@"200"]) {
                                      
                                      NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                                      NSInteger count = response.count;
                                      
                                      [self.inventoryList removeAllObjects];
                                      Inventory *inventoryModel = nil;
                                      
                                      for (int i = 0; i < count; i++)
                                      {
                                          NSDictionary *userDict = (NSDictionary *) response[i];
                                          NSString *itemName = [userDict objectForKey:INVENTORY_ITEM_NAME];
                                          NSInteger frequency = [[userDict objectForKey:INVENTORY_FRUQUENCY] integerValue];
                                          NSInteger fullOpen = [[userDict objectForKey:INVENTORY_FULL_OPEN] integerValue];
                                          NSString *par = [userDict objectForKey:INVENTORY_PAR];
                                          NSString *amount = [userDict objectForKey:INVENTORY_AMOUNT];
                                          NSString *openBottleWet = [userDict objectForKey:INVENTORY_OPEN_BOTTLE_WET];
                                          NSString *itemPrice = [userDict objectForKey:INVENTORY_ITEM_PRICE];
                                          NSString *category = [userDict objectForKey:INVENTORY_CATEGORY];
                                          
                                          inventoryModel = [[Inventory alloc] initWithItemName:itemName
                                                                              andWithFrequency:frequency
                                                                               andWithFullOpen:fullOpen
                                                                          andWithOpenBottleWet:openBottleWet
                                                                                    andWithPar:par
                                                                              andWithItemPrice:itemPrice
                                                                                     andAmount:amount
                                                                                   andCategory:category];
                                          
                                          [self.inventoryList addObject:inventoryModel];
                                          
                                      }
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          [hud hide:YES];
                                          [self sortByRanking];
                                      });
                                  }
                                  
                                  else{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [hud hide:YES];
                                          NSString *response = [dicData objectForKey:MESSAGE];
                                          [self.view makeToast:response duration:1.5 position:CSToastPositionCenter];
                                          
                                      });
                                  }
                                  
                              } andFailBlock:^(NSError *error) {
                                  [self.view makeToast:@"Please Check Internect Connection" duration:1.5 position:CSToastPositionCenter];
                                  [hud hide:YES];
                                  
                              }];
    });
    
    
}

- (void) sortByRanking{
    [self.inventoryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Inventory *item1 = (Inventory *)obj1;
        Inventory *item2 = (Inventory *)obj2;
        if (item1.frequency > item2.frequency) {
            return NSOrderedAscending;
        } else if (item1.frequency < item2.frequency) {
            return NSOrderedDescending;
        } else {
            return  NSOrderedSame;
        }
    }];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableView delegate method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount;
    if (self.isFiltered) {
        rowCount = self.inventorySearchList.count;
    } else{
        rowCount = self.inventoryList.count;
    }
    return rowCount;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellItentifier = @"managerInventoryCell";
    ManagerInventoryTVC *inventoryCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    Inventory *inventoryModel;
    
    if(self.isFiltered) inventoryModel = (Inventory *)self.inventorySearchList[indexPath.row];
    else inventoryModel = (Inventory *)self.inventoryList[indexPath.row];
    
    
    inventoryCell.itemName.text = inventoryModel.itemName;
    inventoryCell.par.text = [NSString stringWithFormat:@"%@%@", @"PAR : ", inventoryModel.par];
    inventoryCell.amount.text = [NSString stringWithFormat:@"%@%@", @"AMOUNT : ", inventoryModel.amount];
    
    CGFloat fontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 20.0;
    else fontSize = 10.0f;
    
    NSInteger frequency = inventoryModel.frequency;
    switch (frequency) {
        case 0:
            [inventoryCell starZero:fontSize];
            break;
        case 1:
            [inventoryCell starOne:fontSize];
            break;
        case 2:
            [inventoryCell starTwo:fontSize];
            break;
        case 3:
            [inventoryCell starThree:fontSize];
            break;
        case 4:
            [inventoryCell starFour:fontSize];
            break;
            
        case 5:
            [inventoryCell starFive:fontSize];
            break;
        default:
            break;
    }
    inventoryCell.backgroundColor = inventoryCell.contentView.backgroundColor;
    return inventoryCell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
}

- (IBAction)onBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - search bar delegate method

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;
        self.inventorySearchList = [[NSMutableArray alloc] init];
        
        for (Inventory *inventory in self.inventoryList)
        {
            NSRange nameRange = [inventory.itemName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.inventorySearchList addObject:inventory];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
