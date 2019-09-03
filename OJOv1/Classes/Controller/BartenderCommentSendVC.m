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
    
    
    
    if ([self.invtType isEqualToString:@"start"]) {
        self.inventoryTypeLabel.text = @"START";
        self.navigationView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:128.0/255.0 blue:74.0/255.0 alpha:1.0];
    }
    else if ([self.invtType isEqualToString:@"shift"]) {
        self.inventoryTypeLabel.text = @"SHIFT";
        self.navigationView.backgroundColor = [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0];
    } else {
        self.inventoryTypeLabel.text = @"END";
        self.navigationView.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:51.0/255.0 blue:30.0/255.0 alpha:1.0];
    }

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
    NSString *startTime = appDelegate.startTime;
    NSString *endTime = appDelegate.endTime;
    NSString *currentUserName = [LoginVC getLoggedinUser].username;
    NSString *preUserName = appDelegate.preUserName;
    
    //    NSMutableArray *reportArray = appDelegate.bartInventoryArray;
    //    NSMutableArray *moveAllowArray = appDelegate.allowedArray;
    
    
    NSMutableArray *startReport = appDelegate.startReport;
    NSMutableArray *shiftReport = appDelegate.shiftReport;
    StartReportModel *startReportModel = nil;
    ShiftReportModel *shiftReportModel = nil;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.invtType, @"_", location, @"_", today, @".csv"];
