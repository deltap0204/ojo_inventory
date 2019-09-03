//
//  ManagerInventoryCreateVC.m
//  OJOv1
//
//  Created by MilosHavel on 24/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ManagerInventoryCreateVC.h"
#import "ManagerInventoryVC.h"
#import "ManagerInventoryCommentVC.h"
#import "LDProgressView.h"
#import "Inventory.h"
#import "LNNumberpad.h"

@interface ManagerInventoryCreateVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *countStateLabel;
@property (weak, nonatomic) IBOutlet LDProgressView *progress;
@property (weak, nonatomic) IBOutlet UITextField *setParLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture;
@property (weak, nonatomic) IBOutlet UILabel *setedParLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (strong, nonatomic) NSString *itemNameStr;
@property (strong, nonatomic) NSString *amount;
@property (assign, nonatomic) NSInteger segIndex;
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) NSInteger currentCount;
@property (strong, nonatomic) NSMutableArray *inventoryList;
@property (strong, nonatomic) NSMutableArray *inventoryReportList;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *controller;
@property (assign, nonatomic) NSInteger select;
@property (strong, nonatomic) NSString *deviceType;



@end

@implementation ManagerInventoryCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.controller = [userDefaults objectForKey:CONTROLLER];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    if ([self.deviceType isEqualToString:@"iPad"]) {
        self.setParLabel.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    }
    
    self.titleLabel.text = self.location;
    self.inventoryList = [[NSMutableArray alloc] init];
    self.inventoryReportList = [[NSMutableArray alloc] init];
    self.currentCount = 0;
    [self.saveButton setEnabled:NO];
    UIColor *color = [UIColor whiteColor];
    self.setParLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER AMOUNT" attributes:@{NSForegroundColorAttributeName:color}];
    self.setedParLabel.text = @"PAR : 0";
    self.itemName.text = @"ITEM";
    self.countStateLabel.text = @"0 of 0";
    
    [self loadAllItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews{
    
    CGFloat fontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 40.0f;
    else fontSize = 20.0f;
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.setParLabel.layer.cornerRadius = self.setParLabel.bounds.size.height / 2;
    self.saveButton.layer.cornerRadius = self.saveButton.bounds.size.height / 2;
    
}

#pragma mark - sever connection

- (void) loadAllItem{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.controller, @"/getAllInventory"];
        [ojoClient getInventoryAllItemOfBar:url
                             andFinishBlock:^(NSArray *data) {
                                 NSDictionary *dicData = (NSDictionary *)data;
                                 NSString *stateCode = [dicData objectForKey:STATE];
                                 if ([stateCode isEqualToString:@"200"]){
                                     NSArray *response = (NSArray*)[dicData objectForKey:MESSAGE];
                                     [self.inventoryList removeAllObjects];
                                     NSInteger count = response.count;
                                     self.totalCount = count;
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
                                         NSString *itemCategory = [userDict objectForKey:INVENTORY_CATEGORY];

                                         inventoryModel = [[Inventory alloc] initWithItemName:itemName
                                                                             andWithFrequency:frequency
                                                                              andWithFullOpen:fullOpen
                                                                         andWithOpenBottleWet:openBottleWet
                                                                                   andWithPar:par
                                                                             andWithItemPrice:itemPrice
                                                                                    andAmount:amount
                                                                                  andCategory:itemCategory];
                                         
                                         [self.inventoryList addObject:inventoryModel];
                                         
                                     }
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [hud hide:YES];
                                         [self sortByRanking];
                                         [self setCurrentUIChange];
                                         
                                     });
                                     
                                 } else {
                                 
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [hud hide:YES];
                                         [self.inventoryList removeAllObjects];
                                         NSString *response = [dicData objectForKey:MESSAGE];
                                         [self.view makeToast:response duration:2.5 position:CSToastPositionCenter];
                                         
                                     });
                                 }
            
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
            
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
}

