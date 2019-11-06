//
//  MoveItemListVC.m
//  OJOv1
//
//  Created by MilosHavel on 28/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "MoveItemListVC.h"
#import "Inventory.h"
#import "RefillTVC.h"
#import "LoginVC.h"
#import "MoveItem.h"
#import "KPDropMenu.h"


@interface MoveItemListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture1;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture2;
@property (weak, nonatomic) IBOutlet UIView *locationPanel;
@property (weak, nonatomic) IBOutlet UIView *AddView;
@property (weak, nonatomic) IBOutlet UIView *insertPanel;
@property (weak, nonatomic) IBOutlet UILabel *receiveItemName;
@property (weak, nonatomic) IBOutlet UITextField *receiveAmountTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIButton *viewCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *stockButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@property (strong, nonatomic) NSString *senderLocation;
@property (strong, nonatomic) NSMutableArray *itemList;
@property (strong, nonatomic) NSMutableArray *itemSearchList;
@property (assign, nonatomic) BOOL isFiltered;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *deviceType;

@end

@implementation MoveItemListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.AddView setHidden:YES];
    [self.locationPanel setHidden:YES];
    NSString *receiver = self.receivelocation;
    self.locationArray = [[NSMutableArray alloc] init];
    
    /*
     *  role = 2 stock manager
     *  role = 3 night manager
     */
    
    NSString *role = [LoginVC getLoggedinUser].role;
    if ([role isEqualToString:@"2"]) {

        self.locationArray = [NSMutableArray arrayWithObjects:@"STOCK", @"NEVERAS", @"ALMACEN", @"BAR LAX", @"BAR CENTRAL", @"BAR VIP", @"BAR OFFICE", @"BAR RED BULL", @"BAR DJ", @"COCINA", @"EVENTO", nil];
        self.senderLocation = @"STOCK";
        [self.stockButton setHidden:NO];

    } else{
        [self.stockButton setHidden:YES];
        self.locationArray = [NSMutableArray arrayWithObjects:@"NEVERAS", @"ALMACEN", @"BAR LAX", @"BAR CENTRAL", @"BAR VIP",@"BAR OFFICE",@"BAR RED BULL",@"BAR DJ",@"COCINA",@"EVENTO", nil];
        if ([receiver isEqualToString:@"NEVERAS"]) {
            self.senderLocation = @"ALMACEN";
        }
        else if ([receiver isEqualToString:@"NEVERAS"]) {
            self.senderLocation = @"ALMACEN";
        } else{
            self.senderLocation = @"NEVERAS";
        }
    }
    

    int i = 0;
    
    for(NSString *string in self.locationArray){
        if ([string isEqualToString:self.receivelocation]) {
            break;
        }
        i++;
    }
    [self.locationArray removeObjectAtIndex:i];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selLocation = [userDefaults objectForKey:SEL_LOCATION];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", @"ITEM LIST OF ", selLocation];
    
    CGFloat fontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 38.0f;
    else fontSize = 20.0f;
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.viewButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.viewButton setTitle:@"\uf06e" forState:UIControlStateNormal];
    [self.viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.viewCancelButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.viewCancelButton setTitle:@"\uf05c" forState:UIControlStateNormal];
    [self.viewCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    // tableview initialize
    self.itemList = [[NSMutableArray alloc] init];
    self.itemSearchList = [[NSMutableArray alloc] init];
    self.tableView.delaysContentTouches = NO;
    
    [self getAllItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews{
    self.receiveAmountTextFeild.layer.cornerRadius = self.receiveAmountTextFeild.bounds.size.height / 2;
    self.locationButton.layer.cornerRadius = self.locationButton.bounds.size.height / 2;
    self.moveButton.layer.borderWidth = 1.0;
    self.moveButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.moveButton.layer.cornerRadius = self.moveButton.bounds.size.height / 2;
    self.searchTextField.layer.cornerRadius = 23.0;
}
#pragma mark - server connect method

- (void) getAllItem{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/getAllInventory"];
        [ojoClient getInventoryAllItemOfBar:url andFinishBlock:^(NSArray *data) {
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                
                NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                NSInteger count = response.count;
                
                [self.itemList removeAllObjects];
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
                    
                    [self.itemList addObject:inventoryModel];

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
            [hud hide:YES];
            [self.view makeToast:@"Please Check Internect Connection" duration:1.5 position:CSToastPositionCenter];
            
        }];
    });
}

