//
//  UserMainVC.m
//  OJOv1
//
//  Created by MilosHavel on 06/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "UserMainVC.h"
#import "User.h"
#import "UserTVC.h"
#import "AddUserVC.h"
#import "AdminMainVC.h"



@interface UserMainVC ()

@property (weak, nonatomic) IBOutlet UIButton *addUserButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *totalUsersLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *userArray;
@property (assign, nonatomic) NSInteger selectedRow;


@end

@implementation UserMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userArray = [[NSMutableArray alloc] init];
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:50.0]];
    [self.backButton setTitle:@"\uf104" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.addUserButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.addUserButton setTitle:@"\uf234" forState:UIControlStateNormal];
    [self.addUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self loadAllData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}

- (void) loadAllData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        [ojoClicent getAllUsers:GET_ALL_USER_URL onFinish:^(NSArray *data) {
            
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                
                NSArray *response = (NSArray *)[dicData objectForKey:GET_ALL_USER];
                NSInteger userCount = response.count;
               
                [self.userArray removeAllObjects];
                User *userModel = nil;
                
                for (int i = 0; i < userCount; i++) {
                    NSDictionary *userDict = (NSDictionary *) response[i];
                    NSString *name = [userDict objectForKey:NAME];
                    NSString *username = [userDict objectForKey:USERNAME];
                    NSString *password = [userDict objectForKey:PASSWORD];
                    NSString *email = [userDict objectForKey:EMAIL];
                    NSString *role = [userDict objectForKey:ROLE];
                    NSString *controller = [userDict objectForKey:CONTROLLER];
                    NSString *location = [userDict objectForKey:LOCATION];
                    
                    
                    userModel = [[User alloc] initWithName:name
                                           andWithUsername:username
                                           andWithPassword:password
                                              andWithEmail:email
                                               andWithRole:role
                                             andContorller:controller
                                       andWtihWithLocation:location
                                            andWithPreName:@""];
                    if (![role isEqualToString:@"4"]) {
                        [self.userArray addObject:userModel];
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.tableView reloadData];
                    NSInteger userCount = self.userArray.count;
                    [self.totalUsersLabel setText:[NSString stringWithFormat:@"%ld%@", (long)userCount, @" USERS"]];
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.userArray removeAllObjects];
                    [self.tableView reloadData];
                    NSString *response = [dicData objectForKey:MESSAGE];
                    [self.view makeToast:response duration:2.5 position:CSToastPositionCenter];
                    
                });
            }
            
        } onFail:^(NSError *error) {
            [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
            
        }];
   
    });
    
    
}


#pragma mark - UItableView delegate Method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellItentifier = @"userCell";
    UserTVC *userCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    User *userModel = (User*) self.userArray[indexPath.row];
    
    userCell.usernameLabel.text = userModel.username;
    userCell.fullName.text = userModel.name;
    userCell.passwordLabel.text = userModel.password;
    userCell.emailLabel.text = userModel.email;
    if ([userModel.location isEqualToString:@"night_all"]) {
        userCell.locationLabel.text = @"NE & AL";
    } else{
        userCell.locationLabel.text = userModel.location;
    }
    
    
    NSString *role = userModel.role;
    if ([role isEqualToString:@"1"]) {
        // bartender
        [userCell.roleImageView setImage:[UIImage imageNamed:@"B"]];
    }
    else if ([role isEqualToString:@"2"]){
        // stock manager
        [userCell.roleImageView setImage:[UIImage imageNamed:@"S"]];
        
    }
    else if ([role isEqualToString:@"3"])
    {
        // night manager
        [userCell.roleImageView setImage:[UIImage imageNamed:@"M"]];
    }
    else{
        
    }
    userCell.backgroundColor = userCell.contentView.backgroundColor;
    return userCell;
}



- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
    
        
        User *userModel = nil;
        userModel = self.userArray[indexPath.row];
        UIAlertController *alert = nil;
        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to delete this user ?"
                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                       hud.userInteractionEnabled = NO;
                                                       [hud show:YES];
                                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                           OJOClient *ojoClient = [OJOClient sharedWebClient];
                                                           [ojoClient deleteUser:DELETE_USER_URL
                                                                     andUsername:userModel.username
                                                                        onFinish:^(NSArray *data) {
                                                               NSDictionary *dicData = (NSDictionary *)data;
                                                               NSString *stateCode = [dicData objectForKey:STATE];
                                                               if ([stateCode isEqualToString:@"200"]) {
                                                                   [hud hide:YES];
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   [self.userArray removeObjectAtIndex:indexPath.row];
                                                                   [self.tableView reloadData];
                                                                   
                                                                   NSInteger userCount = self.userArray.count;
                                                                   [self.totalUsersLabel setText:[NSString stringWithFormat:@"%ld%@", (long)userCount, @" USERS"]];
                                                                   
                                                               } else {
                                                                   NSString *errorStr = [dicData objectForKey:MESSAGE];
                                                                   [self.view makeToast:errorStr duration:2.5 position:CSToastPositionCenter];
                                                                   
                                                               }
                                                           } onFail:^(NSError *error) {
                                                               [hud hide:YES];
                                                               [self.view makeToast:@"Please Check Internect Connection" duration:2.5 position:CSToastPositionCenter];
                                                               
                                                           }];
                                                           
                                                       });
         
        }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"addUser" sender:tableView];
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddUserVC *viewController = (AddUserVC*)segue.destinationViewController;
    User *userModel = nil;
    if (sender == self.addUserButton) {

        userModel = [[User alloc] initWithName:@"" andWithUsername:@"" andWithPassword:@"" andWithEmail:@"'" andWithRole:@"" andContorller:@"" andWtihWithLocation:@""andWithPreName:@""];
        
    } else{
        
        userModel = self.userArray[self.selectedRow];
        userModel = [[User alloc] initWithName:userModel.name
                               andWithUsername:userModel.username
                               andWithPassword:userModel.password
                                  andWithEmail:userModel.email
                                   andWithRole:userModel.role
                                 andContorller:userModel.contoller
                           andWtihWithLocation:userModel.location
                                andWithPreName:userModel.preName];
        
    }
    viewController.fromVC = sender == self.addUserButton ? @"add" : @"edit";
    viewController.selectedUser = userModel;
}


- (IBAction)onBack:(id)sender {
    AdminMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"adminPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];
}


- (IBAction)onAddUser:(id)sender {
    self.selectedRow = 1000;
    [self performSegueWithIdentifier:@"addUser" sender:sender];
}



@end
