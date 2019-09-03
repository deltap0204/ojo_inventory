//
//  AddUserVC.m
//  OJOv1
//
//  Created by MilosHavel on 07/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AddUserVC.h"
#import "UserMainVC.h"
#import "Location.h"
#import "LocationTVC.h"

@interface AddUserVC ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *fullNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roleSeg;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *locationView;

@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSString *selectedLocation;
@property (assign, nonatomic) NSInteger selctedSeg;

@end

@implementation AddUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *color = [UIColor whiteColor];
    self.fullNameLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"FULL NAME" attributes:@{NSForegroundColorAttributeName:color}];
    self.emailLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-MAIL" attributes:@{NSForegroundColorAttributeName:color}];
    self.usernameLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName:color}];
    self.passwordLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName:color}];

    [self.locationView setHidden:YES];
    
    if ([self.fromVC isEqualToString:@"edit"]) {
        [self.titleLabel setText:@"EDIT USER"];
        self.fullNameLabel.text = self.selectedUser.name;
        self.emailLabel.text = self.selectedUser.email;
        self.passwordLabel.text = self.selectedUser.password;
        self.usernameLabel.text = self.selectedUser.username;
        [self.createButton setTitle:@"EDIT" forState:UIControlStateNormal];
        NSString *role = self.selectedUser.role;

        if ([role isEqualToString:@"1"]) {
            // bartender
            [self.roleSeg setSelectedSegmentIndex:0];
            self.selctedSeg = 0;
            [self loadAllLocation];
            [self.locationButton setTitle:self.selectedUser.location forState:UIControlStateNormal];
        }
        else if ([role isEqualToString:@"2"] || [role isEqualToString:@"3"]){
            //manager
            [self.roleSeg setSelectedSegmentIndex:1];
            self.selctedSeg = 1;
            [self loadAllLocation];
            [self.locationButton setTitle:self.selectedUser.location forState:UIControlStateNormal];
        }
        
        else if ([role isEqualToString:@"4"]){
            //admin
            [self.roleSeg setSelectedSegmentIndex:2];
            [self.locationButton setTitle:@"ALL" forState:UIControlStateNormal];
            self.locationButton.enabled = NO;
        }
        else{
            
        }
    } else{
        [self.createButton setTitle:@"ADD" forState:UIControlStateNormal];
        self.selctedSeg = 0;
        [self loadAllLocation];
    }
    
    
    self.selectedLocation = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewDidLayoutSubviews{
    self.fullNameLabel.layer.cornerRadius = self.fullNameLabel.bounds.size.height / 2;
    self.emailLabel.layer.cornerRadius = self.emailLabel.bounds.size.height / 2;
    self.usernameLabel.layer.cornerRadius = self.usernameLabel.bounds.size.height / 2;
    self.passwordLabel.layer.cornerRadius = self.passwordLabel.bounds.size.height / 2;
    self.locationButton.layer.cornerRadius = self.locationButton.bounds.size.height / 2;
    self.createButton.layer.cornerRadius = self.createButton.bounds.size.height / 2;

    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:50.0]];
    [self.backButton setTitle:@"\uf104" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void) loadAllLocation{
    
    if (self.selctedSeg == 0) {
        // bartender
        self.locationArray = [[NSArray alloc] init];
        self.locationArray = @[@"BAR LAX", @"BAR CENTRAL", @"BAR VIP", @"BAR OFFICE",@"BAR RED BULL",@"BAR DJ",@"COCINA",@"EVENTO"];
    }
    if (self.selctedSeg == 1) {
        // manager
        self.locationArray = [[NSArray alloc] init];
        self.locationArray = @[@"STOCK", @"NEVERAS & ALMACENS"];
    }
    [self.pickerView reloadAllComponents];
}


#pragma mark - button action method


- (IBAction)onBack:(id)sender {
    
//    UserMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"userMainPage"];
//    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentViewController:svc animated:YES completion:nil];
    [self dismissViewControllerAnimated:true completion:nil];

}