- (void) sortByRanking{
    [self.itemList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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

- (void) itemMove{
    
    NSString *receiveItemNameString = self.receiveItemName.text;
    NSString *receiveAmountString = self.receiveAmountTextFeild.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    NSString *senderName = [LoginVC getLoggedinUser].name;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        
        [ojoClient managerItemMove:MOVE_URL
                   andMoveItemName:receiveItemNameString
                     andMoveAmount:receiveAmountString
                 andSenderLocation:self.senderLocation
               andReceiverLocation:self.receivelocation
                     andSenderName:senderName
                    andFinishBlock:^(NSArray *data) {
                        
            
                        NSDictionary *dicData = (NSDictionary *)data;
                        NSString *stateCode = [dicData objectForKey:STATE];
                        if ([stateCode isEqualToString:@"200"]) {
                            [hud hide:YES];
                            [self.view makeToast:@"MOVING SUCCESS" duration:1.5 position:CSToastPositionCenter];
                            self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                            MoveItem *moveItemModel = nil;
                            moveItemModel = [[MoveItem alloc] initWithMoveItemName:self.receiveItemName.text
                                                                 andWithMoveAmount:self.receiveAmountTextFeild.text
                                                             andWithSenderLocation:self.senderLocation
                                                            andWithReceiveLocation:self.receivelocation
                                                                     andSenderName:senderName];
                            
                            [self.appDelegate.movedTempArray addObject:moveItemModel];
                        } else if ([stateCode isEqualToString:@"202"]){
                            [hud hide:YES];
                            NSString *amount = [dicData objectForKey:@"amount"];
                            NSString *alertStr = [NSString stringWithFormat:@"%@%@", @"Sorry, Amount is not enough. Availble Amount is ", amount];
                            [self.view makeToast:alertStr duration:1.5 position:CSToastPositionCenter];
                            
                        } else{
                            [hud hide:YES];
                            NSString *response = [dicData objectForKey:MESSAGE];
                            [self.view makeToast:response duration:1.5 position:CSToastPositionCenter];
                        }
                        
                    }
                      andFailBlock:^(NSError *error) {
                          [hud hide:YES];
                          [self.view makeToast:@"Please Check Internect Connection" duration:1.5 position:CSToastPositionCenter];
                          
                      }];
    });

}

#pragma  mark - Button action method

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onView:(id)sender {
    [self performSegueWithIdentifier:@"gotoMovedItemVC" sender:nil];
}


- (IBAction)onMove:(id)sender {
    
    if ([self.receiveAmountTextFeild.text isEqualToString:@""]) {
        [self.insertPanel makeToast:@"Please Enter Amount" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [self.AddView setHidden:YES];
    [self itemMove];
    
}

- (IBAction)onCancel:(id)sender {
    [self.AddView setHidden:YES];
}

#pragma Location Button Action

- (IBAction)onLocationSelect:(id)sender {
    [self.locationPanel setHidden:NO];
    [self.AddView setHidden:YES];
}

- (IBAction)onLocationButtonAction:(UIButton *)sender {
    if (![sender.titleLabel.text isEqualToString:self.receivelocation]) {
        self.senderLocation = sender.titleLabel.text;
        [self.locationButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        [self.locationPanel setHidden:YES];
        [self.AddView setHidden:NO];
    } else{
        [self.view makeToast:@"Not Allow" duration:1.5 position:CSToastPositionCenter];
    }
}





#pragma mark - UItableView delegate Method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount;
    if (self.isFiltered) {
        rowCount = self.itemSearchList.count;
    } else{
        rowCount = self.itemList.count;
    }
    return rowCount;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellItentifier = @"refillCell";
    RefillTVC *refillCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    Inventory *inventoryModel;
    
    if(self.isFiltered) inventoryModel = (Inventory *)self.itemSearchList[indexPath.row];
    else inventoryModel = (Inventory *)self.itemList[indexPath.row];
    
    
    refillCell.itemName.text = inventoryModel.itemName;
    refillCell.par.text = [NSString stringWithFormat:@"%@%@", @"PAR : ", inventoryModel.par];
//    NSInteger missingParInt = inventoryModel.par.intValue - inventoryModel.amount.intValue;
//    if (missingParInt < 0) missingParInt = 0;
    
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
    [self.AddView setHidden:NO];
    [self.insertPanel setHidden:NO];
    
    self.receiveAmountTextFeild.text = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    RefillTVC *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow = indexPath.row;
    NSString *itemName = cell.itemName.text;
    self.receiveItemName.text = itemName;
   
//    NSArray *foo1 = [cell.par.text componentsSeparatedByString:@" : "];
//    NSString *par = foo1[1];
//    
//    NSArray *foo2 = [cell.missingPar.text componentsSeparatedByString:@" : "];
//    NSString *missingPar = foo2[1];
    
}



- (IBAction)tabGestureAction1:(id)sender {
    [self.receiveAmountTextFeild resignFirstResponder];
    
}

- (IBAction)tabGestureAction2:(id)sender {
    [self.receiveAmountTextFeild resignFirstResponder];
}


#pragma mark - TextField delegate method for Search bar

- (IBAction)searchTextFieldAction:(UITextField *)sender {
    
    NSString *text = sender.text;
    if(text.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;
        self.itemSearchList = [[NSMutableArray alloc] init];
        
        for (Inventory *inventory in self.itemList)
        {
            NSRange nameRange = [inventory.itemName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.itemSearchList addObject:inventory];
            }
        }
    }
    
    [self.tableView reloadData];
    
    
}


@end
