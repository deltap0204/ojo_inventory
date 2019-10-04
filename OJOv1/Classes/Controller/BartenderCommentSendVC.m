//
//  BartenderCommentSendVC.m
//  OJOv1
//
//  Created by MilosHavel on 6/12/18.
//  Copyright © 2018 MilosHavel. All rights reserved.
//

#import "BartenderCommentSendVC.h"
#import "BartenderVC.h"
#import "LoginVC.h"
#import "StartReportModel.h"
#import "ShiftReportModel.h"


@interface BartenderCommentSendVC (){
    
    AppDelegate *appDelegate;
    
}

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *invtType;
@property (assign, nonatomic) BOOL mailVar;
@property (strong, nonatomic) NSString *totalCash;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end

@implementation BartenderCommentSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.invtType = appDelegate.inventoryType;
    self.totalCash = appDelegate.totalCash;
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:128.0/255.0 blue:74.0/255.0 alpha:1.0];
    self.inventoryTypeLabel.text = @"";

    _mailVar = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action Method

- (IBAction)onFinishAction:(id)sender {
    
    [self writeReport];
    
}



#pragma mark - Comment & Create Report and Sending

- (void) writeReport{
    
    [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        
    }
    
    NSString *location = [LoginVC getLoggedinUser].location;
    //NSString *startTime = appDelegate.startTime;
    //NSString *endTime = appDelegate.endTime;
    NSString *currentUserName = [LoginVC getLoggedinUser].username;
    //NSString *preUserName = appDelegate.preUserName;
    
    //    NSMutableArray *reportArray = appDelegate.bartInventoryArray;
    //    NSMutableArray *moveAllowArray = appDelegate.allowedArray;
    
    
    NSMutableArray *shiftReport = appDelegate.shiftReport;
    ShiftReportModel *shiftReportModel = nil;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.invtType, @"_", location, @"_", today, @".csv"];
//    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", self.location, @"_", today, @"_", self.invtType, @"_", currentUserName, @".csv"];
    NSString *writeString = @"";
    
    
    /*
     |_________________|
     |   INVENTORY     |
     |_________________|
     */
    
    
    writeString = [NSString stringWithFormat:@"%@,%@,%@  %@,%@,%@   %@,%@,%@  %@,%@,%@   %@,%@,%@  %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                   
                   @"#NAME OF LOCATION", location, @"\n",
                   @"#NAME OF USER", currentUserName, @"\n",
                   @"#DATE:", today, @"\n",
                   @"#TOTAL CASH", self.totalCash, @"\n",
                   @"      ", @"     ", @"\n",
                   
                   @"NO", @"ITEMS", @"PAR", @"PRICE", @"REFILL", @"PRE-FULL", @"PRE-OPEN", @"MOVED IN", @"MOVED OUT", @"FULL", @"OPEN",  @"SS"];
    
    
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath]];
    //say to handle where's the file fo write
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    //position handle cursor to the end of file
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    for (int i = 0; i < shiftReport.count; i++) {
        shiftReportModel = (ShiftReportModel *) shiftReport[i];
        
        /*
         
         || "NO" || "NAME" || "PAR" || "PRICE" || "REFILL" || "FULL" || "OPEN" || "MOVED IN" ||  "MOVED OUT" || "FULL" || "OPEN" || "SS"
         
         
         */
        double parInt = shiftReportModel.itemFull.doubleValue + (-1) * shiftReportModel.missingToPar.doubleValue;

        
        writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
                       // NO
                       i+1,
                       // Item name
                       shiftReportModel.itemName,
                       // PAR
                       [NSString stringWithFormat:@"%ld", (long)parInt],
                       // PRICE
                       shiftReportModel.itemPrice,
                       // REFILL
                       shiftReportModel.missingToPar,
                       // BEFORE FULL
                       shiftReportModel.itemPreFull,
                       // BEFORE OPEN
                       shiftReportModel.itemPreOpen,
                       // MOVE IN
                       shiftReportModel.movedIn,
                       // MOVE OUT
                       shiftReportModel.movedOut,
                       // CURRENT FULL
                       shiftReportModel.itemFull,
                       // CURRENT OPEN
                       shiftReportModel.itemOpen ,
                       // SS
                       shiftReportModel.servingSold,
                       @"         ",@"\n"];
        
        
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    NSString *path = [self dataFilePath];
    [self sendMail:path withFileName:fileName];
}


- (void) sendMail:(NSString *)path withFileName:(NSString *)fileName{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        NSString *subjectName = [NSString stringWithFormat:@"%@%@", self.location, @" Inventory Report"];
        [mail setSubject:subjectName];
        NSString *content = [NSString stringWithFormat:@"%@,%@", @"Comment : ", self.commentTextView.text];
        [mail setMessageBody:content isHTML:YES];
        [mail setToRecipients:@[@"laxojoinventory@gmail.com", @"cuibomb0204@gmail.com"]];
        
        
        NSData *myData = [NSData dataWithContentsOfFile:path];
        [mail addAttachmentData:myData
                       mimeType:@"text/csv"
                       fileName:fileName];
        
        [self presentViewController:mail animated:YES completion:NULL];
        
    }
}

- (void) redirect {
    BartenderVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"bartenderPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:svc animated:YES completion:nil];
    
}

#pragma mark - Method for sending mail

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    /var/mobile/Containers/Data/Application/A65AAA4A-E4CB-4460-A705-17D596ABAEEC/Documents
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"bartender_inventory.csv"];
}

#pragma mark - MFMailComposeViewControllerDelegate Method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
        {
            NSLog(@"You sent the email.");
            _mailVar = YES;
            [self dismissViewControllerAnimated:YES completion:NULL];

            BartenderVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
            [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
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





- (void) saveCommentContent{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient  sharedWebClient];
        [ojoClient addComment:COMMENT_URL
              andLocationName:self.location
            andCommentContent:self.commentTextView.text
               andFinishBlock:^(NSArray *data) {
                   
                   NSDictionary *dicData = (NSDictionary*) data;
                   NSString *stateCode = [dicData objectForKey:STATE];
                   if ([stateCode isEqualToString:@"200"]) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [hud hide:YES];
                           [self writeReport];
                       });
                   } else {
                       [hud hide:YES];
                       [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                   }
               } andFailBlock:^(NSError *error) {
                   [hud hide:YES];
                   [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionBottom];
               }];
        
    });
}




@end
