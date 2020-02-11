//
//  InventoryListVC.m
//  OJOv1
//
//  Created by MilosHavel on 15/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "InventoryListVC.h"
#import "InventoryMainVC.h"
#import "Inventory.h"
#import "Item.h"
#import "InventoryTVC.h"
#import "aloneItemNameTVC.h"
#import "FRDLivelyButton.h"

@interface InventoryListVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startInventoryButton;
@property (weak, nonatomic) IBOutlet UIButton *setSequenceButton;
@property (weak, nonatomic) IBOutlet FRDLivelyButton *goButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *inventorySearchList;
@property (assign, nonatomic) BOOL isFiltered;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) NSInteger selectedRowOfAddInventory;

// additional option view
@property (weak, nonatomic) IBOutlet UIView *additionalView;
@property (assign, nonatomic) BOOL additionalViewSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalViewBottomConstrainit;



// ADD VIEW
@property (weak, nonatomic) IBOutlet UIView *totalAddView;
@property (weak, nonatomic) IBOutlet UIView *addPanelView;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *setParTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *addViewCloseButton;
@property (weak, nonatomic) IBOutlet UIButton *addInventoryButton;
@property (weak, nonatomic) IBOutlet UITableView *itemSearchTableView;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) NSMutableArray *itemSearchArray;
@property (assign, nonatomic) BOOL isItemFiltered;
@property (assign, nonatomic) BOOL isEdit;



@end

@implementation InventoryListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.totalAddView setHidden:YES];
    
    self.itemNameTextFeild.delegate = self;
    
    // set view of additional view option
//    [self.additionalView setHidden:YES];
    [self.goButton setStyle:kFRDLivelyButtonStyleCaretRight animated:YES];
    self.additionalViewSwitch = NO;
    
    // set the controller and model from NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.locationController = [userDefaults objectForKey:CONTROLLER];
    
    // Adding UILongGestureRecognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    // View initialize
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", @"INVENTORY LIST OF ", self.location];
    self.inventoryList = [[NSMutableArray alloc] init];
    self.inventorySearchList = [[NSMutableArray alloc] init];
    self.itemArray = [[NSMutableArray alloc] init];
    self.itemSearchArray = [[NSMutableArray alloc] init];
    self.isFiltered = NO;
    self.isItemFiltered = NO;
    
    [self loadAllItem];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.additionalViewSwitch) {
        [self additionalViewHidden];
    }
    
}

- (void) viewDidLayoutSubviews{
    CGFloat radius = self.itemNameTextFeild.bounds.size.height / 2;
    self.itemNameTextFeild.layer.cornerRadius = radius;
    self.setParTextFeild.layer.cornerRadius = radius;

    [self.addButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.addButton setTitle:@"\uf067" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    /*Add View Close Button*/
    
//    [self.addViewCloseButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
//    [self.addViewCloseButton setTitle:@"\uf057" forState:UIControlStateNormal];
//    [self.addViewCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.addInventoryButton.layer.borderWidth = 1.0f;
    self.addInventoryButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.addInventoryButton.layer.cornerRadius = radius;
    
    self.startInventoryButton.layer.cornerRadius = self.startInventoryButton.bounds.size.height / 2;
    self.setSequenceButton.layer.cornerRadius = self.setSequenceButton.bounds.size.height / 2;
    
    self.goButton.layer.cornerRadius = self.goButton.bounds.size.height / 2;
    
    
    self.searchTextField.layer.cornerRadius = 23.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - server connection method


- (void) loadAllItem{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        [ojoClicent getAllItems:GET_ALL_ITEM onFinish:^(NSArray *data) {
            
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                
                NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                NSInteger count = response.count;
                
                [self.itemArray removeAllObjects];
                Item *itemModel = nil;
                
                for (int i = 0; i < count; i++) {
                    
                    NSDictionary *userDict = (NSDictionary *) response[i];
                    NSString *ItemName = [userDict objectForKey:ITEM_NAME];
                    NSString *categoryName = [userDict objectForKey:ITEM_CATEGORY];
                    NSInteger fullOpen = [[userDict objectForKey:FULL_OPEN] integerValue];
                    NSInteger frequency = [[userDict objectForKey:FREQUENCY] integerValue];
                    NSString *price = [userDict objectForKey:PRICE];
                    
                    
                    itemModel = [[Item alloc] initWithItemName:ItemName
                                            andWithFullAndOpen:fullOpen
                                           andWithCategoryName:categoryName
                                                  andFrequency:frequency
                                                      andPrice:price];
                    [self.itemArray addObject:itemModel];
                }
                
                AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                appDelegate.allItemArray = self.itemArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud setHidden:YES];
                    [self.itemSearchTableView reloadData];
                });
                [self sortItemArrayByAlphbet];
                [self getAllItemOfBar];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud setHidden:YES];
                    [self.itemArray removeAllObjects];
                    NSString *response = [dicData objectForKey:MESSAGE];
                    [self.view makeToast:response duration:1.5 position:CSToastPositionCenter];
                });
            }
            
        } onFail:^(NSError *error) {
            [hud setHidden:YES];
            [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
        }];
    });
}



