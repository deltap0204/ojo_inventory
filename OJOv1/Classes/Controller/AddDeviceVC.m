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

@property (assign, nonatomic) int deviceFindTryCnt;




@end


@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.connectionRetries = CONNECTION_RETRIES;
    self.scaleConnected = NO;
    
    self.deviceFindTryCnt = 0;
    
    // basic setup
    
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    
    [self.bluetoothLogo.superview.layer insertSublayer:self.halo below:self.bluetoothLogo.layer];
    [self setupInitialValues];
    
    self.deviceList = [[NSMutableArray alloc] init];
    
    [layer start];
    
    
    // BLE search peripheral devices
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.bleClient = [BLEClient sharedBLEClient];
    self.bleClient.delegate = self;
    [self.bleClient controlSetup];
    [self.bleClient findBLEPeripherals:5];
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

- (void)bleDidDisconnect:(CBPeripheral *)peripheral{
    for(int i = 0; i < self.deviceList.count; i++) {
        BLEDeviceModel *p = [self.deviceList objectAtIndex:i];
        if ([p.deviceID isEqualToString:[NSString stringWithFormat:@"%@", peripheral.identifier]]) {
            [[self.deviceList objectAtIndex:i] setIsConnected:NO];
            break;
        }
    }
    [self.deviceListTableView reloadData];
}

//- (void)bleDidDisconnect:(NSError *)error {
//    
//    
//}

- (void)bleDidConnect:(CBPeripheral *)peripheral {
    for(int i = 0; i < self.deviceList.count; i++) {
        BLEDeviceModel *p = [self.deviceList objectAtIndex:i];
        if ([p.deviceID isEqualToString:[NSString stringWithFormat:@"%@", peripheral.identifier]]) {
            [[self.deviceList objectAtIndex:i] setIsConnected:YES];
            break;
        }
    }
    [self.deviceListTableView reloadData];
}

// When data is comming, this will be called
-(void) bleDidReceiveWeight:(int)weight {
    
}

- (void)bleDidUpdatedState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.bleClient findBLEPeripherals:5];
    }
}

- (void)bleDidFoundDevices:(NSMutableArray *)peripherals {
    [self.deviceList removeAllObjects];
    for(int i = 0; i < peripherals.count; i++) {
        BLEDeviceModel *p = [peripherals objectAtIndex:i];
//        if (p.name != nil) {
//            [self.deviceList addObject:p];
//        }
        if (p.deviceName != NULL && [p.deviceName containsString:@"Etekcity"]) {
            [self.deviceList addObject:p];
        }

        if (p.deviceName != NULL && [p.deviceName containsString:@"Beurer"]) {
            [self.deviceList addObject:p];
        }
    }
    if ([self.deviceList count] > 0) {
        [self.deviceListTableView reloadData];
    }
    
}


#pragma mark - Button Action methods

- (IBAction)onBackAction:(id)sender {
    self.deviceFindTryCnt = 10;
    self.bleClient.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
//    [NSTimer ]
    
}

#pragma mark - UITableView Delegate Methos

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellItentifier = @"deviceItemCell";
    DeviceTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    [cell setDeviceInfo:self.deviceList[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BLEDeviceModel *p = [self.deviceList objectAtIndex:indexPath.row];
    if (p.isConnected) {
        [self.bleClient disConnectPeripheral:p];
    } else {
        [self.bleClient connectPeripheral:p];
//        [self.bleClient setActivePeripheral:p];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

@end


