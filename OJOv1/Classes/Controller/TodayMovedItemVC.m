	//
//  TodayMovedItemVC.m
//  OJOv1
//
//  Created by MilosHavel on 09/05/2017.
//  Copyright © 2017 MilosHavel. All rights reserved.
//

#import "TodayMovedItemVC.h"
#import "TodayMovedItemTVC.h"
#import "TodayMovedItemModel.h"
#import "LoginVC.h"
#import "ManagerMainVC.h"

@interface TodayMovedItemVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setViewSeg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

// date string ("dd-MM-yyyy")
@property (assign, nonatomic) NSInteger dayInt;
@property (assign, nonatomic) NSInteger monthInt;
@property (assign, nonatomic) NSInteger yearInt;
// available day
@property (assign, nonatomic) NSInteger avaNum;

@property (strong, nonatomic) NSMutableArray *todayMovedItemArray;
@property (strong, nonatomic) NSMutableArray *acceptedArray;
@property (strong, nonatomic) NSMutableArray *rejectedArray;
@property (strong, nonatomic) NSMutableArray *pendingArray;
@property (strong, nonatomic) NSMutableArray *allArray;

// device type
@property (strong, nonatomic) NSString *deviceType;

@end

@implementation TodayMovedItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.todayMovedItemArray = [[NSMutableArray alloc] init];
    self.allArray = [[NSMutableArray alloc] init];
    self.acceptedArray = [[NSMutableArray alloc] init];
    self.rejectedArray = [[NSMutableArray alloc] init];
    self.pendingArray = [[NSMutableArray alloc] init];
    
    // set the time label
    NSString *today = [self getCurrentTimeString];
    self.todayLabel.text = today;
    
    // get the date ("MM-dd-yyyy")
    NSArray* dateArray = [today componentsSeparatedByString: @"-"];
    self.monthInt = [[dateArray objectAtIndex: 0] integerValue];
    self.dayInt = [[dateArray objectAtIndex: 1] integerValue];
    self.yearInt = [[dateArray objectAtIndex: 2] integerValue];
    
    // get the device type
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    self.avaNum = 3;
    [self.nextButton setEnabled:NO];
    [self loadAllData:today];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Server connect method

- (void) loadAllData: (NSString *)dateStr {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        [ojoClient searchTodayMovedItem:TODAY_MOVE_TIME_URL
                          andDateString:dateStr
                               onFinish:^(NSArray *data) {
            NSDictionary *dicData = (NSDictionary *) data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                NSInteger count = response.count;
                
                self.todayMovedItemArray = [[NSMutableArray alloc] init];
                self.allArray = [[NSMutableArray alloc] init];
                self.acceptedArray = [[NSMutableArray alloc] init];
                self.rejectedArray = [[NSMutableArray alloc] init];
                self.pendingArray = [[NSMutableArray alloc] init];
                
                TodayMovedItemModel *movedModel = nil;
                
                for (int i = 0; i < count ; i++) {
                    
                    NSDictionary *resultDict = (NSDictionary *)response[i];
                    NSString *movedItemName = [resultDict objectForKey:MOVE_ITEM_NAME];
                    NSString *movedAmount = [resultDict objectForKey:MOVE_ITEM_AMOUNT];
                    NSString *movedUsername = [resultDict objectForKey:SENDER_NAME];
                    NSString *originLocation = [resultDict objectForKey:SENDER_LOCATION];
                    NSString *targetLocation = [resultDict objectForKey:RECEIVER_LOCATION];
                    NSString *movedTimeAgo = [resultDict objectForKey:MOVED_TIME];
                    NSString *movedStatus = [resultDict objectForKey:MOVE_STATUS];
                    
                    movedModel = [[TodayMovedItemModel alloc] initWithMovedItemName:movedItemName
                                                             andWithMovedItemAmount:movedAmount
                                                                andWithMovedTimeAgo:movedTimeAgo
                                                               andWithMovedUsername:movedUsername
                                                               andWithOrginLocation:originLocation
                                                              andWithTargetLocation:targetLocation
                                                                 andWithMovedStatus:movedStatus];
                    [self.todayMovedItemArray addObject:movedModel];
                    
                    NSInteger readStatus = movedStatus.integerValue;
                    switch (readStatus) {
                        case 0: // pending
                            [self.pendingArray addObject:movedModel];
                            break;
                        case 1: // accepted
                            [self.acceptedArray addObject:movedModel];
                            break;
                        case 2: // rejected
                            [self.rejectedArray addObject:movedModel];
                            break;
                        default:
                            
                            break;
                    }

                }
                
                self.allArray = [NSMutableArray arrayWithArray:self.todayMovedItemArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [hud hide:YES];
                });
                
            } else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:(NSString*)[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                    [hud hide:YES];
                });
                
            }
            
        } onFail:^(NSError *error) {
            [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
            [hud hide:YES];
        }];
        
    });
    
}