- (void) getAllItemOfBar{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/getAllInventory"];
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
                                          [self.tableView reloadData];
                                          [hud hide:YES];
                                          

                                          //[self sortByRanking];
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
                                  [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                                  [hud hide:YES];
                              }];
    });
}


- (void) setInventory:(Inventory *)inventoryModel{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/addInventory"];
        [ojoClient addInventory:url andItemName:inventoryModel.itemName andParStr:inventoryModel.par andFinishBlock:^(NSArray *data){
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    NSInteger count = 0;
                    Inventory *searchedInventory;
                    if(self.isFiltered) {
                        count = self.inventorySearchList.count;
                    }
                    else {
                        count = self.inventoryList.count;
                        
                    }
                    if (self.isEdit) {
                        for (int i = 0; i < count ; i ++) {
                            if (self.isFiltered) searchedInventory = (Inventory*)self.inventorySearchList[i];
                            else searchedInventory = (Inventory*)self.inventoryList[i];
                            
                            if ([searchedInventory.itemName isEqualToString:inventoryModel.itemName]) {
                                if (self.isFiltered) [self.inventorySearchList replaceObjectAtIndex:i withObject:inventoryModel];
                                else [self.inventoryList replaceObjectAtIndex:i withObject:inventoryModel];
                                break;
                            }
                        }
                    } else{
                        [self.inventoryList addObject:inventoryModel];
                        [self.inventorySearchList addObject:inventoryModel];
                    }
                    
                    [self.tableView reloadData];
                });
            } else{
                [hud hide:YES];
                [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                
            }
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
            
        }];
        
    });
}

- (void) unsetInventory:(NSString*)itemName withRow:(NSInteger)row{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/unsetInventory"];
        [ojoClient unsetInventory:url andItemName:itemName andFinishBlock:^(NSArray *data) {
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.inventoryList removeObjectAtIndex:row];
                    [self.tableView reloadData];
                    [hud hide:YES];
                });
            } else{
                [hud hide:YES];
            }
            
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
            
        }];
        
    });
    
}


#pragma mark - sort action method

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

- (void) sortItemArrayByAlphbet{
    [self.itemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Item *item1 = (Item *)obj1;
        Item *item2 = (Item *)obj2;
        return [item1.itemName compare:item2.itemName];
    }];
}


#pragma mark - button action method

- (IBAction)onStartInventory:(id)sender {
    
}


- (IBAction)onSetSequence:(id)sender {
    Inventory *invModel = nil;
//    NSArray *array = [[NSArray alloc] init];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.inventoryList.count; i++) {
        invModel = (Inventory*) self.inventoryList[i];
        NSString *itemName = @"";
        NSString *openBottleWet = @"";
        NSString *amount = @"0";
        NSString *par = @"0";
        NSString *itemPrice = @"";
        
        if (invModel.itemName != nil) itemName = invModel.itemName;
        if (invModel.openBottleWet != nil) openBottleWet = invModel.openBottleWet;
        if (invModel.amount != nil) amount = invModel.amount;
        if (invModel.par != nil) par = invModel.par;
        if (invModel.itemPrice != nil) itemPrice = invModel.itemPrice;
        
        NSDictionary *dicData = @{@"item_name": itemName, @"open_bt_wet": openBottleWet, @"amount": amount, @"par":par, @"sale": itemPrice};
        [mutableArray addObject:dicData];
        
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableArray options:NSJSONWritingPrettyPrinted error:&error];
//    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:self.inventoryList];

    if (!jsonData) {
        NSLog(@"failed to create json data : %@", [error localizedDescription]);
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"Setting...";
    [hud show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/setSequence"];
        [ojoClicent setSequence:url
                  andJsonString:jsonString onFinish:^(NSArray *data) {
                      
                      NSDictionary *dicData = (NSDictionary *)data;
                      NSString *stateCode = [dicData objectForKey:STATE];
                      if ([stateCode isEqualToString:@"200"]) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [hud hide:YES];
                              [self.view makeToast:@"Success to set sequence!" duration:1.5 position:CSToastPositionCenter];
                              
                          });
                      } else{
                          [hud hide:YES];
                          [self.view makeToast:@"Fail to set sequence! Please retry" duration:1.5 position:CSToastPositionCenter];
                      }
            
        } onFail:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
        }];
        
    });
}

