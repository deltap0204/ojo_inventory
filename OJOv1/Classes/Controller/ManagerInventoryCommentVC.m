//
//  ManagerInventoryCommentVC.m
//  OJOv1
//
//  Created by MilosHavel on 24/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "ManagerInventoryCommentVC.h"
#import "ManagerMainVC.h"
#import "LoginVC.h"
#import "Inventory.h"
#import "Confirm.h"

@interface ManagerInventoryCommentVC ()
@property (weak, nonatomic) IBOutlet UITextView *commentTextArea;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture;

@property (assign, nonatomic) NSInteger select;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *controller;
@property (strong, nonatomic) NSString *location;
@property (assign, nonatomic) BOOL mailVar;
@property (strong, nonatomic) NSString *deviceType;


@end

@implementation ManagerInventoryCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.location = [userDefaults objectForKey:SEL_LOCATION];
    self.titleLabel.text = self.location;
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    self.mailVar = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews{
    self.createButton.layer.cornerRadius = self.createButton.bounds.size.height / 2;
    
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
    [self.createButton setEnabled:YES];
}

- (void) uncheck{
    self.select = 0;
    [self.checkBox setImage:nil forState:UIControlStateNormal];
    [self.createButton setEnabled:NO];
}


- (IBAction)onCreate:(id)sender {
    
    self.comment = self.commentTextArea.text;
    [self saveCommentContent];
//    if ([self.comment isEqualToString:@""]) {
//        [self.view makeToast:@"COMMENT IS EMPTY" duration:1.5 position:CSToastPositionBottom];
//        return;
//    }
// 
//    if (self.select == 1) {
//        
//        
//        
//    }
    
}

#pragma mark - write data at CSV file

- (void) writeData{
    [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
    }
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *name = [LoginVC getLoggedinUser].name;
    NSString *role = [LoginVC getLoggedinUser].role;
    NSString *fileName = @"";
    if ([role isEqualToString:@"2"]) {
        fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.location, @"-", name, @"-", today, @".csv"];
    } else{
        fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.location, @"-", name, @"-", today, @".csv"];
    }
    
    Inventory *inventoryModel;
    
    NSString *writeString = @"";
    for (int i=0; i<[self.reportArray count]; i++) {
        inventoryModel = (Inventory *)self.reportArray[i];
        if (i ==  0) {
            writeString = [NSString stringWithFormat:@"%@, %@, %@%@, %@, %@%@, %@, %@%@, %@, %@%@, %@, %@, %@%@", @"Comment", self.comment, @"\n\n\n" ,@"Location:", self.location, @"\n" , @"report name:", name, @"\n", @"report date:", today, @"\n", @"NO", @"ItemName", @"PAR", @"AMOUNT", @"\n"];
            NSFileHandle *handle;
            handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
            //say to handle where's the file fo write
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            //position handle cursor to the end of file
            [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
        
        writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@", i+1, inventoryModel.itemName, inventoryModel.par , inventoryModel.amount, @"\n"];
        if (i == [self.reportArray count] - 1) {
            writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@", i+1, inventoryModel.itemName, inventoryModel.par , inventoryModel.amount, @"\n\n\n\n"];
        }
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    Confirm *moveAllowModel = nil;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *moveAllowArray = appDelegate.allowedArray;
    
    if (moveAllowArray.count != 0) {
        
        writeString = [NSString stringWithFormat:@"%@, %@%@, %@, %@, %@, %@, %@", @"MovingItem:", @"\n" , @"NO", @"ItemName", @"OriginLocation", @"Amount", @"Migrator", @"\n"];
        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        for (int j = 0; j < moveAllowArray.count; j++) {
            
            moveAllowModel = (Confirm*)moveAllowArray[j];
            writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@",j+1, moveAllowModel.moveItemName, moveAllowModel.senderLocation , moveAllowModel.moveAmount, moveAllowModel.senderName, @"\n"];
            
            if (j == moveAllowArray.count - 1) {
                writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@", j+1, moveAllowModel.moveItemName, moveAllowModel.senderLocation , moveAllowModel.moveAmount, moveAllowModel.senderName];
            }
            
            
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


#pragma mark - get file path

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    /var/mobile/Containers/Data/Application/A65AAA4A-E4CB-4460-A705-17D596ABAEEC/Documents
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"inventory.csv"];
}

#pragma mark - mail sending method

- (void) sendMail:(NSString *)path withFileName:(NSString *)fileName{
    
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:[NSString stringWithFormat:@"%@%@", self.location, @" Inventory report"]];
        NSString *content = @"";
        [mail setMessageBody:content isHTML:YES];
        [mail setToRecipients:@[@"laxojoinventory@gmail.com"]];
        
        
        NSData *myData = [NSData dataWithContentsOfFile:path];
        [mail addAttachmentData:myData
                       mimeType:@"text/csv"
                       fileName:fileName];
        
        [self presentViewController:mail animated:YES completion:NULL];
    
    } else{
        [self.view makeToast:@"Sorry, Please connect e-mail at this device!" duration:1.5 position:CSToastPositionBottom];
    }

    

}



- (void) saveCommentContent{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient  sharedWebClient];
        [ojoClient addComment:COMMENT_URL
              andLocationName:self.location
            andCommentContent:self.comment
               andFinishBlock:^(NSArray *data) {
                   NSDictionary *dicData = (NSDictionary*) data;
                   NSString *stateCode = [dicData objectForKey:STATE];
                   if ([stateCode isEqualToString:@"200"]) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [hud hide:YES];
                           [self writeData];
                       });
                   } else{
                       [hud hide:YES];
                       [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                       
                   }
                   
        } andFailBlock:^(NSError *error) {
            [hud hide:YES];
            [self.view makeToast:@"PLEASE CHECK INTERNECT CONNECTION" duration:1.5 position:CSToastPositionBottom];
            
        }];
    });
}

- (void) redirect{
    ManagerMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"managerPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];

}

- (IBAction)gestureAction:(id)sender {
    [self.commentTextArea resignFirstResponder];
}

#pragma mark - mail option delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
        {
            self.mailVar = YES;
    
            [self dismissViewControllerAnimated:YES completion:NULL];
            NSString *identifier = @"";
            
            if([self.deviceType isEqualToString:@"iPad"]) identifier = @"managerPage_ipad";
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