- (IBAction)onRole:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0: // bartender
            self.selctedSeg = 0;
            self.locationButton.enabled = YES;
            if ([self.selectedLocation isEqualToString:@""]) {
                [self.locationButton setTitle:@"Location" forState:UIControlStateNormal];
            } else{
                [self.locationButton setTitle:self.selectedLocation forState:UIControlStateNormal];
            }
            [self loadAllLocation];
            break;
        case 1: // manager
            self.selctedSeg = 1;
            self.locationButton.enabled = YES;
            if ([self.selectedLocation isEqualToString:@""]) {
                [self.locationButton setTitle:@"Location" forState:UIControlStateNormal];
            } else{
                [self.locationButton setTitle:self.selectedLocation forState:UIControlStateNormal];
            }
            [self loadAllLocation];
            break;
        case 2: // admin
            self.selctedSeg = 2;
            self.locationButton.enabled = NO;
            [self.locationButton setTitle:@"ALL" forState:UIControlStateNormal];
        default:
            break;
    }
}
- (IBAction)onLocation:(id)sender {
    [self.locationView setHidden:NO];
    
    [self.fullNameLabel resignFirstResponder];
    [self.emailLabel resignFirstResponder];
    [self.usernameLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
}

- (IBAction)onCreate:(id)sender {
    
    NSString *newName = self.fullNameLabel.text;
    NSString *oldName = self.selectedUser.name;
    NSString *username = self.usernameLabel.text;
    NSString *email = self.emailLabel.text;
    NSString *password = self.passwordLabel.text;
    NSString *roleStr = [self getRole];
    NSString *locationStr = self.locationButton.titleLabel.text;
    NSString *location = nil;
    
    
    
    if ([self.fullNameLabel.text isEqualToString:@""]) {
        [self.view makeToast:@"INSERT FULL NAME" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.emailLabel.text isEqualToString:@""]) {
        [self.view makeToast:@"INSERT EMAIL ADDRESS" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.usernameLabel.text isEqualToString:@""]) {
        [self.view makeToast:@"INSERT USERNAME" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.passwordLabel.text isEqualToString:@""]) {
        [self.view makeToast:@"INSERT PASSWORD" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.locationButton.titleLabel.text isEqualToString:@"Location"]) {
        [self.view makeToast:@"SELECT LOCATION" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([locationStr isEqualToString:@"NEVERAS & ALMACENS"]) {
        location = @"night_all";
    }
    
    else if ([locationStr isEqualToString:@"ALL"]) {
        location = @"all";
    }
    else{
        location = locationStr;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    if ([self.fromVC isEqualToString:@"edit"]) {
        // edit user
        [ojoClient editUser:EDIT_USER_URL
                 andOldName:oldName
                andNewName:newName
                andUsername:username
                   andEmail:email
                andPassword:password
                    andRole:roleStr
                andLocation:location
                   onFinish:^(NSArray *data) {
                       NSDictionary *dicData = (NSDictionary *)data;
                       NSString *stateCode = [dicData objectForKey:STATE];
                       [hud hide:YES];
                       if ([stateCode isEqualToString:@"200"]) {
                           [hud hide:YES];
                           [self.view makeToast:@"USER ADD SUCCESS" duration:1.5 position:CSToastPositionCenter];
                           [self gotoUserMainPage];
                       }
                       else{
                           [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionBottom];
                       }
                   } onFail:^(NSError *error) {
                       [hud hide:YES];
                       [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                   }];
    }
    else{
        // add user
        [ojoClient saveUser:ADD_USER
                andFullName:newName
                andUsername:username
                   andEmail:email
                andPassword:password
                    andRole:roleStr
                andLocation:location
                   onFinish:^(NSArray *data) {
                       [hud hide:YES];
                       if (data == nil) {
                           [self.view makeToast:@"DATA NULL" duration:1.5 position:CSToastPositionCenter];
                       }
                       
                       NSDictionary *dicData = (NSDictionary *)data;
                       NSString *stateCode = [dicData objectForKey:STATE];
                       if ([stateCode isEqualToString:@"200"]) {
                           [self.view makeToast:@"USER ADD SUCCESS" duration:1.5 position:CSToastPositionCenter];
                           [self gotoUserMainPage];
                       }
                       else{
                           [self.view makeToast:[dicData objectForKey:MESSAGE] duration:1.5 position:CSToastPositionCenter];
                       }
                   } onFail:^(NSError *error) {
                       [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
                   }];
    }
}

- (NSString *) getRole {
    NSString *role = @"";
    if (self.selctedSeg == 0) { // bartender
        role = @"1";
    }
    if (self.selctedSeg == 1) {
        if ([self.locationButton.titleLabel.text isEqualToString:@"STOCK"]) {
            role = @"2";
        } else{
            role = @"3";
        }
    }
    if (self.selctedSeg == 2) {
        role = @"4";
    }
    return role;

}

- (void) gotoUserMainPage{
    UserMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"userMainPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:svc animated:YES completion:nil];
}


- (IBAction)onGesture:(id)sender {
    [self.fullNameLabel resignFirstResponder];
    [self.emailLabel resignFirstResponder];
    [self.usernameLabel resignFirstResponder];
    [self.passwordLabel resignFirstResponder];
}

- (IBAction)onLocationViewDone:(id)sender {
    
    [self.locationView setHidden:YES];
    
}

#pragma mark  UIPickerView Delegate method

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return self.locationArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.locationArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedLocation = self.locationArray[row];
    [self.locationButton setTitle:self.selectedLocation forState:UIControlStateNormal];
}



@end
