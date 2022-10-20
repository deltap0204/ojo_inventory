//
//  BLEClient.m
//  OJOv1
//
//  Created by MilosHavel on 07.05.2020.
//  Copyright © 2020 MilosHavel. All rights reserved.
//

#import "BLEClient.h"
#import "BLEDefines.h"


@implementation BLEClient

  
@synthesize delegate;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;



+ (id) sharedBLEClient {
    static BLEClient *instance;
    @synchronized(self) {
        if (instance == nil) {
            instance = [BLEClient new];
        }
    }
    return instance;
}

-(void) readRSSI {
    [activePeripheral readRSSI];
}

-(void) read {
    CBUUID *uuid_service = [CBUUID UUIDWithString:@RBL_SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@RBL_CHAR_TX_UUID];
    
    [self readValue:uuid_service characteristicUUID:uuid_char p:activePeripheral];
}

-(void) write:(NSData *)d {
    CBUUID *uuid_service = [CBUUID UUIDWithString:@RBL_SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@RBL_CHAR_RX_UUID];
    
    [self writeValue:uuid_service characteristicUUID:uuid_char p:activePeripheral data:d];
}



- (void) enableReadNotification:(CBPeripheral *)p {

}


-(void) notification:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        for(int j=0; j < s.characteristics.count; j++) {
            CBCharacteristic *c = [s.characteristics objectAtIndex:j];
            if (c.properties == CBCharacteristicPropertyRead) {
                [p readValueForCharacteristic:c];
            }
            if (c.properties == (CBCharacteristicPropertyNotify | CBCharacteristicPropertyIndicate)) {
                [p setNotifyValue:on forCharacteristic:c];
            }
            
            
        }
    }
}

-(NSString *) CBUUIDToString:(CBUUID *) cbuuid; {
    NSData *data = cbuuid.data;
    
    if ([data length] == 2) {
        const unsigned char *tokenBytes = [data bytes];
        return [NSString stringWithFormat:@"%02x%02x", tokenBytes[0], tokenBytes[1]];
    } else if ([data length] == 16) {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDBytes:[data bytes]];
        return [nsuuid UUIDString];
    }
    
    return [cbuuid description];
}

-(void) readValue: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p {
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service) {
        //NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic) {
        //NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:characteristicUUID], [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        
        return;
    }
    
    [p readValueForCharacteristic:characteristic];
}

-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service) {
        //NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic) {
        //NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:characteristicUUID], [self CBUUIDToString:serviceUUID], p.identifier.UUIDString);
        
        return;
    }
    
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (void) controlSetup {
    if (self.CM == nil) {
        self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (int) findBLEPeripherals:(int)timeout {
    
    if (self.CM.state != CBCentralManagerStatePoweredOn) {
        return -1;
    }
    
    [self.CM scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"1910"]] options:nil];
    
    if (self.deviceModels != nil && self.deviceModels.count > 0 && self.peripherals != nil && self.peripherals.count > 0) {
        [self.deviceModels removeAllObjects];
        for (int pIndex = 0; pIndex < self.peripherals.count; pIndex ++) {
            CBPeripheral *peripheral = self.peripherals[pIndex];
            BLEDeviceModel *devModel = [[BLEDeviceModel alloc] initWithDeviceIdentifier:[NSString stringWithFormat:@"%@", peripheral.identifier] andName:peripheral.name andConnected:peripheral.state];
            [self.deviceModels addObject:devModel];
        }
        [self.delegate bleDidFoundDevices:self.deviceModels];
    }
//    [self.CM scanForPeripheralsWithServices:nil options:nil];
 
    return 0; // Started scanning OK !
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [[self delegate] bleDidDisconnect:peripheral];
}

- (void) connectPeripheral:(BLEDeviceModel *)peripheral {
    for (int i = 0; i < self.peripherals.count; i ++) {
        CBPeripheral *p = [self.peripherals objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@", p.identifier] isEqualToString:peripheral.deviceID]) {
            self.activePeripheral = p;
            self.activePeripheral.delegate = self;
        //    [self.CM connectPeripheral:self.activePeripheral
        //                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];

            [self.CM connectPeripheral:self.activePeripheral
                               options:nil];
            break;
        }
    }
}

- (void) disConnectPeripheral:(BLEDeviceModel *)peripheral {
//    [[self.bleClient CM] cancelPeripheralConnection:p]
    for (int i = 0; i < self.peripherals.count; i ++) {
        CBPeripheral *p = [self.peripherals objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@", p.identifier] isEqualToString:peripheral.deviceID]) {
            
            [self.CM cancelPeripheralConnection:p];
            break;
        }
    }
}

