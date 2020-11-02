//
//  BLEClient.h
//  OJOv1
//
//  Created by MilosHavel on 07.05.2020.
//  Copyright © 2020 MilosHavel. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BLEDeviceModel.h"
#if TARGET_OS_IPHONE
    #import <CoreBluetooth/CoreBluetooth.h>
#else
    #import <IOBluetooth/IOBluetooth.h>
#endif

@protocol BLEDelegate

@optional

-(void) bleDidConnect:(CBPeripheral *)peripheral;
-(void) bleDidDisconnect:(CBPeripheral *)peripheral;
//-(void) bleDidDisconnect:(NSError *)error;
-(void) bleDidUpdateRSSI:(NSNumber *)rssi;
-(void) bleDidReceiveWeight:(int) weight;
-(void) bleDidUpdatedState: (CBCentralManager *)central;
-(void) bleDidFoundDevices: (NSMutableArray *)peripherals;

@required
@end



@interface BLEClient : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
    
}


@property (nonatomic,assign) id <BLEDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *deviceModels;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) CBPeripheral *activePeripheral;

+(id) sharedBLEClient;

-(void) enableReadNotification:(CBPeripheral *)p;
-(void) read;
-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data;

-(BOOL) isConnected;
-(void) write:(NSData *)d;
-(void) readRSSI;

-(void) controlSetup;
-(int) findBLEPeripherals:(int) timeout;
-(void) connectPeripheral:(BLEDeviceModel *)peripheral;
-(void) disConnectPeripheral:(BLEDeviceModel *)peripheral;

-(UInt16) swap:(UInt16) s;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;





@end


