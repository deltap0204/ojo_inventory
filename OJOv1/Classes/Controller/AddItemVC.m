//
//  AddItemVC.m
//  OJOv1
//
//  Created by MilosHavel on 14/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "AddItemVC.h"
#import "UITextField+PaddingLabel.h"
#import "ItemMainVC.h"
#import "ACFloatingTextField.h"
#import "CategoryMainVC.h"
#import "Category.h"

@interface AddItemVC () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryButton;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *wetFullBottleTextFeild;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *wetEmptyBottleTextFeild;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *wetLiquidTextFeild;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *servingPerBottleTextFeild;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *wetServingTextFeild;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *salePriceTextFeild;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UIButton *creatItemButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *categorySelectView;

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *categoryStr;
@property (strong, nonatomic) NSString *wetFullBottle;
@property (strong, nonatomic) NSString *wetEmpBottle;
@property (strong, nonatomic) NSString *wetLiquid;
@property (strong, nonatomic) NSString *sevPerBottle;
@property (strong, nonatomic) NSString *wetServing;
@property (strong, nonatomic) NSString *salePrice;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSString *pickerResultString;
@property (assign, nonatomic) NSInteger fullAndOpen;


@end

@implementation AddItemVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self textFieldInitialize];
    [self.categorySelectView setHidden:YES];
    [self loadAllCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textFieldInitialize{
    [self.itemNameTextField setTextFieldPlaceholderText:@"ITEM NAME"];
    self.itemNameTextField.placeHolderColor = [UIColor whiteColor];
    self.itemNameTextField.selectedPlaceHolderColor = [UIColor whiteColor];
    self.itemNameTextField.lineColor = [UIColor clearColor];
    
    [self.wetFullBottleTextFeild setTextFieldPlaceholderText:@"WEIGHT FULL BOTTLE"];
    self.wetFullBottleTextFeild.placeHolderColor = [UIColor whiteColor];
    self.wetFullBottleTextFeild.selectedPlaceHolderColor = [UIColor whiteColor];
    self.wetFullBottleTextFeild.lineColor = [UIColor clearColor];
    
    [self.wetEmptyBottleTextFeild setTextFieldPlaceholderText:@"WEIGHT EMPTY BOTTLE"];
    self.wetEmptyBottleTextFeild.placeHolderColor = [UIColor whiteColor];
    self.wetEmptyBottleTextFeild.selectedPlaceHolderColor = [UIColor whiteColor];
    self.wetEmptyBottleTextFeild.lineColor = [UIColor clearColor];
    
    [self.wetLiquidTextFeild setTextFieldPlaceholderText:@"WEIGHT LIQUID"];
    self.wetLiquidTextFeild.placeHolderColor = [UIColor whiteColor];
    self.wetLiquidTextFeild.selectedPlaceHolderColor = [UIColor whiteColor];
    self.wetLiquidTextFeild.lineColor = [UIColor clearColor];
    
    [self.servingPerBottleTextFeild setTextFieldPlaceholderText:@"SERVING PER BOTTLE"];
    self.servingPerBottleTextFeild.placeHolderColor = [UIColor whiteColor];
    self.servingPerBottleTextFeild.selectedPlaceHolderColor = [UIColor whiteColor];
    self.servingPerBottleTextFeild.lineColor = [UIColor clearColor];
    
    [self.wetServingTextFeild setTextFieldPlaceholderText:@"WEIGHT SERVING"];
    self.wetServingTextFeild.placeHolderColor = [UIColor whiteColor];
    self.wetServingTextFeild.selectedPlaceHolderColor = [UIColor whiteColor];
    self.wetServingTextFeild.lineColor = [UIColor clearColor];
    
    [self.salePriceTextFeild setTextFieldPlaceholderText:@"SALES PRICE"];
    self.salePriceTextFeild.placeHolderColor = [UIColor whiteColor];
    self.salePriceTextFeild.selectedPlaceHolderColor = [UIColor whiteColor];
    self.salePriceTextFeild.lineColor = [UIColor clearColor];
}

- (void) viewDidLayoutSubviews{
    
    CGFloat radius = self.itemNameTextField.bounds.size.height / 2;
    self.itemNameTextField.layer.cornerRadius = radius;
    self.chooseCategoryButton.layer.cornerRadius = radius;
    self.wetFullBottleTextFeild.layer.cornerRadius = radius;
    self.wetEmptyBottleTextFeild.layer.cornerRadius = radius;
    self.wetLiquidTextFeild.layer.cornerRadius = radius;
    self.servingPerBottleTextFeild.layer.cornerRadius = radius;
    self.wetServingTextFeild.layer.cornerRadius = radius;
    self.salePriceTextFeild.layer.cornerRadius = radius;
    self.creatItemButton.layer.cornerRadius = radius;
    
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:35.0]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void) loadAllCategory{
    CategoryMainVC *cmc = [[CategoryMainVC alloc] init];
    [cmc loadAllData];
    self.categoryArray = cmc.categoryArray;
    
//    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//    [self.categoryArray sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
 
    
    [self.categoryArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Category *item1 = (Category *)obj1;
        Category *item2 = (Category *)obj2;
        return [item2.categoryName localizedCaseInsensitiveCompare:item1.categoryName];
    }];
    
}


- (IBAction)onBack:(id)sender {
//    ItemMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemMainPage"];
//    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentViewController:svc animated:YES completion:nil];
    [self dismissViewControllerAnimated:true completion:nil];
}




- (IBAction)onChooseCategory:(id)sender {
    [self.categoryPickerView reloadAllComponents];
    [self.categorySelectView setHidden:NO];
    [self keyboardHiddenEvent];
}

