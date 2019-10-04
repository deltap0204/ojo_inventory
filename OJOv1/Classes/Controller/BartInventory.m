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


@interface BartInventory ()

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
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) NSInteger currentNum;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *currentFullWeightOfItem;
@property (strong, nonatomic) NSString *currentEmptyWeightOfItem;
@property (assign, nonatomic) NSInteger totalCash;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) BOOL movedItemCheck;
@property (assign, nonatomic) BOOL minValueCheck;

// movedIn_ID & movedOut_ID
@property (strong, nonatomic) NSString *movedInID;
@property (strong, nonatomic) NSString *movedOutID;

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
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.inventoryList = [[NSMutableArray alloc] init];
    
    // initialize total cash value and current number

    self.totalCash = 0;
    self.currentNum = 0;
    self.minValueCheck = false;
    self.movedItemCheck = false;
    
    
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
    
    self.titleLabel.text = @"";
    self.navigationView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:128.0/255.0 blue:74.0/255.0 alpha:1.0];
    
    
    self.userRealNameLabel.text = [LoginVC getLoggedinUser].name;
    self.locationTitle.text = self.location;
    
    self.appDelegate.startTime = [self getCurrentTimeString];
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
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"GETTING NEEDED DATA FROM SERVER...";
    self.hud.userInteractionEnabled = NO;
    [self.hud show:YES];
    
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
                                                                  message:@"Unfortunately you can't do inventory, please contact admin"
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
                                      
                                      [self getAllUnreportedItems];
                                      
                                  }
                                  
                                  else{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.hud hide:YES];
                                          NSString *response = [dicData objectForKey:MESSAGE];
                                          [self.view makeToast:response duration:1.5 position:CSToastPositionCenter];
                                          
                                      });
                                  }
                                  
                              } andFailBlock:^(NSError *error) {
                                  [self.hud hide:YES];
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
        
        self.appDelegate.endTime = [self getCurrentTimeString];
        self.appDelegate.totalCash = [NSString stringWithFormat:@"%ld", (long)self.totalCash];
        
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
            self.minValueCheck = true;
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


#pragma mark - input value check (입력부분 체크, 최소무게보다 작은경우 디저불상태로...)

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
        self.minValueCheck = false;
        [self.nextItemButton setEnabled:NO];

    }else if(weight > emptyWeight & weight < fullWeight)
    {
        self.openBtWetTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        self.minValueCheck = true;
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

#pragma mark - server connection method (리포트를 위한 한 개 아이템관련 계산과 써버통신부분)

- (void) sendInventory{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Sending...";
    self.hud.userInteractionEnabled = NO;
    
    [self.hud show:YES];
    
    InventoryReport *inventoryModel = nil;
    inventoryModel = (InventoryReport *)self.inventoryList[self.currentNum];
    
    
    NSInteger fullOpen = inventoryModel.fullOpen;
    NSString *priceStr = @"0";
    
    
    
    InventoryReport *inventoryCheckReport = nil;
    
    /*
     |______________________________|
     | INVENTORY (리포트를 위한 계산부분) |
     |______________________________|
     */
    
    

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
    
    [self.appDelegate.bartInventoryArray addObject:inventoryCheckReport];
    
    NSString *movingOrigin = @"";
    NSString *movingTarget = @"";
    NSString *movingTime = @"";
    
    NSInteger missingParInt =  self.fullBtCountTextField.text.integerValue - inventoryModel.par.integerValue;
    NSString *missingPar = [NSString stringWithFormat:@"%ld", (long)missingParInt];
    
    NSString *fullItem = self.fullBtCountTextField.text;
    NSString *openWet = self.openBtWetTextField.text;
    
    int j = 0;
    self.movedItemCheck = false;
    
    //
    self.movedInID = @"0";
    self.movedOutID = @"0";
    
    
    // 바에서 이동된 아이템이 1이상 있다.
    
    if (self.appDelegate.unreportedArray.count != 0) {
        
        for (int i = 0; i < self.appDelegate.unreportedArray.count ; i++) {
            
            Confirm *moveAllowModel = (Confirm *)self.appDelegate.unreportedArray[i];

            
            //--  MovedIn/MovedOut를 위한 다블체크 (한 아이템이 주거나 받은경우 2개의 옮김정보를 가진다.) 두번째 옮김인경우 전에 한번추가된상태이므로 현재 currenNum의 번호와 shiftReport의 개수가 같다
            BOOL doubleCheck;
            if (self.appDelegate.shiftReport.count == self.currentNum) doubleCheck = false;
            else doubleCheck = true;
            //--
            
            
            
            // 아이템이 옮겨진 경우
            
            if ([moveAllowModel.moveItemName isEqualToString:inventoryModel.itemName]) {
                

                NSString *movingAmount = moveAllowModel.moveAmount;
                movingOrigin = moveAllowModel.senderLocation;
                movingTarget = moveAllowModel.receiverLocation;
                movingTime = moveAllowModel.acceptTime;
                
                NSString *mpTempValue = missingPar;
                NSString *ssTempValue = servingSold;
                NSString *psTempValue = priceStr;
                
                NSString *movedIn = @"";
                NSString *movedOut = @"";
                
                
                
                /*
                
                if (j != 0) {
                    fullItem = @"";
                    openWet = @"";
                    mpTempValue = @"";
                    ssTempValue = @"";
                    psTempValue = @"";
                }
                
                j++;
                 
                */
                
                // 첫 옮김정보라면.. 추가
                if (!doubleCheck) {
                    
                    NSInteger preFull;
                    if ([movingOrigin isEqualToString:self.location]) {
                        preFull = inventoryCheckReport.amount.integerValue + movingAmount.integerValue;
                        movedOut = movingAmount;
                        self.movedOutID = moveAllowModel.moveID;
                    } else {
                        preFull = inventoryCheckReport.amount.integerValue - movingAmount.integerValue;
                        movedIn = movingAmount;
                        self.movedInID = moveAllowModel.moveID;
                    }
                    
                    ShiftReportModel *shiftReport = [[ShiftReportModel alloc] initWithItemName:inventoryModel.itemName
                                                                                andWithMovedIn:movedIn
                                                                               andWithMovedOut:movedOut
                                                                           andWithMovingOrigin:movingOrigin
                                                                             andWithMovingTime:movingTime
                                                                               andWithItemFull:fullItem
                                                                               andWithItemOpen:openWet
                                                                            andWithItemPreFull:[NSString stringWithFormat:@"%ld", (long)preFull]
                                                                            andWithItemPreOpen:openWet
                                                                           andWithMissingToPar:mpTempValue
                                                                            andWithServingSold:ssTempValue
                                                                           andWithLiquidWeight:inventoryModel.itemLiqWet
                                                                              andWithItemPrice:inventoryModel.itemPrice
                                                                             andWithCashDetail:psTempValue];
                    
                    [self.appDelegate.shiftReport addObject:shiftReport];
                    self.movedItemCheck = true;
                    
                }
                // 두번째 옮김정보라면.. 현재 shiftReport 에서 MovedIn/MovedOut 와 preFull 값 수정
                else{
                    
                    NSInteger shiftReportCount = self.appDelegate.shiftReport.count;
                    ShiftReportModel *shiftReport = self.appDelegate.shiftReport[shiftReportCount - 1];
                    
                    NSInteger preFull;
                    
                    if ([movingOrigin isEqualToString:self.location]) {
                        preFull = inventoryCheckReport.amount.integerValue + movingAmount.integerValue;
                        self.movedOutID = moveAllowModel.moveID;
                    } else {
                        preFull = inventoryCheckReport.amount.integerValue - movingAmount.integerValue;
                        self.movedInID = moveAllowModel.moveID;
                    }
                    
                    
                    
                    NSString *movedIn = shiftReport.movedIn;
                    NSString *movedOut = shiftReport.movedOut;
                    
                    if ([self.location isEqualToString:movingOrigin]) movedOut = movingAmount;
                    else movedIn = movingAmount;
                    
                    // shiftReport에서 3개의 값을 수정
                    shiftReport.movedIn = movedIn;
                    shiftReport.movedOut = movedOut;
                    shiftReport.itemPreFull = [NSString stringWithFormat:@"%ld", (long)preFull];
                    
                    [self.appDelegate.shiftReport replaceObjectAtIndex:shiftReportCount - 1 withObject:shiftReport];
                    self.movedItemCheck = true;
                }

            }
        }
    }
    
    
    // 바에서 받거나 보낸 아이템이 없거나, 있다하더라도 이 아이템에 대한 변화가 없는경우
    
    if (!self.movedItemCheck) {
        
        ShiftReportModel *shiftReport = [[ShiftReportModel alloc] initWithItemName:inventoryModel.itemName
                                                                    andWithMovedIn:@""
                                                                   andWithMovedOut:@""
                                                               andWithMovingOrigin:movingOrigin
                                                                 andWithMovingTime:movingTime
                                                                   andWithItemFull:fullItem
                                                                   andWithItemOpen:openWet
                                                                andWithItemPreFull:inventoryCheckReport.amount
                                                                andWithItemPreOpen:openWet
                                                               andWithMissingToPar:missingPar
                                                                andWithServingSold:servingSold
                                                               andWithLiquidWeight:inventoryModel.itemLiqWet
                                                                  andWithItemPrice:inventoryModel.itemPrice
                                                                 andWithCashDetail:priceStr];
        
        [self.appDelegate.shiftReport addObject:shiftReport];
    }
    
    NSString *itemName = self.itemNameLabel.text;
    NSString *openBtWetText = self.openBtWetTextField.text;
    NSString *fullBtCountText = self.fullBtCountTextField.text;
    
    
    /*-----------------------------------------------------------------------
     *  SAVE IN DATABASE (모든계산이 끝난후 현재 FULL/OPEN 상태를 자료기지에 보관한다.)   ||
     *---------------------------------------------------------------------*/
    

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
                          
                          // Moving 옮겨진 아이템이라면... 써버에서 sender_reported or receiver_reported 를 1로 업데이트한다
                          if (self.movedItemCheck) {
                              
                              [self updateMoveReported];
                          } else {
                              
                              [self.hud hide:YES];
                              self.currentNum ++;
                              [self setCurrentUIChange];
                              
                          }
                          
                      } else{
                          [self.hud hide:YES];
                          [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                          
                      }
                  }
                    andFailBlock:^(NSError *error) {
                        [self.hud hide:YES];
                        [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                        
                    }];
    });
    
}

