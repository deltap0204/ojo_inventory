//
//  StockRefillVC.m
//  OJOv1
//
//  Created by MilosHavel on 25/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "StockRefillVC.h"
#import "Inventory.h"
#import "RefillTVC.h"
#import "AddedItemListVC.h"
#import "RefillItem.h"


@interface StockRefillVC ()
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIView *addPanelView;
@property (weak, nonatomic) IBOutlet UILabel *addItemName;

@property (weak, nonatomic) IBOutlet UITextField *addAmountField;
@property (weak, nonatomic) IBOutlet UITextField *addTotalPriceField;
@property (weak, nonatomic) IBOutlet UITextField *addDistributor;

@property (weak, nonatomic) IBOutlet UIButton *refillButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture1;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture2;


@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *inventorySearchList;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) Inventory *selectedInventory;
@property (assign, nonatomic) BOOL isFiltered;
@property (strong, nonatomic) NSString *deviceType;


@end

@implementation StockRefillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.addView setHidden:YES];
    // Do any additional setup after loading the view.
    self.inventoryList = [[NSMutableArray alloc] init];
    self.inventorySearchList = [[NSMutableArray alloc] init];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.tableView.delaysContentTouches = NO;
    // back and view button initialize
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    CGFloat fontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 35.0f;
    else fontSize = 20.0f;
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.viewButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.viewButton setTitle:@"\uf06e" forState:UIControlStateNormal];
    [self.viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.addDistributor setReturnKeyType:UIReturnKeyDone];

    
    [self getAllItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidLayoutSubviews{
    self.addAmountField.layer.cornerRadius = self.addAmountField.bounds.size.height/ 2;
    self.addTotalPriceField.layer.cornerRadius = self.addTotalPriceField.bounds.size.height/ 2;
    self.addDistributor.layer.cornerRadius = self.addDistributor.bounds.size.height/ 2;
    self.refillButton.layer.borderWidth = 1;
    self.refillButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.refillButton.layer.cornerRadius = self.refillButton.bounds.size.height / 2;

}

- (void) getAllItem{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", @"stocks/", @"getAllInventory"];
        [ojoClient getInventoryAllItemOfBar:url andFinishBlock:^(NSArray *data) {
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
                    NSString *itemPrice = [userDict objectForKey:INVENTORY_ITEM_PRICE];
                    NSString *category = [userDict objectForKey:INVENTORY_CATEGORY];
                    NSString *openBottleWet = @"";
                    
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
                    [self.view makeToast:response duration:2.5 position:CSToastPositionCenter];
                    
                });
            }
            
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please Check Internect Connection" duration:1.5 position:CSToastPositionCenter];
            
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

#pragma mark - navitation bar action method

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onView:(id)sender {

    NSString *identifiter = @"";
    if ([self.deviceType isEqualToString:@"iPad"]) identifiter = @"gotoAddItem_ipad";
    else identifiter = @"gotoAddItem";
        
    [self performSegueWithIdentifier:identifiter sender:nil];
}



#pragma mark - UItableView delegate Method

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
    
    static NSString *cellItentifier = @"refillCell";
    RefillTVC *refillCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    Inventory *inventoryModel;
    
    if(self.isFiltered) inventoryModel = (Inventory *)self.inventorySearchList[indexPath.row];
    else inventoryModel = (Inventory *)self.inventoryList[indexPath.row];
    
    
    refillCell.itemName.text = inventoryModel.itemName;
    refillCell.par.text = [NSString stringWithFormat:@"%@%@", @"PAR : ", inventoryModel.par];
    refillCell.priceLabel.text = [NSString stringWithFormat:@"SALE PRICE : $%@", inventoryModel.itemPrice];
//    NSInteger missingParInt = inventoryModel.par.intValue - inventoryModel.amount.intValue;
//    if (missingParInt < 0) {
//        missingParInt = 0;
//    }
    
    refillCell.missingPar.text = [NSString stringWithFormat:@"%@%@", @"AMOUNT : ", inventoryModel.amount];
    [refillCell.addButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [refillCell.addButton setTag:indexPath.row];
    refillCell.backgroundColor = refillCell.contentView.backgroundColor;
    return refillCell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
}

#pragma mark - Add button click method of cell

- (void)searchButtonClicked:(UIButton *)sender {
    self.addAmountField.text = @"";
    self.addTotalPriceField.text = @"";
    self.addDistributor.text = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    RefillTVC *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow = indexPath.row;
    NSString *itemName = cell.itemName.text;
    self.addItemName.text = itemName;
    Inventory *inventory;
    
    NSArray *foo1 = [cell.par.text componentsSeparatedByString:@" : "];
    NSString *par = foo1[1];
    
    NSArray *foo2 = [cell.missingPar.text componentsSeparatedByString:@" : "];
    NSString *amount = foo2[1];
    
    NSArray *foo3 = [cell.priceLabel.text componentsSeparatedByString:@"$"];
    NSString *price = foo3[1];
    
    inventory = [[Inventory alloc] initWithItemName:cell.itemName.text
                                   andWithFrequency:5
                                    andWithFullOpen:0
                               andWithOpenBottleWet:@"nil"
                                         andWithPar:par
                                   andWithItemPrice:price
                                          andAmount:amount
                                        andCategory:@""];
    
    self.selectedInventory = inventory;
    [self.addView setHidden:NO];
}


#pragma mark - Refill method

- (IBAction)onRefill:(id)sender {
    [self.addAmountField resignFirstResponder];
    
    NSString *addAmount = self.addAmountField.text;
    NSString *addPriceTotal = self.addTotalPriceField.text;
    NSString *addDistributor = self.addDistributor.text;
    
    if ([addAmount isEqualToString:@""]) {
        [self.addPanelView makeToast:@"INSERT REFILL AMOUNT" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([addPriceTotal isEqualToString:@""]){
        [self.addPanelView makeToast:@"INSERT PRICE TOTAL" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if([addDistributor isEqualToString:@""]){
        [self.addPanelView makeToast:@"INSERT DISTRIBUTOR" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    
    self.selectedInventory.openBottleWet = addAmount;
    [self.addView setHidden:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", @"stocks/", @"refill"];
        [ojoClient refill:url
              andItemName:self.addItemName.text
             andAddAmount:addAmount
           andFinishBlock:^(NSArray *data) {
               NSDictionary *dicData = (NSDictionary *)data;
               NSString *stateCode = [dicData objectForKey:STATE];
               if([stateCode isEqualToString:@"200"]){
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [hud hide:YES];
                       [self.addView setHidden:YES];
                      
                       NSString *updataAmount = [NSString stringWithFormat:@"%d", self.selectedInventory.amount.intValue + self.addAmountField.text.intValue];
                       
                       NSInteger count = self.inventoryList.count;
                       self.selectedInventory.amount = updataAmount;
                       if (self.isFiltered) {
                           [self.inventorySearchList replaceObjectAtIndex:self.selectedRow withObject:self.selectedInventory];
                           Inventory *searchedInventory = self.inventorySearchList[self.selectedRow];
                           NSString *searchListItemName = searchedInventory.itemName;
                           
                           for (int i = 0; i < count ; i ++) {
                               searchedInventory = self.inventoryList[i];
                               if ([searchedInventory.itemName isEqualToString:searchListItemName]) {
                                    [self.inventoryList replaceObjectAtIndex:i withObject:self.selectedInventory];
                                   break;
                               }
                           }
                           
                       } else{
                           [self.inventoryList replaceObjectAtIndex:self.selectedRow withObject:self.selectedInventory];
                       }
                       // Add the array at refilledArray
                       NSString *pricePerUnitStr = [NSString stringWithFormat:@"%d", self.addTotalPriceField.text.intValue/self.addAmountField.text.intValue];
                       float priceRateFlt = pricePerUnitStr.floatValue / self.selectedInventory.itemPrice.floatValue;
                       
                       NSString *priceRateStr = [NSString stringWithFormat:@"%.2f", priceRateFlt];
                       
                       RefillItem *refillModel;
                       refillModel = [[RefillItem alloc] initWithItemName:self.selectedInventory.itemName
                                                                   andPar:self.selectedInventory.par
                                                         andCurrentAmount:self.selectedInventory.amount
                                                        andRefilledAmount:self.addAmountField.text
                                                            andPriceTotal:self.addTotalPriceField.text
                                                          andPricePerUnit:pricePerUnitStr
                                                             andPriceRate:priceRateStr
                                                           andDistributor:self.addDistributor.text];
                       
                       
                       
                       [appDelegate.refilledArray addObject:refillModel];
                       [self.tableView reloadData];
                   });
                   
               } else{
                   [hud hide:YES];
                   [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
               }
               
           } andFailBlock:^(NSError *error) {
               [hud hide:YES];
               [self.view makeToast:@"Please Check Internect Connection" duration:1.5 position:CSToastPositionCenter];
               
           }];
    });
}


- (IBAction)onViewCancel:(id)sender {
    self.addAmountField.text = @"";
    [self.addView setHidden:YES];
}

- (IBAction)onGestureAction:(id)sender {
    [self.addAmountField resignFirstResponder];
}

- (IBAction)onGestureOtherAction:(id)sender {
    [self.addAmountField resignFirstResponder];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITextField delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchBar resignFirstResponder];
    return YES;
}

@end
