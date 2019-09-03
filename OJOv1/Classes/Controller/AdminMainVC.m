//
//  AdminMainVC.m
//  OJOv1
//
//  Created by MilosHavel on 04/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AdminMainVC.h"
#import "LoginVC.h"


@interface AdminMainVC ()
@property (weak, nonatomic) IBOutlet UIButton *userSettingButon;
@property (weak, nonatomic) IBOutlet UIButton *inventorySettingButton;
@property (weak, nonatomic) IBOutlet UIButton *categorySettingButton;
@property (weak, nonatomic) IBOutlet UIButton *itemSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordUpdateButton;
@property (weak, nonatomic) IBOutlet UIView *passwordChangeView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *viewCloseButton;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (strong, nonatomic) NSString *currentPassword;
@property (strong, nonatomic) NSString *updatePassword;
@property (strong, nonatomic) NSString *confirmPassword;
@property (strong, nonatomic) NSString *currentUsername;



@end

@implementation AdminMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.passwordChangeView setHidden:YES];
    self.currentUsername = [LoginVC getLoggedinUser].username;
    
}


- (void) viewDidLayoutSubviews{
    
    self.userSettingButon.layer.cornerRadius = self.userSettingButon.bounds.size.height / 2 ;
    self.inventorySettingButton.layer.cornerRadius = self.inventorySettingButton.bounds.size.height / 2;
    self.categorySettingButton.layer.cornerRadius = self.categorySettingButton.bounds.size.height / 2;
    self.itemSettingButton.layer.cornerRadius = self.itemSettingButton.bounds.size.height / 2;
    
    [self.logoutButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.logoutButton setTitle:@"\uf08b" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor colorWithRed:115.0/255.0 green:159.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    self.oldPasswordTextFeild.layer.cornerRadius = self.oldPasswordTextFeild.bounds.size.height / 2;
    self.passwordTextFeild.layer.cornerRadius = self.passwordTextFeild.bounds.size.height / 2;
    self.confirmPasswordTextFeild.layer.cornerRadius = self.confirmPasswordTextFeild.bounds.size.height / 2;
    
    self.changeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.changeButton.layer.borderWidth = 1.0;
    self.changeButton.layer.cornerRadius = self.changeButton.bounds.size.height / 2;
    

    
    [self.passwordUpdateButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:35.0]];
    [self.passwordUpdateButton setTitle:@"\uf13e" forState:UIControlStateNormal];
    [self.passwordUpdateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - server connection method

- (void) changePassword{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClient = [OJOClient sharedWebClient];
        [ojoClient changeAdminPassword:CHANGE_ADMIN_PASS
                           andUsername:self.currentUsername
                        andOldPassword:self.currentPassword
                        andNewPassword:self.updatePassword
                              onFinish:^(NSArray *data) {
                                  NSDictionary *dicData = (NSDictionary *)data;
                                  NSString *stateCode = [dicData objectForKey:STATE];
                                  if ([stateCode isEqualToString:@"200"]) {
                                      [hud hide:YES];
                                      [self.view makeToast:@"Success Password Change !" duration:1.5 position:CSToastPositionCenter];
                                  } else{
                                      [hud hide:YES];
                                      [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                                  }
                              }
                                onFail:^(NSError *error) {
                                    
                                    [hud hide:YES];
                                    [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                                    
                                }];
    });
}

#pragma mark - button action method

- (IBAction)onUpdate:(id)sender {
    [self.passwordChangeView setHidden:NO];
     
}



- (IBAction)onUser:(id)sender {
}

- (IBAction)onInventory:(id)sender {
}

- (IBAction)onCatetory:(id)sender {
}

- (IBAction)onItem:(id)sender {
}
- (IBAction)onLogout:(id)sender {
    LoginVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:svc animated:YES completion:nil];
}

- (IBAction)onPasswordChange:(id)sender {
    self.currentPassword = self.oldPasswordTextFeild.text;
    self.updatePassword = self.passwordTextFeild.text;
    self.confirmPassword = self.confirmPasswordTextFeild.text;
    [self keyboardHiddenAction];
    
    if ([self.currentPassword isEqualToString:@""]) {
        [self.panelView makeToast:@"Please Insert Current Password" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.updatePassword isEqualToString:@""]) {
        [self.panelView makeToast:@"Please Insert New Password" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.confirmPassword isEqualToString:@""]) {
        [self.panelView makeToast:@"Please Insert Confirm Password" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if (![self.confirmPassword isEqualToString:self.updatePassword]) {
        [self.panelView makeToast:@"No Match With NewPasswod and ConfirmPassword" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [self changeViewHidden];
    [self changePassword];
    
}


- (IBAction)onViewClose:(id)sender {
    [self changeViewHidden];
    [self keyboardHiddenAction];
}

- (void) changeViewHidden{

    [self.passwordChangeView setHidden:YES];
    self.oldPasswordTextFeild.text = @"";
    self.passwordTextFeild.text = @"";
    self.confirmPasswordTextFeild.text = @"";
}

- (IBAction)tabGestureAction:(id)sender {
    [self keyboardHiddenAction];
}


- (void) keyboardHiddenAction{
    [self.oldPasswordTextFeild resignFirstResponder];
    [self.passwordTextFeild resignFirstResponder];
    [self.confirmPasswordTextFeild resignFirstResponder];

}


@end