- (IBAction)onBack:(id)sender {
    self.appDelegate.endTime = [self getCurrentTimeString];
    self.appDelegate.totalCash = [NSString stringWithFormat:@"%ld", (long)self.totalCash];
    
    BarInventoryCommentVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BarInventoryCommentVC"];
    [self presentViewController:svc animated:YES completion:nil];
    
}


#pragma mark - Getting unreported move items (Inventory 리포트에 반영되지않은 (reported = 0) 모든 옮김정보를 자료기지로부터 가져온다  )

- (void) getAllUnreportedItems {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
  
        [ojoClient searchUnreportedItems:SEARCH_UNREPORTED_ITEMS
                             andLocation:self.location
                          andFinishBlock:^(NSArray *data) {
                              
                                    NSDictionary *dicData = (NSDictionary *) data;
                                    NSString *stateCode = [dicData objectForKey:STATE];
                                    
                                    if ([stateCode isEqualToString:@"200"]) {
                                        
                                        NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                                        NSInteger count = response.count;
                                        
                                        Confirm *confirmModel = nil;
                                        
                                        for (int i = 0; i < count; i++) {
                                            NSDictionary *resultDict = (NSDictionary *)response[i];
                                            
                                            NSString *moveID = [resultDict objectForKey:MOVE_ID];
                                            NSString *itemName = [resultDict objectForKey:MOVE_ITEM_NAME];
                                            NSString *senderLocation = [resultDict objectForKey:SENDER_LOCATION];
                                            NSString *moveAmount = [resultDict objectForKey:MOVE_ITEM_AMOUNT];
                                            NSString *senderName = [resultDict objectForKey:NAME];
                                            NSString *movedDate = [resultDict objectForKey:DATE_STR];
                                            NSString *receiverLocation = [resultDict objectForKey:RECEIVER_LOCATION];
                                            
                                            confirmModel = [[Confirm alloc] initWithMoveID:moveID
                                                                       andWithMoveItemName:itemName
                                                                         andWithMoveAmount:moveAmount
                                                                     andWithSenderLocation:senderLocation
                                                                    andWithReceiveLocation:receiverLocation
                                                                         andWithSenderName:senderName
                                                                         andWithAcceptTime:movedDate];
                                            
//-----------------------------------------------------------------------
//                  double check (옮김정보가 같은경우를 찾아 옮김수량을 서로 더해주고 첫 옮김정보의 수량을 수정해준다, 같은정보가 없는경우에는 배렬에 추가)
                                            
                                            BOOL doubledItem = false;
                                            
                                            for (int j = 0; j < self.appDelegate.unreportedArray.count; j++) {
                                                
                                                if ([itemName isEqualToString:((Confirm*)self.appDelegate.unreportedArray[j]).moveItemName] && [senderLocation isEqualToString:((Confirm*)self.appDelegate.unreportedArray[j]).senderLocation] && [receiverLocation isEqualToString:((Confirm*)self.appDelegate.unreportedArray[j]).receiverLocation]) {
                                                    
                                                    doubledItem = true;
                                                    NSInteger sum = ((Confirm*) self.appDelegate.unreportedArray[j]).moveAmount.integerValue + moveAmount.integerValue;
                                                    confirmModel.moveAmount = [NSString stringWithFormat:@"%ld", (long)sum];
                                                    
                                                    [self.appDelegate.unreportedArray replaceObjectAtIndex:j withObject:confirmModel];
                                                }
                                            }
                                            
                                            if (!doubledItem) {
                                                [self.appDelegate.unreportedArray addObject:confirmModel];
                                            }
//-------------------------------------------------------------------------
                                            
                                        }

                                        
                                        [self.hud hide:YES];
                                        [self setCurrentUIChange];
                                        
                                    } else {
                                        [self.hud hide:YES];
                                        NSString *errorMessage = (NSString *)[dicData objectForKey:MESSAGE];
                                        [self.view makeToast:errorMessage duration:1.5 position:CSToastPositionCenter];
                                    }
                                } andFailBlock:^(NSError *error) {
                                    [self.hud hide:YES];
                                    [self.view makeToast:@"PLEASE CHECK INTERNET CONNECTION!" duration:1.5 position:CSToastPositionCenter];
                                }];
    });
    
}

