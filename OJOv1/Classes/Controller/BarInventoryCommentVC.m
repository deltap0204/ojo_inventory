//
//  BarInventoryCommentVC.m
//  OJOv1
//
//  Created by MilosHavel on 19/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "BarInventoryCommentVC.h"
#import "BartenderVC.h"
#import "LoginVC.h"
#import "InventoryReport.h"
#import "Confirm.h"
#import "StartReportModel.h"
#import "ShiftReportModel.h"
#import "BartenderCommentTVC.h"
#import "BartenderCommentTHVC.h"
#import "BartenderCommentSendVC.h"

@interface BarInventoryCommentVC () {
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIView *navigationTopView;
@property (weak, nonatomic) IBOutlet UILabel *inventoryTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *makeCommentButton;
@property (weak, nonatomic) IBOutlet UILabel *userRealNameLabel;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *editItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editItemImageView;
@property (weak, nonatomic) IBOutlet UITextField *weightOpenBottleTextField;
@property (weak, nonatomic) IBOutlet UILabel *weightOpenBottleLabel;
@property (weak, nonatomic) IBOutlet UITextField *countFullBottlesTextField;



@property (assign, nonatomic) NSInteger select;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *controller;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *invtType;
@property (strong, nonatomic) NSString *totalCash;
@property (strong, nonatomic) NSMutableArray *inventoriedItems;
@property (strong, nonatomic) NSMutableArray *inventoryReportArray;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString *previousItemPrice;



@end

@implementation BarInventoryCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
        
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self.deviceType isEqualToString:@"iPad"]) {
        self.weightOpenBottleTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
        self.countFullBottlesTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    }
    
    self.totalCash = appDelegate.totalCash;

    self.inventoriedItems = [[NSMutableArray alloc] init];
    self.inventoryReportArray = [[NSMutableArray alloc] init];
    self.inventoryReportArray = appDelegate.bartInventoryArray;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    
    
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    self.invtType = appDelegate.inventoryType;
    self.navigationTopView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:128.0/255.0 blue:74.0/255.0 alpha:1.0];
    self.inventoriedItems = appDelegate.shiftReport;
    self.inventoryTypeLabel.text = @"";
    
    
    [self.editView setHidden:YES];
    [self.editButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    
    self.userRealNameLabel.text = [LoginVC getLoggedinUser].name;
    
    [[IQKeyboardManager sharedManager] setEnable:false];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:true];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void) viewDidLayoutSubviews{
    
    self.countFullBottlesTextField.layer.borderWidth = 3.0;
    self.countFullBottlesTextField.layer.borderColor = UIColor.blackColor.CGColor;
    self.countFullBottlesTextField.layer.cornerRadius = 3.0;
    self.weightOpenBottleTextField.layer.borderWidth = 3.0;
    self.weightOpenBottleTextField.layer.borderColor = UIColor.blackColor.CGColor;
    self.weightOpenBottleTextField.layer.cornerRadius = 3.0;
    
}

- (IBAction)gestureAction:(id)sender {
    
    [self.weightOpenBottleTextField resignFirstResponder];
    [self.countFullBottlesTextField resignFirstResponder];
    
}

#pragma mark - Button Action Method

- (IBAction)makeACommentAction:(id)sender {
    // To comment page
    
    appDelegate.totalCash = self.totalCash;
    
    BartenderCommentSendVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BartenderCommentSendVC"];
    [svc setModalPresentationStyle:UIModalPresentationFullScreen];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];
    
}

