//
//  AddedItemListVC.m
//  OJOv1
//
//  Created by MilosHavel on 27/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AddedItemListVC.h"
#import "AddedItemTVC.h"
#import "Inventory.h"
#import "LoginVC.h"
#import "ManagerMainVC.h"
#import "RefillItem.h"


@interface AddedItemListVC ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSMutableArray *addedItems;
@property (assign, nonatomic) BOOL mailVar;
@property (strong, nonatomic) NSString *deviceType;
@property (strong, nonatomic) NSString *totalPrice;


@end
                 
@implementation AddedItemListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.addedItems = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.addedItems = appDelegate.refilledArray;
    
    // Calculate the total price for refilling on stock
    [self getTotalPrice:self.addedItems];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    CGFloat fontSize = 0.0f;
    
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 35.0f;
    else fontSize = 20.0f;
    
    // back and view button initialize
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.mailVar = NO;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onReport:(id)sender {
    
    [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *name = [LoginVC getLoggedinUser].name;
    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@", @"stock_", name, today, @".csv"];
    
    RefillItem *inventoryModel;
    
    NSString *writeString = @"";
    for (int i=0; i<[self.addedItems count]; i++) {
        inventoryModel = (RefillItem *)self.addedItems[i];
        if (i ==  0) {
            writeString = [NSString stringWithFormat:@"%@, %@, %@%@, %@, %@%@, %@, %@%@, %@, %@%@, %@, %@, %@, %@, %@, %@, %@%@", @"Location:", @"Stock", @"\n" , @"report name:", name, @"\n", @"report date:", today, @"\n", @"TotalPrice:", self.totalPrice, @"\n", @"NO", @"ItemName", @"Distributor", @"Current", @"Refilled", @"PriceTotal", @"PricePerUnit", @"RateOfSale", @"\n"];
            
            NSFileHandle *handle;
            handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
            //say to handle where's the file fo write
            [handle truncateFileAtOffset:[handle seekToEndOfFile]];
            //position handle cursor to the end of file
            [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
        
        writeString = [NSString stringWithFormat:@"%d, %@, %@, %@, %@, %@, %@, %@, %@", i+1, inventoryModel.itemName, inventoryModel.distributor,inventoryModel.currentAmount , inventoryModel.refilledAmount, inventoryModel.priceTotal, inventoryModel.pricePerUnit, inventoryModel.priceRate, @"\n"];

        NSFileHandle *handle;
        handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
        //say to handle where's the file fo write
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        //position handle cursor to the end of file
        [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //  ---------------  initialize the reported array ---------------
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.refilledArray = [[NSMutableArray alloc] init];
    
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
        
        NSString *content = @"I have refilled some items on stock.";
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

- (void) getTotalPrice :(NSMutableArray*) refilledArray{
    NSInteger count = refilledArray.count;
    RefillItem *inventoryModel;
    
    CGFloat s = 0;
    for (int i=0; i<count; i++) {
        inventoryModel = (RefillItem *)refilledArray[i];
        CGFloat price = inventoryModel.priceTotal.floatValue;
        s = s + price;
    }
    
    self.totalPrice = [NSString stringWithFormat:@"%f", s];
    
}

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    /var/mobile/Containers/Data/Application/A65AAA4A-E4CB-4460-A705-17D596ABAEEC/Documents
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"stock_refill.csv"];
}

#pragma mark - UItableView Delegate method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.addedItems.count;
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellItentifier = @"addItemCell";
    AddedItemTVC *addedCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    RefillItem *refilledModel;
    
    refilledModel = (RefillItem *)self.addedItems[indexPath.row];
    addedCell.itemName.text = refilledModel.itemName;
    addedCell.currentAmount.text = [NSString stringWithFormat:@"%@%@", @"CURRENT AMOUNT : ", refilledModel.currentAmount];
    addedCell.addedAmount.text = [NSString stringWithFormat:@"%@%@", @"REFILLED AMOUNT : ", refilledModel.refilledAmount];
    addedCell.totalPriceLabel.text = [NSString stringWithFormat:@"TOTAL PRICE : $%@", refilledModel.priceTotal];
    addedCell.pricePerUnitLabel.text = [NSString stringWithFormat:@"PRICE PER UNIT : $%@", refilledModel.pricePerUnit];
    addedCell.rateOfSaleLabel.text = [NSString stringWithFormat:@"RATE OF SALE : %@", refilledModel.priceRate];
    
    CGFloat fontSize = 0.0;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 20.0;
    else fontSize = 13.0;
    
    [addedCell.distributorLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [addedCell.distributorLabel setText:[NSString stringWithFormat:@"( %@ %@ )", @"\uf041", refilledModel.distributor]];
    
    addedCell.backgroundColor = addedCell.contentView.backgroundColor;
    return addedCell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
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
