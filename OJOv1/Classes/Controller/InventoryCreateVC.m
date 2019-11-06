//
//  InventoryCreateVC.m
//  OJOv1
//
//  Created by MilosHavel on 16/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "InventoryCreateVC.h"
#import "InventoryListVC.h"
#import "LDProgressView.h"
#import "Item.h"
#import "LNNumberpad.h"

@interface InventoryCreateVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UITextField *setParLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *agreeSeg;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *countStateLabel;
@property (weak, nonatomic) IBOutlet LDProgressView *progress;
@property (assign, nonatomic) NSInteger segIndex;
@property (strong, nonatomic) NSString *itemNameStr;
@property (strong, nonatomic) NSString *par;
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) NSInteger currentCount;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *controller;

@end

@implementation InventoryCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //----------- get all item aray from App delegate -----------
    self.itemArray = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.itemArray = appDelegate.allItemArray;
    [self sortAllItemByRanking];
    
    // ----------- customize keyboard pad -----------
    /*
     * An example loading a custom xib.
     * Normally you should not need to do this, but instead would either modify LNNumberpad.xib or
     * change the default xib in the defaultLNNumberpad class method to your own xib.
     * This however, is for demonstration purposes.
     */
    
    self.setParLabel.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    // The "normal" numberpad
//    self.setParLabel.inputView   = [LNNumberpad defaultLNNumberpad];

    
    //----------- initialize of count -----------
    self.totalCount = self.itemArray.count;
    self.currentCount = 0;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.controller = [userDefaults objectForKey:CONTROLLER];
    self.titleLabel.text = self.location;
    
    [self setCurrentUIChange];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.setParLabel = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) loadAllItem{
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.userInteractionEnabled = NO;
//    [hud show:YES];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        OJOClient *ojoClicent = [OJOClient sharedWebClient];
//        [ojoClicent getAllItems:GET_ALL_ITEM onFinish:^(NSArray *data) {
//            
//            NSDictionary *dicData = (NSDictionary *)data;
//            NSString *stateCode = [dicData objectForKey:STATE];
//            if ([stateCode isEqualToString:@"200"]) {
//                
//                NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
//                NSInteger count = response.count;
//                self.totalCount = count;
//                
//                [self.itemArray removeAllObjects];
//                Item *itemModel = nil;
//                
//                for (int i = 0; i < count; i++) {
//                    
//                    NSDictionary *userDict = (NSDictionary *) response[i];
//                    NSString *ItemName = [userDict objectForKey:ITEM_NAME];
//                    NSString *categoryName = [userDict objectForKey:ITEM_CATEGORY];
//                    NSInteger fullOpen = [[userDict objectForKey:FULL_OPEN] integerValue];
//                    NSInteger frequency = [[userDict objectForKey:FREQUENCY] integerValue];
//                    NSString *price = [userDict objectForKey:PRICE];
//                    
//                    
//                    itemModel = [[Item alloc] initWithItemName:ItemName
//                                            andWithFullAndOpen:fullOpen
//                                           andWithCategoryName:categoryName
//                                                  andFrequency:frequency
//                                                      andPrice:price];
//                    [self.itemArray addObject:itemModel];
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hide:YES];

//                });
//            }
//            
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hide:YES];
//                    [self.itemArray removeAllObjects];
//                    NSString *response = [dicData objectForKey:MESSAGE];
//                    [self.view makeToast:response duration:1.5 position:CSToastPositionCenter];
//                    
//                });
//            }
//            
//        } onFail:^(NSError *error) {
//            [hud hide:YES];
//            [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
//        }];
//    });
//}

-(void) viewDidLayoutSubviews{
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.setParLabel.layer.cornerRadius = self.setParLabel.bounds.size.height / 2;
    self.saveButton.layer.cornerRadius = self.saveButton.bounds.size.height / 2;
    
}

#pragma mark - Sort Action according to ranking

- (void) sortAllItemByRanking{
    [self.itemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Item *item1 = (Item *)obj1;
        Item *item2 = (Item *)obj2;
        if (item1.frequency > item2.frequency) {
            return NSOrderedAscending;
        } else if (item1.frequency < item2.frequency) {
            return NSOrderedDescending;
        } else {
            return  NSOrderedSame;
        }
    }];
}

#pragma mark - Button Action method

- (IBAction)onBack:(id)sender {
   
    [self dismissViewControllerAnimated:true completion:nil];
    
}
- (IBAction)onSaveAndGoToNextItem:(id)sender {
    
    self.itemNameStr = self.itemName.text;
    self.par = self.setParLabel.text;
    
    if (self.segIndex == 0) { // yes
        if ([self.itemNameStr isEqualToString:@""]) {
            [self.view makeToast:@"Empty item" duration:1.5 position:CSToastPositionCenter];
            return;
        }
        
        if ([self.par isEqualToString:@""]) {
            [self.view makeToast:@"" duration:1.5 position:CSToastPositionCenter];
            return;
        }
        
        [self setInventory];
    }
    
    else if(self.segIndex == 1){
        [self unsetInventory];
    
    }
    else{
        
    }
    
}

- (void) setCurrentUIChange{
    if (self.currentCount == self.totalCount) {
            InventoryListVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"inventoryListPage"];
            [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self presentViewController:svc animated:YES completion:nil];

    } else{
        Item *itemModel = nil;
        itemModel = (Item *)self.itemArray[self.currentCount];
        [self progressViewSet:self.currentCount withTotalCount:self.totalCount];
        self.itemName.text = itemModel.itemName;
    }
}


- (void) progressViewSet:(NSInteger)currentProgress withTotalCount:(NSInteger)totalCount {
    CGFloat progressValue = (CGFloat)(self.currentCount + 1) / self.totalCount;
    self.progress.progress = progressValue;
    self.progress.color = [UIColor colorWithRed:116/255 green:155/255 blue:255/255 alpha:1.0];
    self.progress.borderRadius = @3;
    self.countStateLabel.text = [NSString stringWithFormat:@"%ld%@%ld",(long)(currentProgress +1), @" of ", (long)totalCount];
}

- (IBAction)onSelectAgree:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0: // YES
            self.segIndex = 0;
            break;
        case 1: // NO
            self.segIndex = 1;
            break;
        default:
            break;
    }
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
    [self.agreeSeg setSelectedSegmentIndex:0];
    self.segIndex = 0;
}

#pragma mark - create inventory method

- (void) setInventory{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.controller, @"/addInventory"];
        [ojoClient addInventory:url
                    andItemName:self.itemNameStr
                      andParStr:self.par
                 andFinishBlock:^(NSArray *data){
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
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
            [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
            
        }];
        
    });
}

- (void) unsetInventory{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        NSString *url = [NSString stringWithFormat:@"%@%@%@", @"mobile/", self.controller, @"/unsetInventory"];
        [ojoClient unsetInventory:url andItemName:self.itemNameStr andFinishBlock:^(NSArray *data) {
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self animatPage:UISwipeGestureRecognizerDirectionLeft];
                    self.currentCount ++;
                    [self setCurrentUIChange];
                });
            } else{
                [hud hide:YES];
                [self animatPage:UISwipeGestureRecognizerDirectionLeft];
                self.currentCount ++;
                [self setCurrentUIChange];
            }
            
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"Please check internect connection" duration:2.5 position:CSToastPositionCenter];
            
        }];
        
    });

}
- (IBAction)tabGestureEventy:(id)sender {
    [self.setParLabel resignFirstResponder];
    
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
