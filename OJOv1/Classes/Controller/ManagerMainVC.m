//
//  ManagerMainVC.m
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ManagerMainVC.h"
#import "LoginVC.h"
#import "Confirm.h"
#import "ConfirmVC.h"


@interface ManagerMainVC ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *startInventoryButton;
@property (weak, nonatomic) IBOutlet UIButton *moveButton;
@property (weak, nonatomic) IBOutlet UIButton *refillButton;
@property (weak, nonatomic) IBOutlet UIButton *movedItemToday;

@property (strong, nonatomic) NSString *role;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSMutableArray *confirmArray;
@property (assign, nonatomic) NSInteger movingCount;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *deviceType;

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *almacenButton;
@property (weak, nonatomic) IBOutlet UIButton *neverasButton;
@property (weak, nonatomic) IBOutlet UIButton *viewCancelButton;

#pragma mark - constraint property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceWithLogoAndWelcom;

@end

@implementation ManagerMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.confirmArray = [[NSMutableArray alloc] init];
    self.role = [LoginVC getLoggedinUser].role;
    self.location = [LoginVC getLoggedinUser].location;
    self.deviceType = [self.userDefaults objectForKey:DEVICETYPE];
    
    [self.actionView setHidden:YES];
    CGFloat awesomeFontSize = 0.0;
    if ([self.deviceType isEqualToString:@"iPad"]) awesomeFontSize = 40.0f;
    else awesomeFontSize = 20.0f;
    
    [self.logoutButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:awesomeFontSize]];
    [self.logoutButton setTitle:@"\uf08b" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    /*
     *  role = 2 stock manager
     *  role = 3 night manager
     */
    
    if ([self.role isEqualToString:@"2"]) {
        [self.refillButton setHidden:NO];
        [self.titleLabel setText:@"STOCK MANAGER"];
        [self.userDefaults setObject:@"stocks" forKey:SEL_LOCATION];
        
    } else{
        [self.refillButton setHidden:YES];
        [self.titleLabel setText:@"NIGHT MANAGER"];
        [self getAllConfirmList];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews{
    self.startInventoryButton.layer.cornerRadius = self.startInventoryButton.bounds.size.height / 2;
    self.moveButton.layer.cornerRadius = self.moveButton.bounds.size.height / 2;
    self.refillButton.layer.cornerRadius = self.refillButton.bounds.size.height / 2;
    self.movedItemToday.layer.cornerRadius = self.movedItemToday.bounds.size.height / 2;
    
    self.almacenButton.layer.cornerRadius = 10.0f;
    self.neverasButton.layer.cornerRadius = 10.0f;
    self.viewCancelButton.layer.cornerRadius = 10.0f;
    
    
    
}
#pragma mark - server connection method

- (void) getAllConfirmList{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        [ojoClient searchReceiveItemAtLocation:ITEM_MOVE_SEARCH_MANAGE
                      andFinishBlock:^(NSArray *data) {
                          NSDictionary *dicData = (NSDictionary *) data;
                          NSString *stateCode = [dicData objectForKey:STATE];
                          if ([stateCode isEqualToString:@"200"]) {
                              NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                              NSInteger count = response.count;
                              self.movingCount = count;
                              [self.confirmArray removeAllObjects];
                              Confirm *confirmModel = nil;
                              
                              for (int i = 0; i < count; i++) {
                                  
                                  NSDictionary *resultDict = (NSDictionary *)response[i];
                                  NSString *moveID = [resultDict objectForKey:MOVE_ID];
                                  NSString *itemName = [resultDict objectForKey:MOVE_ITEM_NAME];
                                  NSString *senderLocation = [resultDict objectForKey:SENDER_LOCATION];
                                  NSString *receiverLocation = [resultDict objectForKey:RECEIVER_LOCATION];
                                  NSString *moveAmount = [resultDict objectForKey:MOVE_ITEM_AMOUNT];
                                  NSString *senderName = [resultDict objectForKey:NAME];
                                  
                                  confirmModel = [[Confirm alloc] initWithMoveID:moveID
                                                             andWithMoveItemName:itemName
                                                               andWithMoveAmount:moveAmount
                                                                 andWithSenderLocation:senderLocation   
                                                                andWithReceiveLocation:receiverLocation
                                                                     andWithSenderName:senderName
                                                                     andWithAcceptTime:[self getCurrentTime]];
                                  
                                  [self.confirmArray addObject:confirmModel];
                                  
                              }
                              self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                              self.appDelegate.unreadReceivedItemArray = self.confirmArray;
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [hud hide:YES];
                                  if (self.movingCount != 0) {
                                      [self moveCheckPage];
                                      
                                  }
                                  
                              });
                          } else{
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [hud hide:YES];
                              });
                          }
                      } andFailBlock:^(NSError *error) {
                          [self.view makeToast:@"PLEASE CHECK INTERNET CONNECTION!" duration:1.5 position:CSToastPositionCenter];
                          [hud hide:YES];
                      }];
        
        
    });
    
}

