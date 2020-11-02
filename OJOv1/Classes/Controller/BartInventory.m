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
#import "AddDeviceVC.h"


@interface BartInventory ()

@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullWeightLabel;
@property (weak, nonatomic) IBOutlet UITextField *openBtWetTextField;
@property (weak, nonatomic) IBOutlet UITextField *fullBtCountTextField;
@property (weak, nonatomic) IBOutlet UILabel *openBuWetLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullBtCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextItemButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *userRealNameLabel;

// 수자패드 버튼
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (weak, nonatomic) IBOutlet UIButton *sevenButton;
@property (weak, nonatomic) IBOutlet UIButton *eightButton;
@property (weak, nonatomic) IBOutlet UIButton *nineButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;


@property (weak, nonatomic) IBOutlet UIView *bluetoothView;

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

// edit flag
@property (strong, nonatomic) NSString *editFlag;
@property (assign, nonatomic) BOOL openFlag;

@property (strong, nonatomic) BLEClient *bleClient;

@property (assign, nonatomic) bool allowBLEScale;

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
    self.openFlag = false;
    
    self.editFlag = @"full";
    
    self.openBtWetTextField.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.locationController = [userDefaults objectForKey:CONTROLLER];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    [self.nextItemButton setEnabled:NO];
    self.allowBLEScale = NO;
    
    // replace to customized keyboard
    
    
    /*
    if ([self.deviceType isEqualToString:@"iPad"]) {
        self.openBtWetTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
        self.fullBtCountTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    }
    */

    self.userRealNameLabel.text = [NSString stringWithFormat:@"Hello %@", [LoginVC getLoggedinUser].name];
    self.locationTitle.text = self.location;
    
    self.appDelegate.startTime = [self getCurrentTimeString];
    [self getAllItems];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bleClient = [BLEClient sharedBLEClient];
    if (self.bleClient.activePeripheral != nil && self.bleClient.activePeripheral.state) {
        self.bleClient.delegate = self;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    self.bleClient.delegate = nil;
    [super viewWillDisappear:animated];
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
    
    self.openBtWetTextField.layer.borderWidth = 4.0;
    self.fullBtCountTextField.layer.borderWidth = 4.0;
    
    [self makeFullTextFieldHighlight];


    self.bluetoothView.layer.borderWidth = 2.0;
    self.bluetoothView.layer.borderColor = [UIColor colorWithRed:145.0/255.0 green:216.0/255.0 blue:247.0/255.0 alpha:1.0].CGColor;
    
    // Number pad
    
    CGFloat cornerRadius = 42.0;
    CGFloat borderWidth = 1.0;
    UIColor *borderColor = [UIColor colorWithRed:145.0/255.0 green:216.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    // Number button - 0
    self.zeroButton.layer.cornerRadius = cornerRadius;
    self.zeroButton.layer.borderWidth = borderWidth;
    self.zeroButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 1
    self.oneButton.layer.cornerRadius = cornerRadius;
    self.oneButton.layer.borderWidth = borderWidth;
    self.oneButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 2
    self.twoButton.layer.cornerRadius = cornerRadius;
    self.twoButton.layer.borderWidth = borderWidth;
    self.twoButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 3
    self.threeButton.layer.cornerRadius = cornerRadius;
    self.threeButton.layer.borderWidth = borderWidth;
    self.threeButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 4
    self.fourButton.layer.cornerRadius = cornerRadius;
    self.fourButton.layer.borderWidth = borderWidth;
    self.fourButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 5
    self.fiveButton.layer.cornerRadius = cornerRadius;
    self.fiveButton.layer.borderWidth = borderWidth;
    self.fiveButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 6
    self.sixButton.layer.cornerRadius = cornerRadius;
    self.sixButton.layer.borderWidth = borderWidth;
    self.sixButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 7
    self.sevenButton.layer.cornerRadius = cornerRadius;
    self.sevenButton.layer.borderWidth = borderWidth;
    self.sevenButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 8
    self.eightButton.layer.cornerRadius = cornerRadius;
    self.eightButton.layer.borderWidth = borderWidth;
    self.eightButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - 9
    self.nineButton.layer.cornerRadius = cornerRadius;
    self.nineButton.layer.borderWidth = borderWidth;
    self.nineButton.layer.borderColor = borderColor.CGColor;
    
    // Number button - <
    self.removeButton.layer.cornerRadius = cornerRadius;
    self.removeButton.layer.borderWidth = borderWidth;
    self.removeButton.layer.borderColor = borderColor.CGColor;
    
    // Check button - v
    self.nextItemButton.layer.cornerRadius = cornerRadius;
    self.nextItemButton.layer.borderWidth = borderWidth;
    self.nextItemButton.layer.borderColor = borderColor.CGColor;
}

- (void) getAllItems{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"GETTING NEEDED DATA FROM SERVER...";
    self.hud.userInteractionEnabled = NO;
//    [self.hud show:YES];
    
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


#pragma mark - This is sorting method to alphabet

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

#pragma mark - UI Change method

- (void) setCurrentUIChange {
    
    self.editFlag = @"full";
    
    if (self.currentNum == self.totalCount) {
        
        // get the time
        
        self.appDelegate.endTime = [self getCurrentTimeString];
        self.appDelegate.totalCash = [NSString stringWithFormat:@"%ld", (long)self.totalCash];
        
        BarInventoryCommentVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BarInventoryCommentVC"];
        [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
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
            [self.bluetoothView setHidden:YES];
            
            [self.openBuWetLabel setHidden:YES];
            [self.openBtWetTextField setHidden:YES];
            
            [self.emptyWeightLabel setHidden:YES];
            [self.fullWeightLabel setHidden:YES];
            
            self.openBtWetTextField.text = @"0";
            self.allowBLEScale = NO;
            self.minValueCheck = true;
            [self.nextItemButton setEnabled:YES];
            
            self.openFlag = false;
            
        } else {
            [self.bluetoothView setHidden:NO];

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
            self.allowBLEScale = YES;
            self.openFlag = true;
            
        }
        
        self.currentFullWeightOfItem = inventoryModel.itemBottleFullWet;
        self.currentEmptyWeightOfItem = inventoryModel.itemBottleEmpWet;
        
    }
}

#pragma mark - Bluetooth action

- (IBAction)onBluetoothAction:(id)sender {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Getting Data from Bluetooth Scale...";
    self.hud.userInteractionEnabled = NO;
    [self.hud show:YES];
    
    if ([[self.bleClient activePeripheral] state]) {
        self.allowBLEScale = YES;
    } else {
        AddDeviceVC* svc =[self.storyboard instantiateViewControllerWithIdentifier:@"addDevicePage"];
        [self presentViewController:svc animated:YES completion:nil];
    }
    [self.openBtWetTextField setText:@"0"];
    
    [NSThread sleepForTimeInterval: 1.0];
    
    // -- Bluetooth sound ON
    SystemSoundID soundID;
    NSString *effectTitle = @"bluetooth_beef";
    
    NSString *soundPath 	= [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    // --- Open value check
    self.openBtWetTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.minValueCheck = true;
    [self.nextItemButton setEnabled:YES];
    
    [self.hud hide:YES];
  
}

- (void) checkBottleWeightValid: (NSString *) weightStr {
    NSInteger weight = [weightStr integerValue];
    NSInteger fullWeight = [self.currentFullWeightOfItem integerValue];
    NSInteger emptyWeight = [self.currentEmptyWeightOfItem integerValue];
    
    if (weight < emptyWeight) {
        
        self.openBtWetTextField.layer.borderColor = [[UIColor redColor] CGColor];
        self.minValueCheck = false;
        [self.nextItemButton setEnabled:NO];
        
    } else if(weight > emptyWeight & weight < fullWeight){
        
        self.openBtWetTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.minValueCheck = true;
        [self.nextItemButton setEnabled:YES];
        
    }
}

#pragma mark - number pad action

- (IBAction)onNumberAction:(UIButton *)sender {
    
    //--- play pad mp3
    SystemSoundID soundID;
    NSString *effectTitle = @"supermario_coin";
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    //---
   
    
    
    NSInteger numberTag = sender.tag;
    
    UITextField *selectedTextField = self.fullBtCountTextField;
    NSString *currentText = @"";
    
    if ([self.editFlag isEqualToString:@"open"]) {
        selectedTextField = self.openBtWetTextField;
        currentText = self.openBtWetTextField.text;
    } else {
        selectedTextField = self.fullBtCountTextField;
        currentText = self.fullBtCountTextField.text;
    }
    
    
    NSString *clickedNumber = @"";
    if (numberTag != 10) {
         clickedNumber = [NSString stringWithFormat:@"%ld", (long)numberTag];
    } else {
        if ([currentText length] > 0) {
            clickedNumber = [currentText substringToIndex:[currentText length]-1];
            currentText = @"";
        }
        
    }

    selectedTextField.text = [NSString stringWithFormat:@"%@%@", currentText, clickedNumber];
    
    
    if ([self.editFlag isEqualToString:@"open"]) {
        // ------OPEN 값 체크, 실지---------
        
        NSInteger weight = [selectedTextField.text integerValue];
        NSInteger fullWeight = [self.currentFullWeightOfItem integerValue];
        NSInteger emptyWeight = [self.currentEmptyWeightOfItem integerValue];
        
        if (weight < emptyWeight) {
            
            self.openBtWetTextField.layer.borderColor = [[UIColor redColor] CGColor];
            self.minValueCheck = false;
            [self.nextItemButton setEnabled:NO];
            
        } else if(weight > emptyWeight & weight < fullWeight){
            
            self.openBtWetTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.minValueCheck = true;
            [self.nextItemButton setEnabled:YES];
            
        } else{
            
        }
        //----------------------------------
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
    
//    if (weight < fullWeight) return YES;
//    else return NO;
    
    return YES;
}



#pragma mark - FULL/OPEN Edit Action (현재 입력하는 부분을 하이라이트 시킨다)

- (IBAction)onStartFullEditAction:(id)sender {
    
    self.editFlag = @"full";
    [self makeFullTextFieldHighlight];
    
}


- (IBAction)onStartOpenEditAction:(id)sender {
    
    self.editFlag = @"open";
    [self makeOpenTextFieldHighlight];
    
}


- (void) makeFullTextFieldHighlight {
    
    self.fullBtCountTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.fullBtCountTextField.layer.masksToBounds = false;
    self.fullBtCountTextField.layer.shadowRadius = 3.0;
    self.fullBtCountTextField.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.fullBtCountTextField.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.fullBtCountTextField.layer.shadowOpacity = 1.0;
    
    // Unhighlight Other
    
    self.openBtWetTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.openBtWetTextField.layer.shadowOpacity = 0.0;
    
    
}

- (void) makeOpenTextFieldHighlight {
    
    self.openBtWetTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.openBtWetTextField.layer.masksToBounds = false;
    self.openBtWetTextField.layer.shadowRadius = 3.0;
    self.openBtWetTextField.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.openBtWetTextField.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.openBtWetTextField.layer.shadowOpacity = 1.0;
    
    // Unhighlight Other
    
    self.fullBtCountTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.fullBtCountTextField.layer.shadowOpacity = 0.0;
}



#pragma mark - Remove leading zeros from a string

- (NSString *) removeLeadingZeros:(NSString *) str {
    NSRange range = [str rangeOfString:@"^0*" options:NSRegularExpressionSearch];
    str = [str stringByReplacingCharactersInRange:range withString:@""];
    return str;
}


#pragma mark - Next article

- (IBAction)onNextArticle:(id)sender {
    
    NSString *wetOpenBottle = self.openBtWetTextField.text;
    if (![wetOpenBottle isEqualToString:@"0"]) {
        wetOpenBottle = [self removeLeadingZeros:wetOpenBottle];
    }
    
    NSString *fullBottleCount = self.fullBtCountTextField.text;
    if (![fullBottleCount isEqualToString:@"0"]) {
        fullBottleCount = [self removeLeadingZeros:fullBottleCount];
    }
    
    // After remove leading zero and insert again
    
    self.openBtWetTextField.text = wetOpenBottle;
    self.fullBtCountTextField.text = fullBottleCount;
    
    
  

    
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
                                                                            andWithItemPreOpen:inventoryModel.openBottleWet
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
                                                                andWithItemPreOpen:inventoryModel.openBottleWet
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
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
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
                              
                                    if ([stateCode isEqualToString:@"300"]) {
                                        [self.hud hide:YES];
                                        [self setCurrentUIChange];
                                    }
                              
                              
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

#pragma mark - BLE Delegate Method

- (void)bleDidUpdatedState:(CBCentralManager *)central {
//    if (central.state == CBCentralManagerStatePoweredOn) {
//        [self.bleClient findBLEPeripherals:5];
//    }
}

- (void) bleDidReceiveWeight:(int)weight {
    if (self.allowBLEScale) {
        [self.openBtWetTextField setText:[NSString stringWithFormat:@"%d", weight]];
        [self checkBottleWeightValid:[NSString stringWithFormat:@"%d", weight]];
    }
    
    
}

-(void) bleDidFoundDevices:(NSMutableArray *)peripherals {
    
}

-(void) bleDidConnect:(CBPeripheral *)peripheral {
//    if (self.bleClient.activePeripheral != nil && self.bleClient.activePeripheral.state) {
//        [self.bleClient.activePeripheral discoverServices:nil];
//    }
}

-(void) bleDidDisconnect:(CBPeripheral *)peripheral {
//    [self.bleClient connectPeripheral:self.bleClient.activePeripheral];
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

@end