- (IBAction)onGoAction:(id)sender {
    
    if (!self.additionalViewSwitch) {
        
        [self additionalViewShow];
        
    } else{
    
        
        [self additionalViewHidden];
        
    }
    
}

- (void) additionalViewHidden{
    self.additionalViewSwitch = NO;
    [self.goButton setStyle:kFRDLivelyButtonStyleCaretRight animated:YES];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.additionalView.frame = CGRectMake(self.additionalView.frame.origin.x, self.view.frame.size.height, self.additionalView.frame.size.width, self.additionalView.frame.size.height);
    } completion:nil];
    
}

- (void) additionalViewShow{
    self.additionalViewSwitch = YES;
    [self.goButton setStyle:kFRDLivelyButtonStyleClose animated:YES];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.additionalView.frame = CGRectMake(self.additionalView.frame.origin.x, self.view.frame.size.height - 180, self.additionalView.frame.size.width, self.additionalView.frame.size.height);
    } completion:nil];

}

- (IBAction)onBack:(id)sender {
    InventoryMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryMainPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];
    
}

- (IBAction)onAdd:(id)sender {
    self.isEdit = NO;
    [self.totalAddView setHidden:NO];
    [self.itemSearchTableView setHidden:YES];
    self.addInventoryButton.titleLabel.text = @"ADD";
    self.itemNameTextFeild.text = @"";
    [self.itemNameTextFeild setEnabled:YES];
    self.setParTextFeild.text = @"";
}


- (IBAction)onViewClose:(id)sender {
    [self.totalAddView setHidden:YES];
    
    
}