- (IBAction)onEditAction:(id)sender {
    // edit action of each item
    [self.editView setHidden:YES];
    [self.editButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Modifying...";
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    NSString *itemName = @"";
    NSString *priceStr = @"";
    
    // updated value
    NSString *weightOpenBottle = self.weightOpenBottleTextField.text;
    NSString *countFullBottles = self.countFullBottlesTextField.text;
    
    // Reported items detail info
    
    InventoryReport *inventoryModel = nil;
    inventoryModel = (InventoryReport *)self.inventoryReportArray[self.selectedRow];
    
    
    ShiftReportModel *shiftReportModel;
    shiftReportModel = (ShiftReportModel*) self.inventoriedItems[self.selectedRow];
    NSInteger missingParInt =  self.countFullBottlesTextField.text.integerValue - inventoryModel.par.integerValue;
    NSString *missingPar = [NSString stringWithFormat:@"%ld", (long)missingParInt];
    priceStr = [[self calcuateSelctedItemValue:inventoryModel withCountFullBottle:self.countFullBottlesTextField.text withWeightOpenBottle:self.weightOpenBottleTextField.text] objectAtIndex:0];
    NSString *servingSold = [[self calcuateSelctedItemValue:inventoryModel withCountFullBottle:self.countFullBottlesTextField.text withWeightOpenBottle:self.weightOpenBottleTextField.text] objectAtIndex:1];
    
    
    
    shiftReportModel.itemOpen = weightOpenBottle;
    shiftReportModel.itemFull = countFullBottles;
    shiftReportModel.missingToPar = missingPar;
    shiftReportModel.servingSold = servingSold;
    shiftReportModel.cashDetail = priceStr;
    itemName = shiftReportModel.itemName;
    
    // update total cash
    NSInteger updatedTotalCash = self.totalCash.integerValue - self.previousItemPrice.integerValue + priceStr.integerValue;
    NSString *updatedTotalCashStr = [NSString stringWithFormat:@"%ld", (long)updatedTotalCash];
    self.totalCash = updatedTotalCashStr;
    
    
    [self.inventoriedItems replaceObjectAtIndex:self.selectedRow withObject:shiftReportModel];
    [appDelegate.shiftReport replaceObjectAtIndex:self.selectedRow withObject:shiftReportModel];
    
    // edit table
    [self.tableView reloadData];
    [self serverUpdate:itemName withPrice:priceStr withHud:hud];
    
}

- (IBAction)onCancelAction:(id)sender {
    
    [self.editView setHidden:YES];
    [self.editButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    
}


#pragma mark - Server Update


-(void) serverUpdate:(NSString *)itemName withPrice:(NSString*)price withHud:(MBProgressHUD*)hud {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *locationController = [userDefaults objectForKey:CONTROLLER];
    
    
    NSString *weightOpenBottle = self.weightOpenBottleTextField.text;
    NSString *countFullBottles = self.countFullBottlesTextField.text;
    
    
    // send the modified data to server
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", locationController, @"/editInventory"];
        

        
        [ojoClient editInventory:url
                     andItemName:itemName
                    andOpenBtWet:weightOpenBottle
                       andAmount:countFullBottles
                        andPrice:price
                  andFinishBlock:^(NSArray *data) {
                      
                      NSDictionary *dicData = (NSDictionary *)data;
                      NSString *stateCode = [dicData objectForKey:STATE];
                      if ([stateCode isEqualToString:@"200"])
                      {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [hud hide:YES];
                              [self.view makeToast:[dicData objectForKey:@"Edited Successfully"] duration:1.5 position:CSToastPositionCenter];
                              
                          });
                      } else{
                          
                          [hud hide:YES];
                          [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                          
                      }
                  }
                    andFailBlock:^(NSError *error) {
                        [hud hide:YES];
                        [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                    }];
    });
}


#pragma mark - Price/ServingSold Calculation Method of selcted items


