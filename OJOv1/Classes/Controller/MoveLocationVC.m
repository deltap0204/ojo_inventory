//
//  MoveLocationVC.m
//  OJOv1
//
//  Created by MilosHavel on 27/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "MoveLocationVC.h"
#import "Location.h"
#import "LocationTVC.h"
#import "LoginVC.h"
#import "MoveItemListVC.h"

@interface MoveLocationVC ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSArray *locationControllerArray;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString *deviceType;



@end

@implementation MoveLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /*
     *  role = 2 stock manager
     *  role = 3 night manager
     */
    
    NSString *role = [LoginVC getLoggedinUser].role;
    if ([role isEqualToString:@"2"]) {
        self.locationArray = @[@"NEVERAS", @"ALMACEN", @"BAR LAX", @"BAR CENTRAL", @"BAR VIP", @"BAR OFFICE", @"BAR RED BULL", @"BAR DJ", @"COCINA", @"EVENTO"];
        self.locationControllerArray = @[@"neveras", @"almacens", @"bar_laxis", @"bar_centrals", @"bar_vips", @"bar_offices",@"bar_redbulls", @"bar_djs", @"bar_carpas", @"bar_eventos"];
        
    } else{
        self.locationArray = @[@"NEVERAS", @"ALMACEN", @"BAR LAX", @"BAR CENTRAL", @"BAR VIP", @"BAR OFFICE", @"BAR RED BULL", @"BAR DJ", @"COCINA", @"EVENTO"];
        self.locationControllerArray = @[@"neveras", @"almacens", @"bar_laxis", @"bar_centrals", @"bar_vips", @"bar_offices",@"bar_redbulls", @"bar_djs", @"bar_carpas", @"bar_eventos"];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    
    CGFloat fontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 40.0f;
    else fontSize = 20.0f;
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    [self.viewButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:20.0]];
//    [self.viewButton setTitle:@"\uf06e" forState:UIControlStateNormal];
//    [self.viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"locationCell";
    LocationTVC *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //    Location *locationModel;
    //    locationModel = (Location*) self.locationArray[indexPath.row];
    cell.locationNameLabel.text = self.locationArray[indexPath.row];
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"gotoMoveItemList" sender:tableView];    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (sender != nil) {
        MoveItemListVC *viewController = (MoveItemListVC*)segue.destinationViewController;
        NSString *selectedLocation = self.locationArray[self.selectedRow];
        NSString *selectedLocationController = self.locationControllerArray[self.selectedRow];
        viewController.receivelocation = selectedLocation;
        viewController.locationController = selectedLocationController;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:selectedLocationController forKey:CONTROLLER];
        [userDefault setObject:selectedLocation forKey:SEL_LOCATION];
        
    }
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onView:(id)sender {
    
}

@end
