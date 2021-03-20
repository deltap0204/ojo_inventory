//
//  ItemMainVC.m
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ItemMainVC.h"
#import "Item.h"
#import "Category.h"
#import "ItemTVC.h"
#import "AdminMainVC.h"
#import "ItemFull.h"
#import "AddItemVC.h"


@interface ItemMainVC ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSeg;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

// item view page

@property (weak, nonatomic) IBOutlet UIView *itemDetailView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabelInView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabelInView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageViewInView;
@property (weak, nonatomic) IBOutlet UILabel *itemWeightFullLabelInView;
@property (weak, nonatomic) IBOutlet UILabel *itemWeightEmptyLabelInView;
@property (weak, nonatomic) IBOutlet UILabel *liquidWeidhtLabelInView;
@property (weak, nonatomic) IBOutlet UILabel *servingLabelInView;
@property (weak, nonatomic) IBOutlet UILabel *weightPerServingLabelInView;
@property (weak, nonatomic) IBOutlet UILabel *pricePerServingLabelInView;

// -- location choose imageviews
@property (weak, nonatomic) IBOutlet UIImageView *barcentralImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barofficeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barlaxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bardjImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eventoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barvipImageView;



@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) NSMutableArray *itemSearchArray;
@property (strong, nonatomic) NSMutableArray *sortedArray;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) BOOL isFiltered;
@property (assign, nonatomic) NSInteger frequencyInt;

@end

@implementation ItemMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.itemArray = [[NSMutableArray alloc] init];
    self.itemSearchArray = [[NSMutableArray alloc] init];
    self.isFiltered = NO;
    
    // Adding UILongGestureRecognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    // UIView initialize
    [self.itemDetailView setHidden:YES];
    
    
    [self loadAllData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidLayoutSubviews{
    [self.addButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.addButton setTitle:@"\uf067" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.searchTextField.layer.cornerRadius = 23.0;
    
}





#pragma mark - segument controller method

- (IBAction)onSortSegAction:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0: // sort by item name
            [self sortItemArrayByAlphaBet];
            [self.tableView reloadData];
            
            break;
        case 1: // sort by ranking
            [self sortItemArrayByAlphaBet];
            [self.itemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                ItemFull *item1 = (ItemFull *)obj1;
                ItemFull *item2 = (ItemFull *)obj2;
                if (item1.frequency > item2.frequency) {
                    return NSOrderedAscending;
                } else if (item1.frequency < item2.frequency) {
                    return NSOrderedDescending;
                } else {
                    return  NSOrderedSame;
                }
            }];
            [self.tableView reloadData];
            break;
            
        case 2: // sort by category
            [self sortItemArrayByAlphaBet];
            [self.itemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                ItemFull *item1 = (ItemFull *)obj1;
                ItemFull *item2 = (ItemFull *)obj2;
                return [item1.categoryName compare:item2.categoryName];
            }];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark - sorting method according to alphabet

- (void) sortItemArrayByAlphaBet{
    [self.itemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ItemFull *item1 = (ItemFull *)obj1;
        ItemFull *item2 = (ItemFull *)obj2;
        return [item1.itemName compare:item2.itemName];
    }];
}

#pragma mark - server connect method

- (void) loadAllData{
    
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
                
                ItemFull *itemFullModel = nil;
                
                for (int i = 0; i < count; i++) {
                    
                    NSDictionary *userDict = (NSDictionary *) response[i];
                    NSString *itemName = [userDict objectForKey:ITEM_NAME];
                    NSString *categoryName = [userDict objectForKey:ITEM_CATEGORY];
                    NSInteger fullOpen = [[userDict objectForKey:FULL_OPEN] integerValue];
                    NSInteger frequency = [[userDict objectForKey:FREQUENCY] integerValue];
                    NSString *price = [userDict objectForKey:PRICE];
                    NSString *btFullWet = [userDict objectForKey:BT_FULL_WET];
                    NSString *btEmpWet = [userDict objectForKey:@"be_emp_wet"];
                    NSString * ligWet = [userDict objectForKey:LIQ_WET];
                    NSString *serveWet = [userDict objectForKey:SERVE_WET];
                    NSString *servBt = [userDict objectForKey:SERVE_BOTTLE];
                    
                    NSMutableArray *locationArray = (NSMutableArray *)[userDict objectForKey:@"active_locations"];

//                    NSInteger locationCount = locationArray.count;
//                    for (int j = 0; j < locationCount; j++) {
//                        NSString *location = (NSString*)locationArray[j];
//                        [activedLocationArray addObject:location];
//                    }
                                     
                    
                    itemFullModel = [[ItemFull alloc] initWithItemName:itemName
                                                    andWithFullAndOpen:fullOpen
                                                   andWithCategoryName:categoryName
                                                      andWithBtFullWet:btFullWet
                                                       andWithBtEmpWet:btEmpWet
                                                         andWithLiqWet:ligWet
                                                         andWithServBt:servBt
                                                        andWithServWet:serveWet
                                                          andWithprice:price
                                                      andWithFrequence:frequency
                                           andWithActivedLocationArray:locationArray];
                    
                    
                    
                    [self.itemArray addObject:itemFullModel];
                    
                }
                [self sortItemArrayByAlphaBet];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.tableView reloadData];
                });
            }
            
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.itemArray removeAllObjects];
                    [self.tableView reloadData];
                    NSString *response = [dicData objectForKey:MESSAGE];
                    [self.view makeToast:response duration:2.5 position:CSToastPositionCenter];
                    
                });
            }
            
        } onFail:^(NSError *error) {
            [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
            
        }];
        
    });
    
    
}