#pragma mark - UITableVIew Delegate and Datasource Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.todayMovedItemArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellItentifier = @"todayMovedItemTableViewCell";
    TodayMovedItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    TodayMovedItemModel *movedModel;
    movedModel = (TodayMovedItemModel *) self.todayMovedItemArray[indexPath.row];
    
    cell.movedItemNameLabel.text = movedModel.movedItemName;
    cell.movedAmountLabel.text = movedModel.movedItemAmount;
    cell.movedTimeLabel.text = [NSString stringWithFormat:@"%@ by %@", movedModel.movedTimeAgo, movedModel.movedUsername];
    cell.orginLocationLabel.text = [NSString stringWithFormat:@"ORIGIN : %@", movedModel.movedOrginLocation];
    cell.targetLocationLabel.text = [NSString stringWithFormat:@"TARGET : %@", movedModel.movedTargetLocation];
    
    NSInteger status = movedModel.movedStatus.integerValue;
    switch (status) {
        case 0: // pending
            cell.cellView.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:239.0/255.0 blue:67.0/255.0 alpha:0.57];
            cell.movedStatus.image = [UIImage imageNamed:@"pending"];
            break;
        case 1: // accept
            cell.cellView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:173.0/255.0 blue:17.0/255.0 alpha:0.57];
            cell.movedStatus.image = [UIImage imageNamed:@"accepted"];
            break;
        case 2: // reject
            cell.cellView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:91.0/255.0 blue:82.0/255.0 alpha:0.57];
            cell.movedStatus.image = [UIImage imageNamed:@"rejected"];
            
            break;
        default:
            break;
    }
    
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
    
}


#pragma mark - Segument Controller method

- (IBAction)onSegAction:(id)sender {
    
//    [self.todayMovedItemArray removeAllObjects];
    self.todayMovedItemArray = [NSMutableArray new];
    
    switch ([sender selectedSegmentIndex]) {
        case 0: // All
            self.todayMovedItemArray = self.allArray;
            [self.tableView reloadData];
            break;
        case 1: // Accepted
            self.todayMovedItemArray = self.acceptedArray;
            [self.tableView reloadData];
            
            break;
        case 2: // Rejected
            self.todayMovedItemArray = self.rejectedArray;
            [self.tableView reloadData];
            
            break;
        case 3: // Pending
            self.todayMovedItemArray = self.pendingArray;
            [self.tableView reloadData];
            
            break;
        default:
            
            break;
    }
    
    
}

- (NSString*) getCurrentTimeString{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *inputTimeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"MM-dd-yyyy";
    dateFormatter.timeZone = inputTimeZone;
    
    return [dateFormatter stringFromDate:now];
}

#pragma mark - Controller close and send mail action


- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSend:(id)sender {
    // send the reprot to admin (todayMovedItemArray)
    [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = self.todayLabel.text;
    NSString *name = [LoginVC getLoggedinUser].name;
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@%@", @"MovedItems", name, today, @".csv"];
    
    TodayMovedItemModel *movedModel;
    NSString *writeString = @"";
    for (int i=0; i<[self.todayMovedItemArray count]; i++){
        movedModel = (TodayMovedItemModel*) self.todayMovedItemArray[i];
        if (i == 0) {
            writeString = [NSString stringWithFormat:@"%@, %@\n%@, %@\n%@, %@, %@, %@, %@, %@, %@\n", @"Reporter", name, @"Date", today, @"NO", @"ItemName", @"Origin", @"Target", @"Amount", @"Mover", @"Status"];
            NSFileHandle *handle;
            handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
            //say to handle where's the file fo write
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            //position handle cursor to the end of file
            [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSString *status = @"";
        switch (movedModel.movedStatus.intValue) {
            case 0: // pending
                status = @"Pending";
                break;
            case 1:
                status = @"Accept";
                break;
            case 2:
                status = @"Reject";
                break;
            default:
                break;
        }
        
        writeString = [NSString stringWithFormat:@"%d, %@, %@,%@, %@, %@, %@ \n", i, movedModel.movedItemName,  movedModel.movedOrginLocation, movedModel.movedTargetLocation, movedModel.movedItemAmount, movedModel.movedUsername, status];
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //  ---------------  send the email with file ---------------
    NSString *path = [self dataFilePath];
    [self sendMail:path withFileName:fileName];
}

- (void) sendMail:(NSString *)path withFileName:(NSString *)fileName{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        NSString *name = [LoginVC getLoggedinUser].name;
        NSString *subject = [NSString stringWithFormat:@"%@%@", name, @" Stock Refill Report"];
        [mail setSubject:subject];
        
        NSString *content = @"Moved Items.";
        [mail setMessageBody:content isHTML:YES];
        [mail setToRecipients:@[@"laxojoinventory@gmail.com"]];
        
        
        NSData *myData = [NSData dataWithContentsOfFile:path];
        [mail addAttachmentData:myData
                       mimeType:@"text/csv"
                       fileName:fileName];
        [self presentViewController:mail
                           animated:YES
                         completion:NULL];
        
    } else{
        [self.view makeToast:@"Sorry, Please connect e-mail at this device!" duration:1.5 position:CSToastPositionBottom];
    }
    
}

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    /var/mobile/Containers/Data/Application/A65AAA4A-E4CB-4460-A705-17D596ABAEEC/Documents
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"stock_refill.csv"];
}



#pragma mark - Date choose action
- (void)clearData{
    self.todayMovedItemArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (IBAction)onPrevious:(id)sender {
    [self clearData];
    [self.setViewSeg setSelectedSegmentIndex:0];
    self.avaNum = self.avaNum - 1;
    [self.nextButton setEnabled:YES];
    if (self.avaNum == 1) {
        [self.previousButton setEnabled:NO];
    }

    if (self.dayInt == 1) {
        // Now it's 5-1, 7-1, 10-1, 12-1
        if (self.monthInt == 5 || self.monthInt == 7 || self.monthInt == 10 || self.monthInt == 12){
            //  4-30 , 6-30 , 9-30 , 11-30
            self.dayInt = 30;
            self.monthInt = self.monthInt - 1;
        }
        // Now it's 3-1
        else if (self.monthInt == 3){
            // 2-28
            self.dayInt = 28;
            self.monthInt = 2;
        }
        // Now it's 1-1
        else if (self.monthInt == 1){
            self.monthInt = 12;
            self.yearInt = self.yearInt - 1;
            self.dayInt = 31;
        }
        // Now it's 2-1 , 4-1 , 6-1 , 8-1 , 9-1 , 11-1
        else {
            //  1-31 , 3-31 , 5-31 , 7-31 , 8-31, 10-31
            self.dayInt = 31;
            self.monthInt = self.monthInt - 1;
        }
        
    } else {
        self.dayInt = self.dayInt - 1;
    }
    
    [self updateDateString];
    [self loadAllData:self.todayLabel.text];
}

- (IBAction)onNext:(id)sender {
    [self clearData];
    [self.setViewSeg setSelectedSegmentIndex:0];
    
    [self.previousButton setEnabled:YES];
    self.avaNum = self.avaNum + 1;
    if (self.avaNum == 3) {
        [self.nextButton setEnabled:NO];
    }
    if (self.monthInt == 1 || self.monthInt == 3 || self.monthInt == 5 || self.monthInt == 7 || self.monthInt == 8 || self.monthInt == 10 || self.monthInt == 12) {
        if (self.dayInt == 31 && self.monthInt == 12){
            self.dayInt = 1;
            self.monthInt = 1;
            self.yearInt = self.yearInt + 1;
        } else if (self.dayInt == 31 && self.monthInt != 12){
            self.monthInt = self.monthInt + 1;
            self.dayInt = 1;
        }
        else{
            self.dayInt = self.dayInt + 1;
        }
    
    } else if(self.monthInt == 2){
        if (self.dayInt == 28){
            self.dayInt = 1;
            self.monthInt = 3;
        } else{
            self.dayInt = self.dayInt + 1;
        }
    
    } else{
        if (self.dayInt == 30){
            self.dayInt = 1;
            self.monthInt = self.monthInt +1;
        } else{
            self.dayInt = self.dayInt + 1;
        }
    }
    
    [self updateDateString];
    [self loadAllData:self.todayLabel.text];
}

- (void) updateDateString{
    NSInteger dayLeng = [[NSString stringWithFormat:@"%ld", (long)self.dayInt] length];
    NSInteger monthLeng = [[NSString stringWithFormat:@"%ld", (long)self.monthInt] length];
    NSString *dayStr = @"";
    NSString *monthStr = @"";
    if (dayLeng == 1) dayStr = [NSString stringWithFormat:@"0%ld", (long)self.dayInt];
    else dayStr = [NSString stringWithFormat:@"%ld", (long)self.dayInt];
    
    if (monthLeng == 1) monthStr = [NSString stringWithFormat:@"0%ld", (long)self.monthInt];
    else monthStr = [NSString stringWithFormat:@"%ld", (long)self.monthInt];
        

    
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%ld", monthStr, dayStr, (long)self.yearInt];
    self.todayLabel.text = dateString;
}


#pragma mark - mail option delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
        {
            [self dismissViewControllerAnimated:YES completion:NULL];
            NSString *identifier = @"";
            if ([self.deviceType isEqualToString:@"iPad"]) identifier = @"managerPage_ipad";
            else identifier = @"managerPage";
            
            ManagerMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
            [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [self presentViewController:svc animated:YES completion:nil];
            break;
        }
            
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
