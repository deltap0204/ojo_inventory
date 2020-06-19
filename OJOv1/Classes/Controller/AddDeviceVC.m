//
//  AddDeviceVC.m
//  OJOv1
//
//  Created by MilosHavel on 25.11.2019.
//  Copyright © 2019 MilosHavel. All rights reserved.
//

#import "AddDeviceVC.h"

#define CONNECTION_RETRIES 4

@interface AddDeviceVC ()

@property (strong, nonatomic) BLEClient *bleClient;
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothLogo;
@property (weak, nonatomic) IBOutlet UITableView *deviceListTableView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) PulsingHaloLayer *halo;
@property (strong, nonatomic) NSMutableArray *deviceList;
@property (strong, nonatomic) CBCentralManager *myCentralManager;
@property (strong, nonatomic) CBPeripheral *sensorTag;

@property (assign, nonatomic) BOOL scaleConnected;
@property (assign, nonatomic) BOOL scaleScanning;
@property (assign, nonatomic) int connectionRetries;


@end


@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.connectionRetries = CONNECTION_RETRIES;
    self.scaleConnected = NO;
    
    // basic setup
    
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    
    [self.bluetoothLogo.superview.layer insertSublayer:self.halo below:self.bluetoothLogo.layer];
    [self setupInitialValues];
    
    [layer start];
    
    
    // BLE search peripheral devices
    
    self.bleClient = [BLEClient sharedBLEClient];
    self.bleClient.delegate = self;
    [self.bleClient controlSetup];
    
    if (self.bleClient.activePeripheral && self.bleClient.activePeripheral.state == CBPeripheralStateConnected) {
        [[self.bleClient CM] cancelPeripheralConnection:[self.bleClient activePeripheral]];
        return;
    }
    
    
    if (self.bleClient.peripherals) {
        self.bleClient.peripherals = nil;
    }

    [self.bleClient findBLEPeripherals:5.0];
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

- (void)connectionTimer:(NSTimer *) timer{
    
    if(self.bleClient.peripherals.count > 1) {
        
    } else if (self.bleClient.peripherals.count) {
        [NSThread sleepForTimeInterval:0.2];
        [self.bleClient connectPeripheral:[self.bleClient.peripherals objectAtIndex:0]];
        
    } else {
        self.connectionRetries = CONNECTION_RETRIES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Scale found. Please make sure that scale is powered on and try to connect again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.halo.position = self.bluetoothLogo.center;
}

- (void)setupInitialValues {
    
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    
    [self.halo setBackgroundColor:color.CGColor];
    self.halo.haloLayerNumber = 3;
    self.halo.radius = 240;
    self.halo.animationDuration = 5;
        
}

#pragma mark - BLE Delegate methods

- (void)bleDidDisconnect:(NSError *)error {
    
    
}

- (void)bleDidConnect {
    
    
}

// When data is comming, this will be called
- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    
    
}



#pragma mark - Button Action methods

- (IBAction)onBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