#pragma mark - UItableView delegate Method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount;
    if (self.isFiltered) {
        rowCount = self.itemSearchArray.count;
    } else{
        rowCount = self.itemArray.count;
    }
    return rowCount;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellItentifier = @"itemCell";
    ItemTVC *itemCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    ItemFull *itemModel;
    
    if(self.isFiltered) itemModel = (ItemFull *)self.itemSearchArray[indexPath.row];
    else itemModel= (ItemFull *)self.itemArray[indexPath.row];
    
    
    NSString *imageNameWithUpper = [itemModel.itemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *imageName = [imageNameWithUpper lowercaseString];
    itemCell.itemImageView.image = [UIImage imageNamed:imageName];
    if (itemCell.itemImageView.image == nil) {
        itemCell.itemImageView.image = [UIImage imageNamed:@"coming_soon"];
    }
    
    itemCell.itemName.text = itemModel.itemName;
    itemCell.categoryName.text = itemModel.categoryName;
    
    
    NSInteger fullOpen = itemModel.fullAndOpen;
    if (fullOpen == 1) {
        itemCell.itemFullOpen.text = @"FULL/OPEN";
    } else{
        itemCell.itemFullOpen.text = @"FULL";
    }
//    [itemCell labelBorder];
    
    NSInteger frequency = itemModel.frequency;
    switch (frequency) {
        case 0:
            [itemCell starZero];
            break;
        case 1:
            [itemCell starOne];
            break;
        case 2:
            [itemCell starTwo];
            break;
        case 3:
            [itemCell starThree];
            break;
        case 4:
            [itemCell starFour];
            break;
            
        case 5:
            [itemCell starFive];
            break;
        default:
            break;
    }
    itemCell.priceStr.text = [NSString stringWithFormat:@"%@%@", @"PRICE : $", itemModel.price];
    itemCell.backgroundColor = itemCell.contentView.backgroundColor;
    return itemCell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedRow = indexPath.row;
    
    ItemFull *itemModel;
    
    if(self.isFiltered) itemModel = (ItemFull *)self.itemSearchArray[indexPath.row];
    else itemModel= (ItemFull*)self.itemArray[indexPath.row];
    
    
    self.itemNameLabelInView.text = itemModel.itemName;
    self.categoryNameLabelInView.text = [NSString stringWithFormat:@"( %@ )", itemModel.categoryName];
    
    NSString *imageNameWithUpper = [itemModel.itemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *imageName = [imageNameWithUpper lowercaseString];
    self.itemImageViewInView.image = [UIImage imageNamed:imageName];
    if (self.itemImageViewInView.image == nil) {
        self.itemImageViewInView.image = [UIImage imageNamed:@"coming_soon"];
    }
    
    
    self.itemWeightFullLabelInView.text = itemModel.btFullWet;
    self.itemWeightEmptyLabelInView.text = itemModel.btEmpWet;
    self.liquidWeidhtLabelInView.text = itemModel.liqWet;
    self.servingLabelInView.text = itemModel.servBt;
    self.weightPerServingLabelInView.text = itemModel.servWet;
    self.pricePerServingLabelInView.text = itemModel.price;
        
    for (int i = 0; i < itemModel.activedLocationArray.count; i++) {
        
        NSString *activeLocation = (NSString*)itemModel.activedLocationArray[i];
        
        if ([activeLocation isEqual:@"BAR CENTRAL"]) {
            self.barcentralImageView.image = [UIImage imageNamed:@"location_selected"];
        } else if([activeLocation isEqual:@"BAR OFFIC"]) {
            self.barofficeImageView.image = [UIImage imageNamed:@"location_selected"];
        } else if([activeLocation isEqual:@"BAR LAX"]){
            self.barlaxImageView.image = [UIImage imageNamed:@"location_selected"];;
        } else if([activeLocation isEqual:@"STOCK"]){
            self.stockImageView.image = [UIImage imageNamed:@"location_selected"];;
        } else if([activeLocation isEqual:@"BAR DJ"]){
            self.bardjImageView.image = [UIImage imageNamed:@"location_selected"];
        } else if([activeLocation isEqual:@"EVENTO"]){
            self.eventoImageView.image = [UIImage imageNamed:@"location_selected"];;
        } else if([activeLocation isEqual:@"BAR VIP"]){
            self.barvipImageView.image = [UIImage imageNamed:@"location_selected"];
        } else {
            NSLog(@"Not active location now");
        }
        
    }
    
    
    [self.itemDetailView setHidden:NO];
    
    
}

- (NSArray *) tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    ItemFull *itemFull;
    
    if(self.isFiltered) itemFull = (ItemFull*)self.itemSearchArray[indexPath.row];
    else itemFull = (ItemFull*)self.itemArray[indexPath.row];
    
    UITableViewRowAction *editButton;
    UITableViewRowAction *deleteButton;
    
    self.selectedRow = indexPath.row;
    
    editButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" EDIT " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                  {
        
        [self performSegueWithIdentifier:@"addItem" sender:tableView];
                      
                  }];
    
    
    
    deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"DELETE" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = nil;
        Item *itemModel = nil;
        itemModel = self.itemArray[indexPath.row];
        
        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to delete this item ?"
                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                       hud.userInteractionEnabled = NO;
                                                       [hud show:YES];
                                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                           OJOClient *ojoClient = [OJOClient sharedWebClient];
                                                           
                                                           [ojoClient deleteItem:DELETE_ITEM
                                                                     andItemName:itemModel.itemName
                                                                   onFinishBlock:^(NSArray *data) {
                                                                       NSDictionary *dicData = (NSDictionary *) data;
                                                                       NSString *stateCode = [dicData objectForKey:STATE];
                                                                       if ([stateCode isEqualToString:@"200"]) {
                                                                           [hud hide:YES];
                                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                                           [self.itemArray removeObjectAtIndex:indexPath.row];
                                                                           [self.tableView reloadData];
                                                                           
                                                                       } else{
                                                                           NSString *errorStr = [dicData objectForKey:MESSAGE];
                                                                           [self.view makeToast:errorStr duration:2.5 position:CSToastPositionCenter];
                                                                       }
                                                               
                                                           } onFailBlock:^(NSError *error) {
                                                               [hud hide:YES];
                                                               [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
                                                               
                                                           }];
                                                       });
                                                       
                                                   }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
    
    
    
    
    
    
    deleteButton.backgroundColor = [UIColor redColor];
    editButton.backgroundColor = [UIColor blueColor];
    return @[editButton, deleteButton];
    
}




- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //do whatever u want after row has been moved
}


#pragma mark - tableview longpress gesture


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
            [self.itemArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
            
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

- (IBAction)searchTextFieldAction:(UITextField *)sender {
    
    NSString *text = sender.text;
    
    if(text.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;
        self.itemSearchArray = [[NSMutableArray alloc] init];
        
        for (ItemFull* item in self.itemArray)
        {
            NSRange nameRange = [item.itemName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.itemSearchArray addObject:item];
            }
        }
    }
    
    [self.tableView reloadData];
    
    
}

#pragma mark - Button Action

- (IBAction)itemDetailViewCancelAction:(id)sender {
    
    // Initialization all item detail
    
    self.itemNameLabelInView.text = @"";
    self.categoryNameLabelInView.text = @"";
    self.itemImageViewInView.image = [UIImage imageNamed:@"coming_soon"];
    self.itemWeightFullLabelInView.text = @"0";
    self.itemWeightEmptyLabelInView.text = @"0";
    self.liquidWeidhtLabelInView.text = @"0";
    self.servingLabelInView.text = @"0";
    self.weightPerServingLabelInView.text = @"0";
    self.pricePerServingLabelInView.text = @" ";
    
    self.barcentralImageView.image = [UIImage imageNamed:@"location_unselected"];
    self.barofficeImageView.image = [UIImage imageNamed:@"location_unselected"];
    self.barlaxImageView.image = [UIImage imageNamed:@"location_unselected"];;
    self.stockImageView.image = [UIImage imageNamed:@"location_unselected"];;
    self.bardjImageView.image = [UIImage imageNamed:@"location_unselected"];
    self.eventoImageView.image = [UIImage imageNamed:@"location_unselected"];;
    self.barvipImageView.image = [UIImage imageNamed:@"location_unselected"];
    
    [self.itemDetailView setHidden:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AddItemVC *viewControler = (AddItemVC*)segue.destinationViewController;
    
    ItemFull *itemFullModel;
    
    if (sender == self.addButton){
        
        itemFullModel = [[ItemFull alloc] initWithItemName:@""
                                   andWithFullAndOpen:0
                                  andWithCategoryName:@""
                                     andWithBtFullWet:@""
                                      andWithBtEmpWet:@""
                                        andWithLiqWet:@""
                                        andWithServBt:@""
                                            andWithServWet:@""
                                         andWithprice:@""
                                     andWithFrequence:0
                          andWithActivedLocationArray:nil];
        
    } else {
        
        itemFullModel = self.itemArray[self.selectedRow];
        
    }
    
    viewControler.fromVC = sender == self.addButton ? @"add" : @"edit";
    viewControler.selectedItem = itemFullModel;
    
    
}

#pragma mark - navigation view action

- (IBAction)onAdd:(id)sender {
    self.selectedRow = 3000;
    [self performSegueWithIdentifier:@"addItem" sender:sender];
    
}

- (IBAction)onBack:(id)sender {
    
    AdminMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"adminPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];
    
}


@end
