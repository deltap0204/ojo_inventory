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

@end

@implementation ConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confirmArray = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.confirmArray = appDelegate.movedArray;
    self.tableView.delaysContentTouches = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.currentLocation = [userDefaults objectForKey:SEL_LOCATION];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
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
    
    [confirmCell acceptState];
    [confirmCell rejectState];
    
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
    NSString *itemName = cell.itemName.text;
    NSString *sendLocation = cell.fromLocation.text;
    NSString *senderName = cell.sender.text;
    
    NSString *receiverLocation = cell.receiver.text;
    if ([receiverLocation isEqualToString:@""]) {
        receiverLocation = self.currentLocation;
    }
    
    NSString *amount = cell.movingAmount.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"Accepting...";
    [hud show:YES];
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient itemMoveAllow:ITEM_MOVE_ALLOW
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
                          Confirm *confirmModel = nil;
                          confirmModel = [[Confirm alloc] initWithMoveItemName:itemName
                                                             andWithMoveAmount:amount
                                                         andWithSenderLocation:sendLocation
                                                        andWithReceiveLocation:receiverLocation
                                                             andWithSenderName:senderName
                                                             andWithAcceptTime:[self getCurrentTime]];
                          
                          AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                          [appDelegate.allowedArray addObject:confirmModel];
                          [cell acceptedState];
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
    NSString *itemName = cell.itemName.text;
    NSString *sendLocation = cell.fromLocation.text;
    NSString *receiverLocation = cell.receiver.text;
    if ([receiverLocation isEqualToString:@""]) {
        receiverLocation = self.currentLocation;
    }
    
    NSString *amount = cell.movingAmount.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"Rejecting...";
    [hud show:YES];
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient itemMoveReject:ITEM_MOVE_REJECT
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
                          [cell rejectedState];
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
