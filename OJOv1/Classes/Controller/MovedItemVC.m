//
//  MovedItemVC.m
//  OJOv1
//
//  Created by MilosHavel on 29/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "MovedItemVC.h"
#import "MovedItemTVC.h"
#import "MoveItem.h"


@interface MovedItemVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *movedItemArray;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString *deviceType;

@end

@implementation MovedItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.deviceType = [userDefaults objectForKey:DEVICETYPE];
    CGFloat fontSize = 0.0f;
    if ([self.deviceType isEqualToString:@"iPad"]) fontSize = 38.0f;
    else fontSize = 20.0f;
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:fontSize]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.movedItemArray = appDelegate.movedTempArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - UItableView method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.movedItemArray.count;
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellItentifier = @"movedItemCell";
    MovedItemTVC *movedCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    MoveItem *moveItemModel;
    
    moveItemModel = (MoveItem *)self.movedItemArray[indexPath.row];
    
    movedCell.movedItemNameLabel.text = moveItemModel.moveItemName;
    movedCell.sendLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"ORIGIN : ", moveItemModel.sendLocation];
    movedCell.receiveLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"TARGET : ", moveItemModel.receiveLocation];
    movedCell.movedAmountLabel.text = [NSString stringWithFormat:@"%@%@", @"MOVE AMOUNT : ", moveItemModel.moveAmount];
    
    movedCell.backgroundColor = movedCell.contentView.backgroundColor;
    return movedCell;
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
}


@end
