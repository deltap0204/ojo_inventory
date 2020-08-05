//
//  ConfirmVC.m
//  OJOv1
//
//  Created by MilosHavel on 01/12/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ConfirmVC.h"
#import "ConfirmTVC.h"
#import "Confirm.h"


@interface ConfirmVC ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *confirmArray;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray  *setIndexPathArray;
@property (strong, nonatomic) NSMutableArray *viewChanged;

@end

@implementation ConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.currentLocation = [userDefaults objectForKey:SEL_LOCATION];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    
    // Array Init
    self.confirmArray = [[NSMutableArray alloc] init];
    self.setIndexPathArray = [[NSMutableArray alloc] init];

    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.confirmArray = self.appDelegate.unreadReceivedItemArray;
    
    NSArray *array = @[@"0", @"0"];
    
    self.viewChanged = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.confirmArray.count; i++) {
        [self.viewChanged addObject:array];
    }
    
    
    // UITableView
    
    self.tableView.delaysContentTouches = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - UItableView delegate method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.confirmArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellItentifier = @"confirmCell";
    ConfirmTVC *confirmCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    if ([self.deviceType isEqualToString:@"iPad"]) confirmCell.fontSize = 15.0f;
    else confirmCell.fontSize = 10.0f;
    
    Confirm *confirmModel;
    
    confirmModel = (Confirm *)self.confirmArray[indexPath.row];
    confirmCell.itemName.text = confirmModel.moveItemName;
    confirmCell.movingAmount.text = confirmModel.moveAmount;
    confirmCell.sender.text = confirmModel.senderName;
    confirmCell.fromLocation.text = confirmModel.senderLocation;
    confirmCell.movedTime.text = confirmModel.acceptTime;
    
    NSString *receiver = confirmModel.receiverLocation;
    if (![receiver isEqualToString:@"ALMACEN"] || ![receiver isEqualToString:@"NEVERAS"]) {
        confirmCell.receiver.text = @"";
    }
    
    if ([receiver isEqualToString:@"ALMACEN"]) {
        confirmCell.receiver.text = @"ALMACEN";
    } else if ([receiver isEqualToString:@"NEVERAS"]){
        confirmCell.receiver.text = @"NEVERAS";
    } else{
        confirmCell.receiver.text = @"";
    }
    
    NSArray *array = self.viewChanged[indexPath.row];
    if ([array[0] isEqualToString:@"0"]) [confirmCell acceptState];
    else [confirmCell acceptedState];
    
    
    if ([array[1] isEqualToString:@"0"]) [confirmCell rejectState];
    else [confirmCell rejectedState];
    
    
    [confirmCell.acceptButton addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmCell.rejectButton addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmCell.acceptButton setTag:indexPath.row];
    [confirmCell.rejectButton setTag:indexPath.row];
    confirmCell.backgroundColor = confirmCell.contentView.backgroundColor;
    return confirmCell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
}

#pragma mark - accept & reject button action

