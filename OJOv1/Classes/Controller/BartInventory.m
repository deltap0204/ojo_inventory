//
//  BartInventory.m
//  OJOv1
//
//  Created by MilosHavel on 06/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "BartInventory.h"
#import "BartenderVC.h"
#import "LDProgressView.h"
#import "Inventory.h"
#import "InventoryReport.h"
#import "Item.h"
#import "StartReportModel.h"
#import "ShiftReportModel.h"
#import "Confirm.h"
#import "BarInventoryCommentVC.h"
#import "LoginVC.h"


@interface BartInventory (){
    AppDelegate *appDelegate;

}

@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullWeightLabel;
@property (weak, nonatomic) IBOutlet UITextField *openBtWetTextField;
@property (weak, nonatomic) IBOutlet UITextField *fullBtCountTextField;
@property (weak, nonatomic) IBOutlet UILabel *openBuWetLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullBtCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIButton *nextItemButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *userRealNameLabel;

@property (assign, nonatomic) NSInteger select;
@property (strong, nonatomic) NSString *locationController;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *inventoryReportArray;
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) NSInteger currentNum;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *currentFullWeightOfItem;
@property (strong, nonatomic) NSString *currentEmptyWeightOfItem;
@property (assign, nonatomic) BOOL minValueCheck;
@property (assign, nonatomic) NSInteger totalCash;


@end

@implementation BartInventory


