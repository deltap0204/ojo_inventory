//
//  AddDeviceVC.m
//  OJOv1
//
//  Created by MilosHavel on 25.11.2019.
//  Copyright © 2019 MilosHavel. All rights reserved.
//

#import "AddDeviceVC.h"
#import "PulsingHaloLayer.h"


@interface AddDeviceVC ()

@property (weak, nonatomic) PulsingHaloLayer *halo;
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothLogo;
@property (weak, nonatomic) IBOutlet UITableView *deviceListTableView;
@property (strong, nonatomic) NSMutableArray *deviceList;

@end

@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // basic setup
    
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    [self.bluetoothLogo.superview.layer insertSublayer:self.halo below:self	.bluetoothLogo.layer];
        
    
    [self setupInitialValues];
    
    [self.halo start];
    
    
}


- (void)setupInitialValues {
    
    UIColor *color = [UIColor colorWithRed:255.0/255.0
    green:255.0/255.0
     blue:255.0/225.0
    alpha:1.0];
    
    [self.halo setBackgroundColor:color.CGColor];
        self.halo.haloLayerNumber = 5;
    self.halo.radius = 150.0;
    self.halo.animationDuration = 5.0;
        
}



#pragma mark - Button Action methods

- (IBAction)onBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