- (NSArray *) calcuateSelctedItemValue:(InventoryReport*)inventoryModel withCountFullBottle:(NSString*)countFullBottle withWeightOpenBottle:(NSString*)weightOpenBottle{
    
    float C2 = inventoryModel.amount.floatValue; // before count full bottle
    float C1 = countFullBottle.floatValue; // now count full bottle
    float T = inventoryModel.itemLiqWet.floatValue;   // real liquid weight
    float A2 = inventoryModel.openBottleWet.floatValue; // before open bottle weight
    float A1 = weightOpenBottle.floatValue; // now open bottle weight
    // NSInteger E = inventoryModel.itemBottleEmpWet.integerValue; // empty bottle weight
    float W = inventoryModel.itemServWet.floatValue;  // weight of one serving (one cup weight)
    float M = inventoryModel.itemPrice.floatValue;    // price of one serving (oen cup price)
    
    
    NSInteger price = 0;
    float servingSoldFloat = 0.0f;
    if (inventoryModel.fullOpen == 0) {
        // full   (C2 – C1) × M
        price = (inventoryModel.amount.integerValue - countFullBottle.integerValue) * inventoryModel.itemPrice.integerValue;
        servingSoldFloat = C2 - C1;
        
    } else{
        // FULL&OPEN ITEM   ([(C2 × T)+(A2-E)]-[(C1 × T)+(A1-E)])/W  × M
        price = (NSInteger)(((T * (C2-C1) + (A2-A1)) * M) / W);
        servingSoldFloat = ((T * (C2 - C1) + (A2 - A1))/ W);
    }
    if (price < 0) price = 0;
    if (servingSoldFloat < 0) servingSoldFloat = 0;
    
    NSString *priceStr = [NSString stringWithFormat:@"%ld", (long)price];
    NSString *servingSold = [NSString stringWithFormat:@"%.02f", servingSoldFloat];
    
    NSArray *valueArray = [NSArray arrayWithObjects:priceStr, servingSold, nil];
    
    return valueArray;
    
}




#pragma mark - UITableViewDelegate Method



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.inventoriedItems.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 120.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BartenderCommentTHVC *headerCell = [tableView dequeueReusableCellWithIdentifier:@"inventoriedItemCellHeader"];
    
    headerCell.locationLabel.text = self.location;
    return headerCell;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"inventoriedItemCell";
    BartenderCommentTVC *inventoriedCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    inventoriedCell.cellView.layer.borderWidth = 2.0;
    inventoriedCell.cellView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    ShiftReportModel *shiftReportModel;
    shiftReportModel = (ShiftReportModel*) self.inventoriedItems[indexPath.row];
 
    if (shiftReportModel.liquidWeight.intValue != 0) {
        
    }
    
    inventoriedCell.itemTitle.text = shiftReportModel.itemName;
    inventoriedCell.weightOpenBottle.text = [NSString stringWithFormat:@"OPEN : %@", shiftReportModel.itemOpen];
    inventoriedCell.countFullBottle.text = [NSString stringWithFormat:@"FULL : %@",  shiftReportModel.itemFull];
    
    
    
    inventoriedCell.backgroundColor = inventoriedCell.contentView.backgroundColor;
    return inventoriedCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.editView setHidden:NO];
    [self.editButton setHidden:NO];
    [self.cancelButton setHidden:NO];
    self.selectedRow = indexPath.row;
    

    
    ShiftReportModel *shiftReportModel;
        shiftReportModel = (ShiftReportModel*) self.inventoriedItems[self.selectedRow];
        NSString *itemName = shiftReportModel.itemName;
        NSString *weightOpenBottle = shiftReportModel.itemOpen;
        NSString *countFullBottle = shiftReportModel.itemFull;
        
        
        self.editItemLabel.text = itemName;
        
        NSString *imageNameWithUpper = [itemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *imageName = [imageNameWithUpper lowercaseString];
        self.editItemImageView.image = [UIImage imageNamed:imageName];
        if (self.editItemImageView.image == nil) {
            self.editItemImageView.image = [UIImage imageNamed:@"coming_soon"];
            
    }
    
    self.weightOpenBottleTextField.text = weightOpenBottle;
    self.countFullBottlesTextField.text = countFullBottle;
    
    if ([weightOpenBottle isEqualToString:@""]) {
        [self.weightOpenBottleLabel setHidden:YES];
        [self.weightOpenBottleTextField setHidden:YES];
    } else {
        [self.weightOpenBottleLabel setHidden:NO];
        [self.weightOpenBottleTextField setHidden:NO];
    }
    

    // set the previous item price

     InventoryReport *inventoryModel = nil;
     inventoryModel = (InventoryReport *)self.inventoryReportArray[indexPath.row];
     
    self.previousItemPrice = [[self calcuateSelctedItemValue:inventoryModel withCountFullBottle:countFullBottle withWeightOpenBottle:weightOpenBottle] objectAtIndex:0];
    
    NSLog("Previous Item Price ======= %@", self.previousItemPrice);
}


#pragma mark - UITextField Delegate Method

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