- (void) keyboardHiddenEvent{
    [self.itemNameTextField resignFirstResponder];
    [self.wetLiquidTextFeild resignFirstResponder];
    [self.wetFullBottleTextFeild resignFirstResponder];
    [self.wetEmptyBottleTextFeild resignFirstResponder];
    [self.servingPerBottleTextFeild resignFirstResponder];
    [self.wetServingTextFeild resignFirstResponder];
    [self.salePriceTextFeild resignFirstResponder];
}

- (IBAction)tabGestureEvent:(id)sender {
    [self keyboardHiddenEvent];
}

- (IBAction)onCreateItem:(id)sender {
    self.itemName = self.itemNameTextField.text;
    self.categoryStr = self.chooseCategoryButton.titleLabel.text;
    self.wetFullBottle = self.wetFullBottleTextFeild.text;
    self.wetEmpBottle = self.wetEmptyBottleTextFeild.text;
    self.wetLiquid = self.wetLiquidTextFeild.text;
    self.sevPerBottle = self.servingPerBottleTextFeild.text;
    self.wetServing = self.wetServingTextFeild.text;
    self.salePrice = self.salePriceTextFeild.text;
    
    
    if ([self.itemName isEqualToString:@""]) {
        [self.view makeToast:@"PLEASE INSERT ITEM NAME !" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.categoryStr isEqualToString:@"CHOOSE CATEGORY"]) {
        [self.view makeToast:@"PLEASE CHOOSE THE CATEGORY!" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.wetFullBottle isEqualToString:@""]) {
        [self.view makeToast:@"INSERT WEIGHT FULL BOTTLE!" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.wetEmpBottle isEqualToString:@""]) {
        [self.view makeToast:@"INSERT WEIGHT EMPTY BOTTLE!" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.sevPerBottle isEqualToString:@""]) {
        [self.view makeToast:@"INSERT SERVING PER BOTTLE!" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.salePrice isEqualToString:@""]) {
        [self.view makeToast:@"INSERT SALES PRICE!" duration:1.0 position:CSToastPositionCenter];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient addItem:ADD_ITEM
           andItemName:self.itemName
       andItemCategory:self.categoryStr
          andBtFullWet:self.wetFullBottle
           andBtEmpWet:self.wetEmpBottle
             andLiqWet:self.wetLiquid
             andServBt:self.sevPerBottle
            andServWet:self.wetServing
              andPrice:self.salePrice
         onFinishBlock:^(NSArray *data) {
             
             NSDictionary *dicData = (NSDictionary *)data;
             NSString *stateCode = [dicData objectForKey:STATE];
             [hud hide:YES];
             if(![stateCode isEqualToString:@"200"]){
                 
                 [self.view makeToast:[dicData objectForKey:MESSAGE] duration:2.5 position:CSToastPositionCenter];
             } else{
                 
                 [self gotoItemMainPage];
                 
             }
        
    } onFailBlock:^(NSError *error) {
        [hud hide:YES];
        [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
    }];
}


- (void) gotoItemMainPage{
    ItemMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"itemMainPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:svc animated:YES completion:nil];
}


#pragma mark  UITextfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)onCategorySelectViewDone:(id)sender {
    [self.categorySelectView setHidden:YES];
    if (self.fullAndOpen == 1) {
        [self labelDisabled:YES];
    }
    if (self.fullAndOpen == 0) {
        [self labelDisabled:NO];
    }
}

- (void) labelDisabled:(BOOL) value{
    [self.wetFullBottleTextFeild setEnabled:value];
    [self.wetEmptyBottleTextFeild setEnabled:value];
    [self.wetLiquidTextFeild setEnabled:value];
    [self.servingPerBottleTextFeild setEnabled:value];
    [self.wetServingTextFeild setEnabled:value];
    
    if (!value) {
        [self.wetFullBottleTextFeild setText:@"0"];
        [self.wetEmptyBottleTextFeild setText:@"0"];
        [self.wetLiquidTextFeild setText:@"0"];
        [self.servingPerBottleTextFeild setText:@"1"];
        [self.wetServingTextFeild setText:@"0"];
        
    } else{
        [self.wetFullBottleTextFeild setText:@""];
        [self.wetEmptyBottleTextFeild setText:@""];
        [self.wetLiquidTextFeild setText:@""];
        [self.servingPerBottleTextFeild setText:@""];
        [self.wetServingTextFeild setText:@""];
    }
    
    
}

#pragma mark  UIPickerView Delegate method

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return self.categoryArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Category *categoryModel;
    categoryModel = (Category*)self.categoryArray[row];
    
    return categoryModel.categoryName;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Category *categoryModel;
    categoryModel = (Category*)self.categoryArray[row];
    self.pickerResultString = categoryModel.categoryName;
    self.fullAndOpen = categoryModel.fullAndOpen;
    [self.chooseCategoryButton setTitle:self.pickerResultString forState:UIControlStateNormal];
    
}
- (IBAction)wwetEmptyBottleAction:(UITextField *)sender {
    
    int liqWet = [self.wetFullBottleTextFeild.text intValue] - [sender.text intValue];
    NSString *liqWetStr = [NSString stringWithFormat:@"%d", liqWet];
    self.wetLiquidTextFeild.text = liqWetStr;
    
}
- (IBAction)servingPerBottleAction:(UITextField *)sender {
    
    int servBottle = [sender.text intValue];
    int wetLiq = [self.wetLiquidTextFeild.text intValue];
    long wetServing = roundl(wetLiq/servBottle);
    self.wetServingTextFeild.text = [NSString stringWithFormat:@"%ld", wetServing];
    
}


@end