#pragma mark - Moving report update (Move 테블에서 sender_reported 와 receiver_reported를 업데이트 한다.)

- (void) updateMoveReported {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        [ojoClient updateUnreportedItem:UPDATE_UNREPORTED_MOVING
                           andMovedInID:self.movedInID
                          andMovedOutID:self.movedOutID
                            andLocation:self.location
                         andFinishBlock:^(NSArray *data) {
                             
                             
                             NSDictionary *dicData = (NSDictionary *)data;
                             NSString *stateCode = [dicData objectForKey:STATE];
                             
                             [self.hud hide:YES];
                             
                             if ([stateCode isEqualToString:@"200"])
                             {
                                 
                                 self.currentNum ++;
                                 [self setCurrentUIChange];
                                 
                             } else {
                                 
                                 NSString *errorMessage = (NSString *)[dicData objectForKey:MESSAGE];
                                 [self.view makeToast:errorMessage duration:1.5 position:CSToastPositionCenter];
                             }
                             
                             
            
        } andFailBlock:^(NSError *error) {
            [self.hud hide:YES];
            [self.view makeToast:@"PLEASE CHECK INTERNET CONNECTION!" duration:1.5 position:CSToastPositionCenter];
            
        }];
        
        
    });
    
    
}




#pragma  mark - textView animation method (다음 아이템을 위한 애니메이션부분)
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