- (void) setCurrentUIChange{
//    self.totalCount
    if (self.currentCount == self.totalCount) {
        if ([self.deviceType isEqualToString:@"iPad"]) {
            [self performSegueWithIdentifier:@"gotoManagerComment_ipad" sender:@"toComment"];
        } else{
            [self performSegueWithIdentifier:@"gotoManagerComment" sender:@"toComment"];
        }
        
        
    } else{
        
        Inventory *inventoryModel = nil;
        inventoryModel = (Inventory *)self.inventoryList[self.currentCount];
        [self progressViewSet:self.currentCount withTotalCount:self.totalCount];
        self.itemName.text = inventoryModel.itemName;
        self.setedParLabel.text = [NSString stringWithFormat:@"%@%@", @"PAR : ", inventoryModel.par];
        self.categoryLabel.text = [NSString stringWithFormat:@"%@%@", @"CAGEGORY : ", inventoryModel.category];
        self.priceLabel.text = [NSString stringWithFormat:@"%@%@", @"PRICE : RD$", inventoryModel.itemPrice];
        
//        if (inventoryModel.fullOpen == 0) {
//            self.setParLabel.text = @"0";
//        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([sender isEqualToString:@"toComment"]) {
        ManagerInventoryCommentVC *viewController = (ManagerInventoryCommentVC*)segue.destinationViewController;
        viewController.reportArray = self.inventoryReportList;
    }
    

}

- (void) progressViewSet:(NSInteger)currentProgress withTotalCount:(NSInteger)totalCount {
    CGFloat progressValue = (CGFloat)(self.currentCount + 1) / self.totalCount;
    self.progress.progress = progressValue;
    self.progress.color = [UIColor colorWithRed:116/255 green:155/255 blue:255/255 alpha:1.0];
    self.progress.borderRadius = @3;
    self.countStateLabel.text = [NSString stringWithFormat:@"%ld%@%ld",(long)(currentProgress +1), @" of ", (long)totalCount];
}


- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)onCheck:(id)sender {
    if (self.select == 1) {
        [self uncheck];
    }
    else {
        [self check];
    }
}

- (void) check{
    self.select = 1;
    [self.checkBox setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [self.saveButton setEnabled:YES];
}

- (void) uncheck{
    self.select = 0;
    [self.checkBox setImage:nil forState:UIControlStateNormal];
    [self.saveButton setEnabled:NO];
}



- (IBAction)onSaveAndGoToNextItem:(id)sender {
    self.itemNameStr = self.itemName.text;
    self.amount = self.setParLabel.text;
    
    if ([self.amount isEqualToString:@""]) {
        [self.view makeToast:@"Insert amount value" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [self setAmount];
    
}

- (void) setAmount{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.controller, @"/editInventory"];
        [ojoClient editManagerInventory:url
                            andItemName:self.itemNameStr
                              andAmount:self.amount
                         andFinishBlock:^(NSArray *data){
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self addOnReportArray];
                    
                    [self animatPage:UISwipeGestureRecognizerDirectionLeft];
                    self.currentCount ++;
                    [self setCurrentUIChange];
                    
                });
            } else{
                [hud hide:YES];
                [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
            
            
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please check internet connection" duration:1.5 position:CSToastPositionCenter];
            
        }];
        
    });
    

    

}

- (void) addOnReportArray{
    NSString *parLabelText = self.setedParLabel.text;
    
    NSArray *foo1 = [parLabelText componentsSeparatedByString:@" : "];
    NSString *par = foo1[1];
    
    Inventory *reportModel;
    reportModel = [[Inventory alloc] initWithItemName:self.itemNameStr
                                     andWithFrequency:5
                                      andWithFullOpen:0
                                 andWithOpenBottleWet:@""
                                           andWithPar:par
                                     andWithItemPrice:@""
                                            andAmount:self.amount
                                          andCategory:@""];
    [self.inventoryReportList addObject:reportModel];

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
    
    self.setParLabel.text = @"";
    [self uncheck];
}


- (IBAction)tabGestureEventy:(id)sender {
    [self.setParLabel resignFirstResponder];
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
