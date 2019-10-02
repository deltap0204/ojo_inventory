//
//  BartenderVC.m
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "BartenderVC.h"
#import "LoginVC.h"
#import "Confirm.h"
#import "ConfirmVC.h"


@interface BartenderVC ()


@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *userRealNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shiftInvButton;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *username;
@property (strong,nonatomic) NSString *userRealName;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *deviceType;

@end

@implementation BartenderVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    [self.userRealNameLabel setText:[LoginVC getLoggedinUser].name];
    
    self.location = [LoginVC getLoggedinUser].location;
    [self.locationLabel setText:self.location];
    NSString *controller = [LoginVC getLoggedinUser].contoller;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.location forKey:SEL_LOCATION];
    [userDefaults setObject:controller forKey:CONTROLLER];
    
    
    // initialize the barInventoryArray
    self.appDelegate.bartInventoryArray = [[NSMutableArray alloc] init];
    self.appDelegate.shiftReport = [[NSMutableArray alloc] init];
    
    // initialize the unread items
    self.appDelegate.unreadReceivedItemArray = [[NSMutableArray alloc] init];
    self.appDelegate.unreadSentItemArray = [[NSMutableArray alloc] init];
    
    [self getAllUnreadMoveList];
  
}

- (void) viewDidLayoutSubviews{
    
    self.logoutButton.layer.cornerRadius = 3.0;
    self.logoutButton.layer.borderWidth = 3.0;
    self.logoutButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    self.deviceType = [userDefault objectForKey:DEVICETYPE];
    
    //-------------  iPad ---------------

    self.shiftInvButton.layer.borderWidth = 5.0;
    self.shiftInvButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    //--------------------------------------

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getAllUnreadMoveList{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Checking Moved Items...";
    hud.userInteractionEnabled = NO;
    
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        [ojoClient searchReceiveItem:ITEM_MOVE_SEARCH
                  andReceiveLocation:self.location
                      andFinishBlock:^(NSArray *data) {
                          NSDictionary *dicData = (NSDictionary *) data;
                          NSString *stateCode = [dicData objectForKey:STATE];
                          if ([stateCode isEqualToString:@"200"]) {
                              NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                              NSInteger count = response.count;
                              [self.appDelegate.unreadReceivedItemArray removeAllObjects];
                              [self.appDelegate.unreadSentItemArray removeAllObjects];
                              
                              Confirm *confirmModel = nil;
                              
                              for (int i = 0; i < count; i++) {
                                  NSDictionary *resultDict = (NSDictionary *)response[i];
                                  NSString *moveID = [resultDict objectForKey:MOVE_ID];
                                  NSString *itemName = [resultDict objectForKey:MOVE_ITEM_NAME];
                                  NSString *senderLocation = [resultDict objectForKey:SENDER_LOCATION];
                                  NSString *moveAmount = [resultDict objectForKey:MOVE_ITEM_AMOUNT];
                                  NSString *senderName = [resultDict objectForKey:NAME];
                                  NSString *moved_str = [resultDict objectForKey:MOVED_TIME];
                                  NSString *receiverLocation = [resultDict objectForKey:RECEIVER_LOCATION];

                                  confirmModel = [[Confirm alloc] initWithMoveID:moveID
                                                             andWithMoveItemName:itemName
                                                               andWithMoveAmount:moveAmount
                                                           andWithSenderLocation:senderLocation
                                                          andWithReceiveLocation:receiverLocation
                                                               andWithSenderName:senderName
                                                               andWithAcceptTime:moved_str];
                                  
                                  if ([senderLocation isEqualToString:self.location]) {
                                      [self.appDelegate.unreadSentItemArray addObject:confirmModel];
                                  } else {
                                      [self.appDelegate.unreadReceivedItemArray addObject:confirmModel];
                                  }
                              }
                              
                            
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [hud hide:YES];
                                  if (self.appDelegate.unreadReceivedItemArray.count != 0) {
                                      // if it has moved items, user has to confirm them on ConfirmVC
                                      [self unconfirmedReceivedItems];
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

- (void) unconfirmedReceivedItems{
    
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"CHECK OUT NEW ITEMS"
                                message:[NSString stringWithFormat:@"%ld NEW ITEMS HAVE BEEN ADDED, PLEASE CONTINUE AFTER ACCEPT/REJECT",(long)self.appDelegate.unreadReceivedItemArray.count]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"CONFIRM")
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

- (void) unconfirmedSentItems {
    
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"SORRY"
                                message:[NSString stringWithFormat:@"YOU SENT %ld ITEMS, BUT IT'S NOT ACCEPTED YET \n PLEASE TRY AFTER IT'S ACCEPTED",
                                         (long)self.appDelegate.unreadSentItemArray.count]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"CONFIRM")
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                         [self logoutAction:self.logoutButton];

                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    return;
    
}
- (IBAction)logoutAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onInventory:(UIButton *)sender {
    
    if (self.appDelegate.unreadSentItemArray.count == 0 && self.appDelegate.unreadReceivedItemArray.count == 0) {
        
        [self performSegueWithIdentifier:@"startBartenderInventory_ipad" sender:nil];
        
    } else {
        

        if (self.appDelegate.unreadSentItemArray.count != 0) {
            [self unconfirmedSentItems];
        }
        
        if (self.appDelegate.unreadReceivedItemArray.count != 0) {
            [self unconfirmedReceivedItems];
        }
        
        
    }
}



- (void) showActionSheetView{
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:@"SELECT INVENTORY TYPE"
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
                              actionWithTitle:@"START INVENTORY"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  self.appDelegate.inventoryType = @"start";
                                  [self performSegueWithIdentifier:@"startBartenderInventory" sender:nil];
                                  
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"SHIFT INVENTORY(Barlax&Evento)"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  self.appDelegate.inventoryType = @"shift";
                                  [self performSegueWithIdentifier:@"startBartenderInventory" sender:nil];
                              }];
    UIAlertAction* button3 = [UIAlertAction
                              actionWithTitle:@"END INVENTORY"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  self.appDelegate.inventoryType = @"end";
                                  [self performSegueWithIdentifier:@"startBartenderInventory" sender:nil];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:button3];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