- (void) acceptAction:(UIButton *)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    ConfirmTVC *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow = indexPath.row;
    
    Confirm *selectedConfirmModel = self.confirmArray[self.selectedRow];
    
    NSString *moveID = selectedConfirmModel.moveID;
    NSString *itemName = selectedConfirmModel.moveItemName;
    NSString *sendLocation = selectedConfirmModel.senderLocation;
    NSString *receiverLocation = selectedConfirmModel.receiverLocation;
    NSString *amount = selectedConfirmModel.moveAmount;
    NSString *senderName = selectedConfirmModel.senderName;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"Accepting...";
    [hud show:YES];
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    
    [ojoClient itemMoveAllow:ITEM_MOVE_ALLOW
                   andMoveID:moveID
             andMoveItemName:itemName
               andMoveAmount:amount
           andSenderLocation:sendLocation
         andReceiverLocation:receiverLocation
              andFinishBlock:^(NSArray *data) {
                  
                  NSDictionary *dicData = (NSDictionary*)data;
                  NSString *stateCode = [dicData objectForKey:STATE];
                  if ([stateCode isEqualToString:@"200"]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hide:YES];
                          
        // ---- Doubled item check   {
                          
                          BOOL doubledItem = false;
                          
                          if (self.appDelegate.allowedArray.count > 1) {
                              
                              
                              
                              
                              for (int i = 0; i < self.appDelegate.allowedArray.count; i++) {
                                  
                                  Confirm *confirmMovedModel;
                                  confirmMovedModel = self.appDelegate.allowedArray[i];
                                  if ([confirmMovedModel.moveItemName isEqualToString:itemName]  && [confirmMovedModel.senderLocation isEqualToString:sendLocation] && [confirmMovedModel.receiverLocation isEqualToString:receiverLocation]) {
                                      
                                      NSInteger sum = confirmMovedModel.moveAmount.integerValue + amount.integerValue;
                                      
                                      confirmMovedModel.moveAmount = [NSString stringWithFormat:@"%ld", (long)sum];
                                      [self.appDelegate.allowedArray replaceObjectAtIndex:i withObject:confirmMovedModel];
                                      doubledItem = true;
                                      
                                      
                                  }
                              }
                          }
                          
                          
                          
                          if (!doubledItem) {
                              
                              Confirm *confirmModel = nil;
                              confirmModel = [[Confirm alloc] initWithMoveID:moveID
                                                         andWithMoveItemName:itemName
                                                           andWithMoveAmount:amount
                                                       andWithSenderLocation:sendLocation
                                                      andWithReceiveLocation:receiverLocation
                                                           andWithSenderName:senderName
                                                           andWithAcceptTime:[self getCurrentTime]];
                              
                              
                              [self.appDelegate.allowedArray addObject:confirmModel];
                              
                          }
                          
                          
    //-------     }
                          
                          
                          [self.setIndexPathArray addObject:indexPath];
                          [cell acceptedState];
                          NSArray *array = @[@"1", @"0"];
                          [self.viewChanged replaceObjectAtIndex:indexPath.row withObject:array];
                          
                      });
                  } else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hide:YES];
                          [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                      });
                  }
                  
              }
                andFailBlock:^(NSError *error) {
                    [hud hide:YES];
                    [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                    
                }];
}

- (void) rejectAction:(UIButton *)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    ConfirmTVC *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow = indexPath.row;
    
    Confirm *selectedConfirmModel = self.confirmArray[self.selectedRow];
    
    NSString *moveID = selectedConfirmModel.moveID;
    NSString *itemName = selectedConfirmModel.moveItemName;
    NSString *sendLocation = selectedConfirmModel.senderLocation;
    NSString *receiverLocation = selectedConfirmModel.receiverLocation;
    NSString *amount = selectedConfirmModel.moveAmount;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"Rejecting...";
    [hud show:YES];
    
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    
    [ojoClient itemMoveReject:ITEM_MOVE_REJECT
                    andMoveID:moveID
             andMoveItemName:itemName
               andMoveAmount:amount
           andSenderLocation:sendLocation
         andReceiverLocation:receiverLocation
              andFinishBlock:^(NSArray *data) {
                  NSDictionary *dicData = (NSDictionary*)data;
                  NSString *stateCode = [dicData objectForKey:STATE];
                  if ([stateCode isEqualToString:@"200"]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud hide:YES];
                          [self.setIndexPathArray addObject:indexPath];
                          [cell rejectedState];
                          
                          NSArray *array = @[@"0", @"1"];
                          [self.viewChanged replaceObjectAtIndex:indexPath.row withObject:array];
                          
                      });
                  } else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hide:YES];
                          [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                      });
                  }
              }
                andFailBlock:^(NSError *error) {
                    [hud hide:YES];
                    [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                    
                }];
}

- (IBAction)onReturnAndReport:(id)sender {
    
    
    for (int i = (int)self.setIndexPathArray.count - 1; i >= 0; i--) {
        
        NSIndexPath *path = [self.setIndexPathArray objectAtIndex:i];
        [self.appDelegate.unreadReceivedItemArray removeObjectAtIndex:path.row];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSString *) getCurrentTime{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dateFormatter stringFromDate:now];
    
}


@end