- (IBAction)onAddInventory:(id)sender {
    if ([self.itemNameTextFeild.text isEqualToString:@""]) {
        [self.addPanelView makeToast:@"Insert Item Name" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.setParTextFeild.text isEqualToString:@""]) {
        [self.addPanelView makeToast:@"Insert Amount of Par" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    NSString *itemName = self.itemNameTextFeild.text;
    NSString *par = self.setParTextFeild.text;
    Inventory *inventoryModel = nil;
    
    if (self.isEdit) {
        Inventory *inventory = (Inventory*)self.inventoryList[self.selectedRow];
        inventoryModel = [[Inventory alloc] initWithItemName:itemName
                                            andWithFrequency:inventory.frequency
                                             andWithFullOpen:inventory.fullOpen
                                        andWithOpenBottleWet:inventory.openBottleWet
                                                  andWithPar:par
                                            andWithItemPrice:inventory.itemPrice
                                                   andAmount:inventory.amount
                                                 andCategory:@""];
    } else{
        Inventory *inventoryTestModel = nil;
        for (int i = 0; i < self.inventoryList.count; i++) {
            inventoryTestModel = (Inventory*)self.inventoryList[i];
            NSString *inventoryItemName = inventoryTestModel.itemName;
            if ([inventoryItemName isEqualToString:itemName]) {
                [self.addPanelView makeToast:@"Sorry, This Item Is Already Exist" duration:1.5 position:CSToastPositionCenter];
                return;
            }
            
        }
        
        // for get the ranking of item
        Item *itemTestModel = nil;
        NSInteger ranking = 0;
        for (int j = 0; j < self.itemArray.count; j++) {
            itemTestModel = (Item*)self.itemArray[j];
            if ([itemTestModel.itemName isEqualToString:itemName]) {
                ranking = itemTestModel.frequency;
                break;
            }
        }
        
        
        inventoryModel = [[Inventory alloc] initWithItemName:itemName
                                                       andWithFrequency:ranking
                                                        andWithFullOpen:1
                                                   andWithOpenBottleWet:@""
                                                             andWithPar:par
                                                       andWithItemPrice:@""
                                                              andAmount:@""
                                                            andCategory:@""];
    }
    
    
    [self setInventory:inventoryModel];
    [self.totalAddView setHidden:YES];
}

#pragma mark - UItableView delegate Method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount;
    if (tableView == self.tableView) {
        
        if (self.isFiltered) {
            rowCount = self.inventorySearchList.count;
            
        } else{
            rowCount = self.inventoryList.count;
            
        }
        return rowCount;
        
    } else{
        if (self.isItemFiltered) {
            rowCount = self.itemSearchArray.count;
            
        } else{
            rowCount = self.itemArray.count;
            
        }
        return rowCount;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.tableView) {
        static NSString *cellItentifier = @"inventoryItemCell";
        InventoryTVC *inventoryCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
        Inventory *inventoryModel;
        
        if(self.isFiltered) inventoryModel = (Inventory *)self.inventorySearchList[indexPath.row];
        else inventoryModel = (Inventory *)self.inventoryList[indexPath.row];
        
        
        inventoryCell.itemNameLabel.text = inventoryModel.itemName;
        inventoryCell.parLabel.text = [NSString stringWithFormat:@"%@%@", @"PAR : ", inventoryModel.par];
        inventoryCell.amountLabel.text = [NSString stringWithFormat:@"%@%@", @"AMOUNT : ", inventoryModel.amount];
        
        NSInteger frequency = inventoryModel.frequency;
        switch (frequency) {
            case 0:
                [inventoryCell starZero];
                break;
            case 1:
                [inventoryCell starOne];
                break;
            case 2:
                [inventoryCell starTwo];
                break;
            case 3:
                [inventoryCell starThree];
                break;
            case 4:
                [inventoryCell starFour];
                break;
                
            case 5:
                [inventoryCell starFive];
                break;
            default:
                break;
        }
        inventoryCell.backgroundColor = inventoryCell.contentView.backgroundColor;
        return inventoryCell;
        
    } else{
        static NSString *cellIdentifier = @"allItemCell";
        aloneItemNameTVC *alloneItemCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        Item *itemModel;
        
        if(self.isItemFiltered) itemModel = (Item *)self.itemSearchArray[indexPath.row];
        else itemModel = (Item *)self.itemArray[indexPath.row];
        
        alloneItemCell.itemNameLableOfAddVIew.text = itemModel.itemName;
        return alloneItemCell;
    }
    
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        self.selectedRow = indexPath.row;
    } else{
        self.selectedRowOfAddInventory = indexPath.row;
        [self.itemSearchTableView setHidden:YES];
        Item *itemModel;
        
        if(self.isItemFiltered) itemModel = (Item *)self.itemSearchArray[indexPath.row];
        else itemModel = (Item *)self.itemArray[indexPath.row];
        
        NSString *selectedItemName = itemModel.itemName;
        self.itemNameTextFeild.text = selectedItemName;
    }
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    Inventory *inventoryModel;
    
    if(self.isFiltered) inventoryModel = (Inventory *)self.inventorySearchList[indexPath.row];
    else inventoryModel = (Inventory *)self.inventoryList[indexPath.row];
    
    
    UITableViewRowAction *button;
    button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"DELETE" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        UIAlertController *alert = nil;
                                        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to delete this inventory?" preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                                                     style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                                                       [self unsetInventory:inventoryModel.itemName withRow:indexPath.row];
                                                                                   }];
                                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Calcel"
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                       }];
                                        [alert addAction:ok];
                                        [alert addAction:cancel];
                                        [self presentViewController:alert animated:YES completion:nil];
                                    }];
    button.backgroundColor = [UIColor redColor]; //arbitrary color
    UITableViewRowAction *button2;
    button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" EDIT " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         self.isEdit = YES;
                                         if ([inventoryModel.itemName isEqual:[NSNull null]]) self.itemNameTextFeild.text = @"";
                                         else self.itemNameTextFeild.text = inventoryModel.itemName;
                                         if ([inventoryModel.par isEqual:[NSNull null]]) self.setParTextFeild.text = @"";
                                         else self.setParTextFeild.text = inventoryModel.par;
                                         self.addInventoryButton.titleLabel.text = @"EDIT";
                                         [self.itemNameTextFeild setEnabled:NO];
                                         [self.totalAddView setHidden:NO];
                                         [self.itemSearchTableView setHidden:YES];
                                         
                                         
                                     }];
    button2.backgroundColor = [UIColor blueColor]; //arbitrary color
    return @[button, button2];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - TableView longpress gesturer method (moving items sequence)


- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.inventoryList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
    
}



#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
    
}

#pragma mark - search bar delegate method

- (IBAction)onItemNameChangeEvent:(UITextField *)sender {
    NSString *curentStr = sender.text;
    if (![curentStr isEqualToString:@""]) {
        [self.itemSearchTableView setHidden:NO];
        
        self.isItemFiltered = YES;
        self.itemSearchArray = [[NSMutableArray alloc] init];
        for (Item *item in self.itemArray)
        {
            NSRange nameRange = [item.itemName rangeOfString:curentStr options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.itemSearchArray addObject:item];
            }
        }
    
    } else{
    
        self.isItemFiltered = NO;
    }
    [self.itemSearchTableView reloadData];
}

#pragma mark  UITextfield Delegates

- (IBAction)searchTextFieldChangeAction:(UITextField *)sender {
    NSString *text = sender.text;
    
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




-(void)textFieldDidBeginEditing:(UITextField *)textField {

    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
 
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
