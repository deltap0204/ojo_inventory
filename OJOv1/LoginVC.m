//
//  ViewController.m
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "LoginVC.h"
#import "AdminMainVC.h"
#import "BartenderVC.h"
#import "ManagerMainVC.h"



static User *loggedInUser = nil;

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;




@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIColor *color = [UIColor grayColor];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName:color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName:color}];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceType = [userDefaults objectForKey:DEVICETYPE];
    if ([deviceType isEqualToString:@"iPhone"]) {
        
        [self.usernameTextField setFont:[UIFont systemFontOfSize:13]];
        [self.passwordTextField setFont:[UIFont systemFontOfSize:13]];
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.movedArray = [[NSMutableArray alloc] init];
    appDelegate.movedTempArray = [[NSMutableArray alloc] init];
    appDelegate.allowedArray = [[NSMutableArray alloc] init];
    appDelegate.refilledArray = [[NSMutableArray alloc] init];
    appDelegate.bartInventoryArray = [[NSMutableArray alloc] init];
    

}

- (void) viewDidLayoutSubviews{
    
    self.usernameTextField.layer.cornerRadius = 5.0;
    self.passwordTextField.layer.cornerRadius = 5.0;
    self.usernameTextField.layer.borderWidth = 2.0;
    self.passwordTextField.layer.borderWidth = 2.0;
    self.usernameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.layer.borderWidth = 2.0;
    self.loginButton.layer.borderColor = [UIColor blackColor].CGColor;
}

+ (User *)getLoggedinUser {
    return loggedInUser;
}


- (IBAction)onLogin:(id)sender {
    
    if ([self.usernameTextField.text isEqualToString:@""]) {
        //alert...
        UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Empty Data"
                                        message:@"Please insert your username !"
                                        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK")
                                                            style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action) {
        }];
            
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        //alert...
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Empty Data"
                                    message:@"Please insert your password !"
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Signing...";
    [hud show:YES];
    
    NSString* username = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient loginWithMethod:LOGIN_URL andUsername:username andPassword:password onFinish:^(NSArray *data) {
        NSDictionary *dicData = (NSDictionary *)data;
        NSString *stateCode = [dicData objectForKey:STATE];
        
        if([stateCode isEqualToString:@"200"]){
            
            NSString *name = [dicData objectForKey:NAME];
            NSString *username = self.usernameTextField.text;
            NSString *password = self.passwordTextField.text;
            NSString *email = [dicData objectForKey:EMAIL];
            NSString *role_Id = [dicData objectForKey:ROLE];
            NSString *controller = [dicData objectForKey:CONTROLLER];
            NSString *location = [dicData objectForKey:LOCATION];
            NSString *preUser = [dicData objectForKey:PRENAME];
            NSString *server_time = [dicData objectForKey:SERVER_TIME];
            
            NSArray* dateArray = [server_time componentsSeparatedByString: @"-"];
            NSString* timeString = [dateArray objectAtIndex: 0];
            NSString* minString = [dateArray objectAtIndex:1];
            NSInteger dominicaTime = timeString.integerValue - 4;
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.currentDominicaTime = [NSString stringWithFormat:@"%ld%@%@", (long)dominicaTime, @" : ", minString];
//            bar lax : start 8-16, shift 16-24 and end 0-8
//            other location : start : 8AM - 12 PM   end 12PM - 8AM
            
            if (dominicaTime >= 0 && dominicaTime < 8) {
                appDelegate.inventoryType = @"end";
            } else if (dominicaTime >= 8 && dominicaTime < 16){
                appDelegate.inventoryType = @"start";
            } else if (dominicaTime >= 16 && dominicaTime <= 23){
                if ([location isEqualToString:@"BAR LAX"]) {
                    appDelegate.inventoryType = @"shift";
                } else{
                    appDelegate.inventoryType = @"start";
                }
            }
            
            appDelegate.currentUserName = name;
            appDelegate.preUserName = preUser;
            
            loggedInUser = [[User alloc] initWithName:name
                                      andWithUsername:username
                                      andWithPassword:password
                                         andWithEmail:email
                                          andWithRole:role_Id
                                        andContorller:controller
                                  andWtihWithLocation:location
                                       andWithPreName:preUser];
            
            if ([role_Id isEqualToString:@"1"]) {
                // bartender
                [hud hide:YES];
                if ([deviceType isEqualToString:@"iPad"]) {
                    BartenderVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"bartenderPage_ipad"];
                    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self presentViewController:svc animated:YES completion:nil];
                    
                } else{
                    BartenderVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"bartenderPage"];
                    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self presentViewController:svc animated:YES completion:nil];
                }
                
            }
            
            else if ([role_Id isEqualToString:@"2"] || [role_Id isEqualToString:@"3"]){
                // stock manager or night manger
                [hud hide:YES];
                
                if ([deviceType isEqualToString:@"iPad"]) {
                    ManagerMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"managerPage_ipad"];
                    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self presentViewController:svc animated:YES completion:nil];
                    
                } else{
                    ManagerMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"managerPage"];
                    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                    [self presentViewController:svc animated:YES completion:nil];
                }
                
                
            }
            
            else if ([role_Id isEqualToString:@"4"]){
                // admin
                [hud hide:YES];
                AdminMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"adminPage"];
                [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:svc animated:YES completion:nil];
            }
            
            else{
    
            }
            
        }
        
        else{
            [hud hide:YES];
            [self.view makeToast:[dicData objectForKey:MESSAGE] duration:2.5 position:CSToastPositionCenter];
        }
        
    } onFail:^(NSError *error) {
        [hud hide:YES];
        [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
        
    }];
    
    
    
}

- (void) setInventoryType:(NSString *) serverTime{
    
    
    
}

- (IBAction)onTabGesture:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