- (void) moveCheckPage{
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"CHECK OUT NEW ITEMS"
                                message:[NSString stringWithFormat:@"%ld%@",(long)self.movingCount, @" NEW ITEMS HAVE BEEN ADDED."]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"CONFIRM"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                         NSString *identifier = @"";
                                                         if ([self.deviceType isEqualToString:@"iPad"]) identifier = @"confirmPage_ipad";
                                                         else identifier = @"confirmPage";
                                                             
                                                         ConfirmVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
                                                         [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                                         [self presentViewController:svc animated:YES completion:nil];
                    
                                                         
                                                     }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}



#pragma mark - button action method 

//segue =>  gotoManagerInventory

- (IBAction)onStartInventory:(id)sender {
    
    if ([self.deviceType isEqualToString:@"iPad"]) {
        if ([self.role isEqualToString:@"3"]) {
            [self.actionView setHidden:NO];
        } else{
            [self.userDefaults setObject:@"stocks" forKey:CONTROLLER];
            [self.userDefaults setObject:@"STOCK" forKey:SEL_LOCATION];
            [self performSegueWithIdentifier:@"gotoManagerInventory_ipad" sender:nil];
        }
        
    } else{
        [self showViewForIPhone];
    }
    
}


- (void) showViewForIPhone{
    if ([self.role isEqualToString:@"3"]) {
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:@"SELECT LOCATION"
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* button0 = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action)
                                  {
                                      return;
                                      //  UIAlertController will automatically dismiss the view
                                  }];
        
        UIAlertAction* button1 = [UIAlertAction
                                  actionWithTitle:@"ALMACEN"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self.userDefaults setObject:@"almacens" forKey:CONTROLLER];
                                      [self.userDefaults setObject:@"ALMACEN" forKey:SEL_LOCATION];
                                      [self performSegueWithIdentifier:@"gotoManagerInventory" sender:nil];
                                      
                                  }];
        
        UIAlertAction* button2 = [UIAlertAction
                                  actionWithTitle:@"NEVERAS"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [self.userDefaults setObject:@"neveras" forKey:CONTROLLER];
                                      [self.userDefaults setObject:@"NEVERAS" forKey:SEL_LOCATION];
                                      [self performSegueWithIdentifier:@"gotoManagerInventory" sender:nil];
                                  }];
        
        [alert addAction:button0];
        [alert addAction:button1];
        [alert addAction:button2];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        [self.userDefaults setObject:@"stocks" forKey:CONTROLLER];
        [self.userDefaults setObject:@"STOCK" forKey:SEL_LOCATION];
        [self performSegueWithIdentifier:@"gotoManagerInventory" sender:nil];
        
    }
}

- (IBAction)onMove:(id)sender {}
- (IBAction)onRefill:(id)sender {}
- (IBAction)logOut:(id)sender {
    LoginVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:svc animated:YES completion:nil];
}

- (IBAction)onIpadStartInventory:(UIButton*)sender {
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:
            // almacen location
            [self.userDefaults setObject:@"almacens" forKey:CONTROLLER];
            [self.userDefaults setObject:@"ALMACEN" forKey:SEL_LOCATION];
            [self performSegueWithIdentifier:@"gotoManagerInventory_ipad" sender:nil];
            break;
        case 2:
            // neveras location
            [self.userDefaults setObject:@"neveras" forKey:CONTROLLER];
            [self.userDefaults setObject:@"NEVERAS" forKey:SEL_LOCATION];
            [self performSegueWithIdentifier:@"gotoManagerInventory_ipad" sender:nil];
            break;
        case 3:
            // cancel action
            [self.actionView setHidden:YES];
            break;
        default:
            break;
            
    }
    
    
}

- (NSString *) getCurrentTime{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:now];
}

@end