/*   Wireframe for inventoring
 *
 *   [Get All Items] ------> [Set UI (First Page)] --------> [Click 'GO TO NEXT ITEM'] --------> [Send Inventory] (Save Database)------> [BarInventoryCommentVC]
 *                                 |                                                                                                   |
 *                                  ---------------------------------------------------------------------------------------------------
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.inventoryList = [[NSMutableArray alloc] init];
    self.inventoryReportArray = [[NSMutableArray alloc] init];
    
    // initialize total cash value

    self.totalCash = 0;
    
    self.openBtWetTextField.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.locationController = [userDefaults objectForKey:CONTROLLER];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    [self.nextItemButton setEnabled:NO];
    
    // replace to customized keyboard
    
    if ([self.deviceType isEqualToString:@"iPad"]) {
        self.openBtWetTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
        self.fullBtCountTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    }
    
    NSString *inventoryType = appDelegate.inventoryType;
    if ([inventoryType isEqualToString:@"start"]) {
        self.navigationView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:128.0/255.0 blue:74.0/255.0 alpha:1.0];
        self.titleLabel.text = @"START";
    } else if ([inventoryType isEqualToString:@"shift"]) {
        self.navigationView.backgroundColor = [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0];
        self.titleLabel.text = @"SHIFT";
    } else {
        self.navigationView.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:51.0/255.0 blue:30.0/255.0 alpha:1.0];
        self.titleLabel.text = @"END";
    }
    
    self.userRealNameLabel.text = [LoginVC getLoggedinUser].name;
    self.locationTitle.text = self.location;
    self.currentNum = 0;
    self.minValueCheck = NO;
    
    appDelegate.startTime = [self getCurrentTimeString];
    [self getAllItems];
}

- (NSString*) getCurrentTimeString{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *inputTimeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"hh:mm";
    dateFormatter.timeZone = inputTimeZone;
    
    return [dateFormatter stringFromDate:now];
}

- (void) viewDidLayoutSubviews{
    
    self.openBtWetTextField.layer.cornerRadius = 5.0;
    self.openBtWetTextField.layer.borderWidth = 3.0;
    self.openBtWetTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.fullBtCountTextField.layer.cornerRadius = 5.0;
    self.fullBtCountTextField.layer.borderWidth = 3.0;
    self.fullBtCountTextField.layer.borderColor = [UIColor blackColor].CGColor;

}

- (void) getAllItems{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"LOADING...";
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/getAllInventory"];
        
        [ojoClicent getInventoryAllItemOfBar:url
                              andFinishBlock:^(NSArray *data) {
                                  
                                  NSDictionary *dicData = (NSDictionary *)data;
                                  NSString *stateCode = [dicData objectForKey:STATE];
                                  
                                  if ([stateCode isEqualToString:@"201"]) {
                                      // Empty inventory
                                      
                                      UIAlertController *alert = [UIAlertController
                                                                  alertControllerWithTitle:@"This location has no items!"
                                                                  message:@""
                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                      UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                                                         style:UIAlertActionStyleCancel
                                                                                       handler:^(UIAlertAction *action) {
                                                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                                                           
                                                                                       }];
                                      [alert addAction:okAction];
                                      [self presentViewController:alert animated:YES completion:nil];
                                      
                                      return;
                                      
                                  } else if ([stateCode isEqualToString:@"200"]) {
                                      
                                      NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                                      NSInteger count = response.count;

                                      self.totalCount = count;
                                      
                                      [self.inventoryList removeAllObjects];
                                      
                                      InventoryReport *inventoryModel = nil;
                                      
                                      
                                      for (int i = 0; i < count; i++)
                                      {
                                          
                                          NSDictionary *inventoryDic = (NSDictionary *) response[i];
                                          NSString *itemName = [inventoryDic objectForKey:INVENTORY_ITEM_NAME];
                                          NSInteger frequency = [[inventoryDic objectForKey:INVENTORY_FRUQUENCY] integerValue];
                                          NSInteger fullOpen = [[inventoryDic objectForKey:INVENTORY_FULL_OPEN] integerValue];
                                          NSString *openBtWet = [inventoryDic objectForKey:INVENTORY_OPEN_BOTTLE_WET];
                                          NSString *amount = [inventoryDic objectForKey:INVENTORY_AMOUNT];
                                          NSString *par = [inventoryDic objectForKey:INVENTORY_PAR];
                                          NSString *itemBottleFullWet = [inventoryDic objectForKey:INVENTORY_BT_FULL_WET];
                                          NSString *itemBottleEmpWet = [inventoryDic objectForKey:INVENTORY_BT_EMP_WET];
                                          NSString *itemLiqWet = [inventoryDic objectForKey:INVENTORY_LIQ_WET];
                                          NSString *itemServBt = [inventoryDic objectForKey:INVENTORY_SERV_BT];
                                          NSString *itemServWet = [inventoryDic objectForKey:INVENTORY_SERV_WET];
                                          NSString *itemPrice = [inventoryDic objectForKey:INVENTORY_ITEM_PRICE];
                                          
                                          
                                          inventoryModel = [[InventoryReport alloc] initWithItemName:itemName
                                                                                    andWithFrequency:frequency
                                                                                     andWithFullOpen:fullOpen
                                                                                andWithOpenBottleWet:openBtWet
                                                                                       andWithAmount:amount
                                                                                          andWithPar:par
                                                                            andWithNewsOpenBottleWet:@""
                                                                                   andWithNewsAmount:@""
                                                                            andWithItemBottleFullWet:itemBottleFullWet
                                                                             andWithItemBottleEmpWet:itemBottleEmpWet
                                                                                   andWithItemLiqWet:itemLiqWet
                                                                                   andWithItemServBt:itemServBt
                                                                                  andWithItemServWet:itemServWet
                                                                                    andWithItemPrice:itemPrice
                                                                                   andWithCashDetail:@""];

                                          [self.inventoryList addObject:inventoryModel];
                                      }
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [hud hide:YES];
                                          [self setCurrentUIChange];
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
                                  [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                              }];
    });
    
}


- (void) sortByRanking {
    
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
    
}

- (void) setCurrentUIChange{

    if (self.currentNum == self.totalCount) {
        
        // get the time
        
        appDelegate.endTime = [self getCurrentTimeString];
        appDelegate.totalCash = [NSString stringWithFormat:@"%ld", (long)self.totalCash];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        });
        
        BarInventoryCommentVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BarInventoryCommentVC"];
        [self presentViewController:svc animated:YES completion:nil];
        
    } else{

        if (self.currentNum != 0) {
            [self animatPage:UISwipeGestureRecognizerDirectionLeft];
        }
        
        InventoryReport *inventoryModel = nil;
        inventoryModel = (InventoryReport *)self.inventoryList[self.currentNum];
        self.itemNameLabel.text = inventoryModel.itemName;
        
        // image set
        
        NSString *imageNameWithUpper = [inventoryModel.itemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *imageName = [imageNameWithUpper lowercaseString];
        self.itemImageView.image = [UIImage imageNamed:imageName];
        
        
        if (self.itemImageView.image == nil) {
            self.itemImageView.image = [UIImage imageNamed:@"coming_soon"];
        }
        
        
        self.progressLabel.text = [NSString stringWithFormat:@"%ld%@%ld",(long)(self.currentNum +1), @" OF ", (long)self.totalCount];
        
        
        NSInteger fullOpen = inventoryModel.fullOpen;
        
        // if it's full open item, it's impossible to edit openBtWetTextField
        if (fullOpen == 0) {
            
            [self.openBuWetLabel setHidden:YES];
            [self.openBtWetTextField setHidden:YES];
            
            [self.emptyWeightLabel setHidden:YES];
            [self.fullWeightLabel setHidden:YES];
            
            self.openBtWetTextField.text = @"0";
            self.minValueCheck = YES;
            [self.nextItemButton setEnabled:YES];
            
        } else {
            

            [self.openBuWetLabel setHidden:NO];
            [self.openBtWetTextField setHidden:NO];
            
            [self.emptyWeightLabel setHidden:NO];
            [self.fullWeightLabel setHidden:NO];
            
            NSString *emptyFullBottleWeight = inventoryModel.itemBottleEmpWet;
            NSString *fullWeight = inventoryModel.itemBottleFullWet;
            
            self.emptyWeightLabel.text = [NSString stringWithFormat:@"EMPTY : %@", emptyFullBottleWeight];
            self.fullWeightLabel.text = [NSString stringWithFormat:@"FULL : %@", fullWeight];
            self.openBtWetTextField.text = @"";
            [self.nextItemButton setEnabled:NO];
            
        }
        
        self.currentFullWeightOfItem = inventoryModel.itemBottleFullWet;
        self.currentEmptyWeightOfItem = inventoryModel.itemBottleEmpWet;
        
        
    }
}


#pragma mark - input value check

- (IBAction)inputVallueOfWeightOpenBottle:(UITextField *)sender {
        NSString *weightStr = sender.text;
    
        if (![weightStr isEqualToString:@""]) {
            NSInteger weight = [weightStr integerValue];
            NSInteger fullWeight = [self.currentFullWeightOfItem integerValue];
            NSInteger emptyWeight = [self.currentEmptyWeightOfItem integerValue];
            if (weight > fullWeight) {
//                self.openBtWetTextField.layer.borderWidth = 2.0f;
//                self.openBtWetTextField.layer.borderColor = [[UIColor redColor] CGColor];
                [self.openBtWetTextField setEnabled:NO];
                
            }
            else if (weight < emptyWeight) {
                self.openBtWetTextField.layer.borderWidth = 2.0f;
                self.openBtWetTextField.layer.borderColor = [[UIColor blueColor] CGColor];
            } else{
                self.openBtWetTextField.layer.borderColor = [[UIColor clearColor] CGColor];
            }
        } else{
            self.openBtWetTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    
    NSString *currentTextFeild = textField.text;
    NSString *inputStr = string;
    
    NSString *currentStr = [NSString stringWithFormat:@"%@%@", currentTextFeild, inputStr];
    if ([inputStr isEqualToString:@""]) {
        currentStr = [currentStr substringToIndex:[currentStr length] - 1];
    }
    NSInteger weight = [currentStr integerValue];
    
    NSInteger fullWeight = [self.currentFullWeightOfItem integerValue];
    NSInteger emptyWeight = [self.currentEmptyWeightOfItem integerValue];
    
    if (weight < emptyWeight) {
        self.openBtWetTextField.layer.borderWidth = 4.0f;
        self.openBtWetTextField.layer.borderColor = [[UIColor redColor] CGColor];
        self.minValueCheck = NO;
        [self.nextItemButton setEnabled:NO];

    }else if(weight > emptyWeight & weight < fullWeight)
    {
        self.openBtWetTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        self.minValueCheck = YES;
        [self.nextItemButton setEnabled:YES];
        
        
    } else{
        
        
        
    }

    
    if (weight < fullWeight) return YES;
    else return NO;
    
}


- (IBAction)onNextArticle:(id)sender {
    NSString *wetOpenBottle = self.openBtWetTextField.text;
    NSString *fullBottleCount = self.fullBtCountTextField.text;
    
    if ([wetOpenBottle isEqualToString:@""]) {
        
        [self.view makeToast:@"INSERT WEIGHT OPEN BOTTLE" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([fullBottleCount isEqualToString:@""]) {
        [self.view makeToast:@"INSERT COUNT FULL BOTTLES" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if (self.currentNum == 0) {
        // get the time
        
    }
    
    [self sendInventory];
}

#pragma mark - server connection method

- (void) sendInventory{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Sending...";
    hud.userInteractionEnabled = NO;
    
    [hud show:YES];
    InventoryReport *inventoryModel = nil;
    inventoryModel = (InventoryReport *)self.inventoryList[self.currentNum];
    NSInteger fullOpen = inventoryModel.fullOpen;
    NSString *priceStr = @"0";
    NSMutableArray *moveAllowArray = appDelegate.allowedArray;
    
    NSString *inventoryType = appDelegate.inventoryType;
    InventoryReport *inventoryCheckReport = nil;
    
    
    
    /*
     |_________________|
     | START INVENTORY |
     |_________________|
     */
    
    
    
    if ([inventoryType isEqualToString:@"start"]) {

        inventoryCheckReport = [[InventoryReport alloc] initWithItemName:inventoryModel.itemName
                                                        andWithFrequency:inventoryModel.frequency
                                                         andWithFullOpen:inventoryModel.fullOpen
                                                    andWithOpenBottleWet:inventoryModel.openBottleWet
                                                           andWithAmount:inventoryModel.amount
                                                              andWithPar:inventoryModel.par
                                                andWithNewsOpenBottleWet:self.openBtWetTextField.text
                                                       andWithNewsAmount:self.fullBtCountTextField.text
                                                andWithItemBottleFullWet:inventoryModel.itemBottleFullWet
                                                 andWithItemBottleEmpWet:inventoryModel.itemBottleEmpWet
                                                       andWithItemLiqWet:inventoryModel.itemLiqWet
                                                       andWithItemServBt:inventoryModel.itemServBt
                                                      andWithItemServWet:inventoryModel.itemServWet
                                                        andWithItemPrice:inventoryModel.itemPrice
                                                       andWithCashDetail:priceStr];
        
        [self.inventoryReportArray addObject:inventoryCheckReport];
        
        NSString *movingAmount = @"";
        NSString *movingOrigin = @"";
        NSString *movingTime = @"";
        
        NSInteger missingParInt =  self.fullBtCountTextField.text.integerValue - inventoryModel.par.integerValue;
        NSString *missingPar = [NSString stringWithFormat:@"%ld", (long)missingParInt];
        NSInteger checkAmountInt = self.fullBtCountTextField.text.integerValue - inventoryModel.amount.integerValue;
        NSString *itemFullCheck = [NSString stringWithFormat:@"%ld", (long)checkAmountInt];
        NSInteger checkOpenItemInt = self.openBtWetTextField.text.integerValue - inventoryModel.openBottleWet.integerValue;
        NSString *itemOpenCheck = [NSString stringWithFormat:@"%ld", (long)checkOpenItemInt];
        
        StartReportModel *startReport = nil;
        int j = 0;
        BOOL edited = false;
        
        // If there are some moved items....
        if (moveAllowArray.count != 0) {
            edited = true;
            
            // Find this item among moved items
            for (int i = 0; i < moveAllowArray.count ; i++) {
                
                edited = true;
                Confirm *moveAllowModel = (Confirm *)moveAllowArray[i];
                
                // If find...
                if ([moveAllowModel.moveItemName isEqualToString:inventoryModel.itemName]) {
                    movingAmount = moveAllowModel.moveAmount;
                    movingOrigin = moveAllowModel.senderLocation;
                    movingTime = moveAllowModel.acceptTime;
                    NSString *fullItem = self.fullBtCountTextField.text;
                    NSString *openWet = self.openBtWetTextField.text;
                    NSString *mpTempValue = missingPar;
                    NSString *iFCTempValue = itemFullCheck;
                    NSString *iOCTempValue = itemOpenCheck;

                    if (j != 0) {
                        fullItem = @"";
                        openWet = @"";
                        missingPar= @"";
                        mpTempValue = @"";
                        iFCTempValue = @"";
                        iOCTempValue = @"";
                        
                    }
                    
                    j++;
                    
                    startReport = [[StartReportModel alloc] initWithItemName:inventoryModel.itemName
                                                         andWithMovingAmount:movingAmount
                                                         andWithMovingOrigin:movingOrigin
                                                           andWithMovingTime:movingTime
                                                             andWithItemFull:fullItem
                                                             andWithItemOpen:openWet
                                                         andWithMissingToPar:mpTempValue
                                                        andWithItemFullCheck:iFCTempValue
                                                        andWithItemOpenCheck:iOCTempValue];
                    [appDelegate.startReport addObject:startReport];
                    
                    break;
                    
                }
                
                // if not find
                else{
                    edited = false;
                }
            }
        }
        
        // It there are not any moved items....
        if (!edited) {
            startReport = [[StartReportModel alloc] initWithItemName:inventoryModel.itemName
                                                 andWithMovingAmount:movingAmount
                                                 andWithMovingOrigin:movingOrigin
                                                   andWithMovingTime:movingTime
                                                     andWithItemFull:self.fullBtCountTextField.text
                                                     andWithItemOpen:self.openBtWetTextField.text
                                                 andWithMissingToPar:missingPar
                                                andWithItemFullCheck:itemFullCheck
                                                andWithItemOpenCheck:itemOpenCheck];
            
            [appDelegate.startReport addObject:startReport];
        }
    }
    
    
    
    
    /*
     |_______________________|
     | SHIFT & END INVENTORY |
     |_______________________|
     */
    
    
    if ([inventoryType isEqualToString:@"shift"] || [inventoryType isEqualToString:@"end"]){
        // sales report
        float C2 = inventoryModel.amount.floatValue; // before count full bottle
        float C1 = self.fullBtCountTextField.text.floatValue; // now count full bottle
        float T = inventoryModel.itemLiqWet.floatValue;   // real liquid weight
        float A2 = inventoryModel.openBottleWet.floatValue; // before open bottle weight
        float A1 = self.openBtWetTextField.text.floatValue; // now open bottle weight
        // NSInteger E = inventoryModel.itemBottleEmpWet.integerValue; // empty bottle weight
        float W = inventoryModel.itemServWet.floatValue;  // weight of one serving (one cup weight)
        float M = inventoryModel.itemPrice.floatValue;    // price of one serving (oen cup price)
        
        NSInteger price = 0;
        float servingSoldFloat = 0.0f;
        if (fullOpen == 0) {
            // full   (C2 – C1) × M
            price = (inventoryModel.amount.integerValue - self.fullBtCountTextField.text.integerValue) * inventoryModel.itemPrice.integerValue;
            servingSoldFloat = C2 - C1;
            
        } else{
            // FULL&OPEN ITEM   ([(C2 × T)+(A2-E)]-[(C1 × T)+(A1-E)])/W  ×M
            price = (NSInteger)(((T * (C2-C1) + (A2-A1)) * M) / W);
            servingSoldFloat = ((T * (C2 - C1) + (A2 - A1))/ W);
        }
        if (price < 0) price = 0;
        if (servingSoldFloat < 0) servingSoldFloat = 0;
        
        self.totalCash = self.totalCash + price;
        priceStr = [NSString stringWithFormat:@"%ld", (long)price];
        NSString *servingSold = [NSString stringWithFormat:@"%.02f", servingSoldFloat];
        inventoryCheckReport = [[InventoryReport alloc] initWithItemName:inventoryModel.itemName
                                                       andWithFrequency:inventoryModel.frequency
                                                        andWithFullOpen:inventoryModel.fullOpen
                                                   andWithOpenBottleWet:inventoryModel.openBottleWet
                                                          andWithAmount:inventoryModel.amount
                                                             andWithPar:inventoryModel.par
                                               andWithNewsOpenBottleWet:self.openBtWetTextField.text
                                                      andWithNewsAmount:self.fullBtCountTextField.text
                                               andWithItemBottleFullWet:inventoryModel.itemBottleFullWet
                                                andWithItemBottleEmpWet:inventoryModel.itemBottleEmpWet
                                                      andWithItemLiqWet:inventoryModel.itemLiqWet
                                                      andWithItemServBt:inventoryModel.itemServBt
                                                     andWithItemServWet:inventoryModel.itemServWet
                                                       andWithItemPrice:inventoryModel.itemPrice
                                                      andWithCashDetail:priceStr];
    
        [self.inventoryReportArray addObject:inventoryCheckReport];
        
        NSString *movingAmount = @"";
        NSString *movingOrigin = @"";
        NSString *movingTime = @"";
        NSInteger missingParInt =  self.fullBtCountTextField.text.integerValue - inventoryModel.par.integerValue;
        NSString *missingPar = [NSString stringWithFormat:@"%ld", (long)missingParInt];
        
        int j = 0;
        BOOL edited = false;
        
        if (moveAllowArray.count != 0) {
            edited = true;
            
            for (int i = 0; i < moveAllowArray.count ; i++) {
                
                edited = true;
                Confirm *moveAllowModel = (Confirm *)moveAllowArray[i];
                if ([moveAllowModel.moveItemName isEqualToString:inventoryModel.itemName]) {
                    movingAmount = moveAllowModel.moveAmount;
                    movingOrigin = moveAllowModel.senderLocation;
                    movingTime = moveAllowModel.acceptTime;
                    NSString *fullItem = self.fullBtCountTextField.text;
                    NSString *openWet = self.openBtWetTextField.text;
                    NSString *mpTempValue = missingPar;
                    NSString *ssTempValue = servingSold;
                    NSString *psTempValue = priceStr;
                    
                    if (j != 0) {
                        fullItem = @"";
                        openWet = @"";
                        mpTempValue = @"";
                        ssTempValue = @"";
                        psTempValue = @"";
                    }
                    j++;
                    
                    
                    ShiftReportModel *shiftReport = [[ShiftReportModel alloc] initWithItemName:inventoryModel.itemName
                                                                           andWithMovingAmount:movingAmount
                                                                           andWithMovingOrigin:movingOrigin
                                                                             andWithMovingTime:movingTime
                                                                               andWithItemFull:fullItem
                                                                               andWithItemOpen:openWet
                                                                           andWithMissingToPar:mpTempValue
                                                                            andWithServingSold:ssTempValue
                                                                           andWithLiquidWeight:inventoryModel.itemLiqWet
                                                                              andWithItemPrice:inventoryModel.itemPrice
                                                                             andWithCashDetail:psTempValue];
                    
                    [appDelegate.shiftReport addObject:shiftReport];
                    
                    break;

                } else{
                    edited = false;
                }
            }
            
        }
        
        if(!edited){
            
            ShiftReportModel *shiftReport = [[ShiftReportModel alloc] initWithItemName:inventoryModel.itemName
                                                                   andWithMovingAmount:movingAmount
                                                                   andWithMovingOrigin:movingOrigin
                                                                     andWithMovingTime:movingTime
                                                                       andWithItemFull:self.fullBtCountTextField.text
                                                                       andWithItemOpen:self.openBtWetTextField.text
                                                                   andWithMissingToPar:missingPar
                                                                    andWithServingSold:servingSold
                                                                   andWithLiquidWeight:inventoryModel.itemLiqWet
                                                                      andWithItemPrice:inventoryModel.itemPrice
                                                                     andWithCashDetail:priceStr];
            [appDelegate.shiftReport addObject:shiftReport];
        
        }
    }
    
    appDelegate.bartInventoryArray = self.inventoryReportArray;
    NSString *itemName = self.itemNameLabel.text;
    NSString *openBtWetText = self.openBtWetTextField.text;
    NSString *fullBtCountText = self.fullBtCountTextField.text;
    
    
    /*
     *  SAVE IN DATABASE
     */
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.locationController, @"/editInventory"];
        [ojoClient editInventory:url
                     andItemName:itemName
                    andOpenBtWet:openBtWetText
                       andAmount:fullBtCountText
                        andPrice:priceStr
                  andFinishBlock:^(NSArray *data) {
                      NSDictionary *dicData = (NSDictionary *)data;
                      NSString *stateCode = [dicData objectForKey:STATE];
                      if ([stateCode isEqualToString:@"200"])
                      {
                          [hud hide:YES];
                          self.currentNum ++;
                          [self setCurrentUIChange];
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

- (IBAction)onBack:(id)sender {
    appDelegate.endTime = [self getCurrentTimeString];
    appDelegate.totalCash = [NSString stringWithFormat:@"%ld", (long)self.totalCash];
    
    BarInventoryCommentVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BarInventoryCommentVC"];
    [self presentViewController:svc animated:YES completion:nil];
    
}



#pragma  mark - textView animation method
- (void) animatPage:(UISwipeGestureRecognizerDirection)direction {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view] cache:YES];
    }
    else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view] cache:YES];
        
    }
    [UIView commitAnimations];
    
    self.openBtWetTextField.text = @"";
    self.fullBtCountTextField.text = @"";
    
}

- (IBAction)tabGestureAction:(id)sender {
    [self.openBtWetTextField resignFirstResponder];
    [self.fullBtCountTextField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