- (const char *) centralManagerStateToString: (int)state {
    switch(state) {
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}

- (void)scanTimer:(NSTimer *)timer {
    [self.CM stopScan];
}

- (BOOL)UUIDSAreEqual:(NSUUID *)UUID1 UUID2:(NSUUID *)UUID2 {
    if ([UUID1.UUIDString isEqualToString:UUID2.UUIDString])
        return TRUE;
    else
        return FALSE;
}


- (CBCharacteristic *)findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService *)service {
//    for(int i=0; i < service.characteristics.count; i++) {
//        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
//        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
//    }
//
//    return nil; //Characteristic not found on this service
    return [service.characteristics objectAtIndex:0];
}

#if TARGET_OS_IPHONE
    //-- no need for iOS
#else
- (BOOL)isLECapableHardware {
    NSString * state = nil;
    
    switch ([CM state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
            
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
            
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return TRUE;
            
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
            
    }
    
    //NSLog(@"Central manager state: %@", state);
        
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:state];
    [alert addButtonWithTitle:@"OK"];
    [alert setIcon:[[NSImage alloc] initWithContentsOfFile:@"AppIcon"]];
    [alert beginSheetModalForWindow:nil modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    return FALSE;
}
#endif

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [[self delegate] bleDidUpdatedState:central];
#if TARGET_OS_IPHONE
    //NSLog(@"Status of CoreBluetooth central manager changed %d (%s)", (int)central.state, [self centralManagerStateToString:central.state]);
#else
    [self isLECapableHardware];
#endif
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    
    if ((peripheral.name != NULL && [peripheral.name containsString:@"Etekcity"]) || (peripheral.name != NULL && [peripheral.name containsString:@"Beurer"])){
        BOOL isAdd = YES;
        if (!self.deviceModels) {
            BLEDeviceModel *devModel = [[BLEDeviceModel alloc] initWithDeviceIdentifier:[NSString stringWithFormat:@"%@", peripheral.identifier] andName:peripheral.name andConnected:NO];
            self.deviceModels = [[NSMutableArray alloc] initWithObjects:devModel, nil];
            self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral, nil];
        } else {
            for(int i = 0; i < self.deviceModels.count; i++) {
                BLEDeviceModel *p = [self.deviceModels objectAtIndex:i];

                if ((p.deviceID == NULL) || (peripheral.identifier == NULL))
                    continue;
                if ([p.deviceID isEqualToString:[NSString stringWithFormat:@"%@", peripheral.identifier]]) {
                    BLEDeviceModel *dev1 = [[BLEDeviceModel alloc] initWithDeviceIdentifier:[NSString stringWithFormat:@"%@", peripheral.identifier] andName:peripheral.name andConnected:peripheral.state];
                    [self.deviceModels replaceObjectAtIndex:i withObject:dev1];
                    [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                    isAdd = NO;
                }
            }
            if (isAdd) {
                BLEDeviceModel *dev1 = [[BLEDeviceModel alloc] initWithDeviceIdentifier:[NSString stringWithFormat:@"%@", peripheral.identifier] andName:peripheral.name andConnected:peripheral.state];
                [self.deviceModels addObject:dev1];
                [self.peripherals addObject:peripheral];
            }

        }

        [[self delegate] bleDidFoundDevices:self.deviceModels];
    }
//    [self connectPeripheral:peripheral];
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    self.activePeripheral = peripheral;
//    [self.activePeripheral discoverServices:nil];
    [peripheral discoverServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"1910"]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (!error) {
        for (int i=0; i < peripheral.services.count; i++) {
            CBService *s = [peripheral.services objectAtIndex:i];
            //        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
            [peripheral discoverCharacteristics:nil forService:s];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
            
        for(int j=0; j < service.characteristics.count; j++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:j];
            if (c.properties == CBCharacteristicPropertyRead) {
                [peripheral readValueForCharacteristic:c];
            }
            if (c.properties == (CBCharacteristicPropertyNotify | CBCharacteristicPropertyIndicate)) {
                [peripheral setNotifyValue:YES forCharacteristic:c];
            }
        }
        
        [[self delegate] bleDidConnect:peripheral];
            
    } else {
        //NSLog(@"Characteristic discorvery unsuccessful!");
    }
}



- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"sssss");
    if (!error) {
        //        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
    } else {
        //NSLog(@"Error in setting notification state for characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:characteristic.UUID], [self CBUUIDToString:characteristic.service.UUID], peripheral.identifier.UUIDString);
        
        //NSLog(@"Error code was %s", [[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (!error) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2C12"]]) {
            
            if (characteristic.value.length == 12) {
                NSData *data1 = characteristic.value;

                UInt8 buf1[data1.length]; // local stack array
                [data1 getBytes:buf1 length:data1.length];
                
                int weight = (NSInteger) buf1[7] * 256 + (NSInteger)buf1[8];
                
                
                [[self delegate] bleDidReceiveWeight:round(weight / 10)];
            }
        }
    }
}


@end
