//
//  InventoryMainVC.m
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "InventoryMainVC.h"
#import "LocationTVC.h"
#import "Location.h"
#import "AdminMainVC.h"
#import "InventoryListVC.h"

@interface InventoryMainVC ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *locationArray;
@property (strong, nonatomic) NSArray *locationControllerArray;
@property (assign, nonatomic) NSInteger selectedRow;

@end

@implementation InventoryMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationArray = @[@"STOCK",@"NEVERAS", @"ALMACEN", @"BAR LAX", @"BAR CENTRAL", @"BAR VIP", @"BAR OFFICE", @"BAR RED BULL", @"BAR DJ", @"COCINA", @"EVENTO"];
    self.locationControllerArray = @[@"stocks", @"neveras", @"almacens", @"bar_laxis", @"bar_centrals", @"bar_vips", @"bar_offices",@"bar_redbulls", @"bar_djs", @"bar_carpas", @"bar_eventos"];
    
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [self performSegueWithIdentifier:@"gotoInventoryList" sender:tableView];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    InventoryListVC *viewController = (InventoryListVC*)segue.destinationViewController;
    NSString *selectedLocation = self.locationArray[self.selectedRow];
    NSString *selectedLocationController = self.locationControllerArray[self.selectedRow];
    viewController.location = selectedLocation;
    viewController.locationController = selectedLocationController;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:selectedLocationController forKey:CONTROLLER];
    [userDefault setObject:selectedLocation forKey:SEL_LOCATION];

}

- (IBAction)onBackAction:(id)sender {
    AdminMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"adminPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