//    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", self.location, @"_", today, @"_", self.invtType, @"_", currentUserName, @".csv"];
    NSString *writeString = @"";
    
    
    /*
     |_________________|
     | START INVENTORY |
     |_________________|
     */
    
    
    if ([self.invtType isEqualToString:@"start"]) {
        
        //-----------------------------------------------n,------n,------n-,-----n,------n,------n,------n,------n,------------------------------n
        writeString = [NSString stringWithFormat:@"%@,%@,%@%@,%@,%@%@,%@,%@%@,%@,%@%@,%@,%@%@,%@,%@%@,%@,%@%@,%@,%@%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",
                       
                       @"#Inventory type:", @"Start IV", @"\n" ,
                       @"#location:", location, @"\n",
                       @"#name:", currentUserName, @"\n",
                       @"#Before User", preUserName, @"\n",
                       @"#Date:", today, @"\n",
                       @"#StartTime:", startTime, @"\n",
                       @"#EndTime:", endTime, @"\n",
                       @"", @"", @"\n",
                       @"NO", @"ItemName", @"Move", @"Origin", @"Time", @"Full", @"Open",  @"CheckFull", @"CheckOpen", @"MtP", @"\n"];
        
        
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        
        for (int i = 0; i < startReport.count; i++) {
            startReportModel = (StartReportModel*)startReport[i];
            
            /*
             
             || "NO" || "ItemName" || "Amount" || "Origin" || "Time" || "Full" || "Open" ||  "CheckFull" || "CheckOpen" || "MtP" || "\n"
             
             */
            
            
            writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
                           
                           i+1, startReportModel.itemName, startReportModel.movingAmount , startReportModel.movingOrigin, startReportModel.movingTime, startReportModel.itemFull, startReportModel.itemOpen, startReportModel.itemFullCheck, startReportModel.itemOpenCheck, startReportModel.missingToPar, @"\n"];
            
            
            NSFileHandle *handle;
            handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
            //say to handle where's the file fo write
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            //position handle cursor to the end of file
            [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    /*
     |_________________|
     | SHIFT INVENTORY |
     |_________________|
     */
    
    
    else if ([self.invtType isEqualToString:@"shift"]){
        
        
        //----------------------------------------(--1--)-(--2--)-(--3--)-(--4--)-(--5--)-(--6--)-(--7--)-(-----------------8-----------------)-
        writeString = [NSString stringWithFormat:@"%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,\n%@,%@,%@%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,\n",
                       
                       @"#Inventory type:", @"Shift IV",  //1
                       @"#location:", location,           //2
                       @"#name:", currentUserName,        //3
                       @"#Before User:", preUserName,      //4
                       @"#Date:", today,                  //5
                       @"#StartTime:", startTime,         //6
                       @"#EndTime:", endTime,             //7
                       @"#TotalCash:", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", self.totalCash,     //8
                       @"      ", @"     ", @"\n",               //9
                       @"NO", @"ItemName", @"ItemPrice", @"LiquidWeight", @"Move", @"Origin", @"Time", @"Full", @"Open",  @"MtP", @"SS", @"CashDetail", @"LIGHTSPEED"];
        
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath]];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        
        for (int i = 0; i < shiftReport.count; i++) {
            shiftReportModel = (ShiftReportModel *) shiftReport[i];
        
            /*
             
             || "NO" || "ItemName" || "Amount" || "Origin" || "Time" || "Full" || "Open" ||  "MtP" || "SS" || "CashDetail" || "\n"
             
             
             new
             || "NO" || "ItemName" || ItemPrice || LiquidWeight || "Move" || "Origin" || "Time" || "Full" || "Open" ||  "MtP" || "SS" || "CashDetail" || LIGHTSPEED
             
             
             */
            
            writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
                           
                           i+1,
                           shiftReportModel.itemName,
                           shiftReportModel.itemPrice,
                           shiftReportModel.liquidWeight,
                           shiftReportModel.movingAmount ,
                           shiftReportModel.movingOrigin,
                           shiftReportModel.movingTime,
                           shiftReportModel.itemFull,
                           shiftReportModel.itemOpen,
                           shiftReportModel.missingToPar,
                           shiftReportModel.servingSold,
                           shiftReportModel.cashDetail,
                           @"         ",@"\n"];
            
            NSFileHandle *handle;
            handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
            //say to handle where's the file fo write
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            //position handle cursor to the end of file
            [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }
    
    
    /*
     
     |_________________|
     | END INVENTORY   |
     |_________________|
     
     */
    
    
    else{
        
        
        //----------------------------------------(--1--)-(--2--)-(--3--)-(--4--)-(--5--)-(--6--)-(--7--)-(-----------------8-----------------)-
        writeString = [NSString stringWithFormat:@"%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,\n%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,\n%@,%@,%@%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,\n",
                       
                       @"#Inventory type:", @"End IV",    //1
                       @"#location:", location,           //2
                       @"#name:", currentUserName,        //3
                       @"#Before User:", preUserName,      //4
                       @"#Date:", today,                  //5
                       @"#StartTime:", startTime,         //6
                       @"#EndTime:", endTime,             //7
                       @"#TotalCash:", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", self.totalCash,     //8
                       @"      ", @"     ", @"\n",               //9
                       @"NO", @"ItemName", @"ItemPrice", @"LiquidWeight", @"Move", @"Origin", @"Time", @"Full", @"Open",  @"MtP", @"SS", @"CashDetail", @"LIGHTSPEED"];
        
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        
        for (int i = 0; i < shiftReport.count; i++) {
            shiftReportModel = (ShiftReportModel *) shiftReport[i];
            
            /*
             
             || "NO" || "ItemName" || "Amount" || "Origin" || "Time" || "Full" || "Open" ||  "MtP" || "SS" || "CashDetail" || "\n"
             
             
             new
             || "NO" || "ItemName" || ItemPrice || LiquidWeight || "Move" || "Origin" || "Time" || "Full" || "Open" ||  "MtP" || "SS" || "CashDetail" || LIGHTSPEED
             
             
             */
            
            writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
                           
                           i+1,
                           shiftReportModel.itemName,
                           shiftReportModel.itemPrice,
                           shiftReportModel.liquidWeight,
                           shiftReportModel.movingAmount ,
                           shiftReportModel.movingOrigin,
                           shiftReportModel.movingTime,
                           shiftReportModel.itemFull,
                           shiftReportModel.itemOpen,
                           shiftReportModel.missingToPar,
                           shiftReportModel.servingSold,
                           shiftReportModel.cashDetail,
                           @"       ",@"\n"];
            
            
            
            NSFileHandle *handle;
            handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
            //say to handle where's the file fo write
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            //position handle cursor to the end of file
            [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
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
        [mail setToRecipients:@[@"laxojoinventory@gmail.com"]];
        
        
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
