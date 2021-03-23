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
#import "CategoryMainVC.h"
#import "Category.h"

@interface AddItemVC () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *chooseCategoryButton;
@property (weak, nonatomic) IBOutlet UITextField *wetFullBottleTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *wetEmptyBottleTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *wetLiquidTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *servingPerBottleTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *wetServingTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *salePriceTextFeild;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UIButton *creatOrEditItemButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *categorySelectView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

// -- location choose imageviews
@property (weak, nonatomic) IBOutlet UIImageView *barcentralImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barofficeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barlaxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bardjImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eventoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barvipImageView;

@property (weak, nonatomic) IBOutlet UIView *locationChangeConfirmView;
@property (weak, nonatomic) IBOutlet UILabel *locationChangeCausionLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationChangeParTextField;
@property (weak, nonatomic) IBOutlet UIButton *locationChangeConfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *locationChangeCancelButton;


@property (assign, nonatomic) BOOL barcentralSelected;
@property (assign, nonatomic) BOOL barofficeSelected;
@property (assign, nonatomic) BOOL barlaxSelected;
@property (assign, nonatomic) BOOL stockSelected;
@property (assign, nonatomic) BOOL bardjSelected;
@property (assign, nonatomic) BOOL eventoSelected;
@property (assign, nonatomic) BOOL barvipSelected;

@property (strong, nonatomic) NSString *selectedLoctionString;
@property (strong, nonatomic) NSString *requestStatus;

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
    
    [self.locationChangeConfirmView setHidden:YES];
    
    self.itemNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ITEM NAME" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if ([self.fromVC isEqualToString:@"edit"]) {
        
        self.itemNameTextField.text = self.selectedItem.itemName;
        [self.chooseCategoryButton setTitle:self.selectedItem.categoryName forState:UIControlStateNormal];
        self.wetFullBottleTextFeild.text = self.selectedItem.btFullWet;
        self.wetEmptyBottleTextFeild.text = self.selectedItem.btEmpWet;
        self.wetLiquidTextFeild.text = self.selectedItem.liqWet;
        self.wetServingTextFeild.text = self.selectedItem.servWet;
        self.servingPerBottleTextFeild.text = self.selectedItem.servBt;
        self.salePriceTextFeild.text = self.selectedItem.price;
        
        NSString *imageNameWithUpper = [self.selectedItem.itemName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        NSString *imageName = [imageNameWithUpper lowercaseString];
        self.itemImageView.image = [UIImage imageNamed:imageName];
        if (self.itemImageView.image == nil) {
            self.itemImageView.image = [UIImage imageNamed:@"coming_soon"];
        }
        
        for (int i = 0; i < self.selectedItem.activedLocationArray.count; i++) {
            
            NSString *activeLocation = (NSString*)self.selectedItem.activedLocationArray[i];
            
            if ([activeLocation isEqual:@"BAR CENTRAL"]) {
                self.barcentralImageView.image = [UIImage imageNamed:@"location_selected"];
                self.barcentralSelected = YES;
            } else if([activeLocation isEqual:@"BAR OFFIC"]) {
                self.barofficeImageView.image = [UIImage imageNamed:@"location_selected"];
                self.barofficeSelected = YES;
            } else if([activeLocation isEqual:@"BAR LAX"]){
                self.barlaxImageView.image = [UIImage imageNamed:@"location_selected"];;
                self.barlaxSelected = YES;
            } else if([activeLocation isEqual:@"STOCK"]){
                self.stockImageView.image = [UIImage imageNamed:@"location_selected"];;
                self.stockSelected  = YES;
            } else if([activeLocation isEqual:@"BAR DJ"]){
                self.bardjImageView.image = [UIImage imageNamed:@"location_selected"];
                self.bardjSelected = YES;
            } else if([activeLocation isEqual:@"EVENTO"]){
                self.eventoImageView.image = [UIImage imageNamed:@"location_selected"];;
                self.eventoSelected = YES;
            } else if([activeLocation isEqual:@"BAR VIP"]){
                self.barvipImageView.image = [UIImage imageNamed:@"location_selected"];
                self.barvipSelected = YES;
            } else {
                NSLog(@"Not active location now");
            }
            
        }
        } else {
            // AddView
            
            [self dataIniaitalization];
            
            
        }
    
    [self.categorySelectView setHidden:YES];
    [self loadAllCategory];
        
}
    
- (void) dataIniaitalization {
    
    // selected variable initialization
    
    self.barcentralSelected = NO;
    self.barofficeSelected = NO;
    self.barlaxSelected = NO;
    self.stockSelected = NO;
    self.bardjSelected = NO;
    self.eventoSelected = NO;
    self.barvipSelected = NO;
    
    // TextField & ImageView initialization
    

    self.itemNameTextField.text = @"";
    self.chooseCategoryButton.titleLabel.text = @"";
    self.wetFullBottleTextFeild.text = @"";
    self.wetEmptyBottleTextFeild.text = @"";
    self.wetLiquidTextFeild.text = @"";
    self.wetServingTextFeild.text = @"";
    self.servingPerBottleTextFeild.text = @"";
    self.salePriceTextFeild.text = @"";
    
    self.itemImageView.image = [UIImage imageNamed:@"coming_soon"];
    
    // Active Locatins Initialization
    
    self.barcentralImageView.image = [UIImage imageNamed:@"location_unselected"];
    self.barofficeImageView.image = [UIImage imageNamed:@"location_unselected"];
    self.barlaxImageView.image = [UIImage imageNamed:@"location_unselected"];;
    self.stockImageView.image = [UIImage imageNamed:@"location_unselected"];;
    self.bardjImageView.image = [UIImage imageNamed:@"location_unselected"];
    self.eventoImageView.image = [UIImage imageNamed:@"location_unselected"];;
    self.barvipImageView.image = [UIImage imageNamed:@"location_unselected"];
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewDidLayoutSubviews{
    self.chooseCategoryButton.layer.borderWidth = 1.0;
    self.chooseCategoryButton.layer.borderColor = [UIColor grayColor].CGColor;


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
//    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
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

#pragma mark - server communication method (save item data at database)

- (IBAction)onCreateAndEditItemAction:(id)sender {
    
        
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
    
    NSString *requestMethod = @"";
    
    if ([self.fromVC isEqualToString:@"add"]) {
        requestMethod = ADD_ITEM;
    } else {
        requestMethod = EDIT_ITEM;
    }
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient addItem:requestMethod
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
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
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


- (void) alertAction:(NSString*)title withMessage:(NSString*)showMessage {
    
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:title message:showMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)locationChangeViewInitialization:(NSString*)location withActiveValue:(BOOL)activeValue{
    
    NSString *currentItemName = @"";
    self.selectedLoctionString = location;
    
    
    
    if ([self.itemNameTextField.text isEqualToString:@""]) {
        
        [self alertAction:@"SORRY" withMessage:@"PLEAS ADD ITEM NAME"];
        return;
        
    } else {
        
        
        if ([self.fromVC isEqualToString:@"add"]) {
            for (int i = 0; i < self.itemArray.count; i++) {
                
                ItemFull *itemModel = (ItemFull*)self.itemArray[i];
                if ([itemModel.itemName isEqualToString:self.itemNameTextField.text]) {
                    [self alertAction:@"SORRY" withMessage:@"THIS ITEM IS EXIST IN LIST NOW, TRY WITH OTHER NAME TO ADD!"];
                    return;
                }
            }
            
        }
    }
        
        
    currentItemName = self.itemNameTextField.text;
    [self.locationChangeConfirmView setHidden:NO];
    
    if (activeValue) {
        // Do Active
        [self.locationChangeParTextField setHidden:NO];
        self.locationChangeCausionLabel.text = [NSString stringWithFormat:@"<%@> WILL BE ADDED IN %@, ADD PAR VALUE", currentItemName, location];
        [self.locationChangeConfirmButton setTitle:@"ACTIVE/ADD" forState:UIControlStateNormal];
        
        self.requestStatus = @"active";
        
        
    } else {
        // Deactive
        [self.locationChangeParTextField setHidden:YES];
        self.locationChangeCausionLabel.text = [NSString stringWithFormat:@"<%@> WILL BE DELETED IN %@, CONFIRM AGAIN", currentItemName, location];
        [self.locationChangeConfirmButton setTitle:@"DEACTIVE/REMOVE" forState:UIControlStateNormal];
        
        self.requestStatus = @"inactive";
    }
    
}




// location active/deactive actions

- (IBAction)onBarCentralAction:(id)sender {
    if (self.barcentralSelected) [self locationChangeViewInitialization:@"BAR CENTRAL" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"BAR CENTRAL" withActiveValue:YES];
}

- (IBAction)onBarOfficeAction:(id)sender {
    if (self.barofficeSelected) [self locationChangeViewInitialization:@"BAR CENTRAL" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"BAR CENTRAL" withActiveValue:YES];
}

- (IBAction)onBarLaxAction:(id)sender {
    if (self.barlaxSelected) [self locationChangeViewInitialization:@"BAR LAX" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"BAR LAX" withActiveValue:YES];
}

- (IBAction)onStockAction:(id)sender {
    if (self.stockSelected) [self locationChangeViewInitialization:@"STOCK" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"STOCK" withActiveValue:YES];
}
- (IBAction)onBarDJAction:(id)sender {
    if (self.bardjSelected) [self locationChangeViewInitialization:@"BAR DJ" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"BAR DJ" withActiveValue:YES];
}
- (IBAction)onEventoAction:(id)sender {
    if (self.eventoSelected) [self locationChangeViewInitialization:@"EVENTO" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"EVENTO" withActiveValue:YES];
}
- (IBAction)onVIPAction:(id)sender {
    if (self.barvipSelected) [self locationChangeViewInitialization:@"BAR VIP" withActiveValue:NO];
    else [self locationChangeViewInitialization:@"BAR VIP" withActiveValue:YES];
}

- (IBAction)locationChangeAction:(id)sender {
    
    NSString *parValue = self.locationChangeParTextField.text;
    
    if ([self.requestStatus isEqualToString:@"active"]) {
        if ([self.locationChangeParTextField.text isEqual:@""]) {
            self.locationChangeParTextField.layer.borderWidth = 1.0;
            self.locationChangeParTextField.layer.borderColor = [UIColor redColor].CGColor;
            return;
            
        } else {
            
            self.locationChangeParTextField.layer.borderColor = [UIColor whiteColor].CGColor;
            
        }
    } else {
        parValue = @"0";
    }
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient itemLocationStatusUpdate:ITEM_LOCATION_STATUS_UPDATE
                              andStatus:self.requestStatus
                            andItemName:self.selectedItem.itemName
                        andLocationName:self.selectedLoctionString
                                 andPar:parValue
                         andFinishBlock:^(NSArray *data) {
        
        
        NSDictionary *dicData = (NSDictionary *)data;
        NSString *stateCode = [dicData objectForKey:STATE];
        
        [hud hide:YES];
        if(![stateCode isEqualToString:@"200"]){
            [self.locationChangeConfirmView setHidden:YES];
            [self alertAction:@"FAILED" withMessage:[dicData objectForKey:MESSAGE]];
        } else{
                        
            // All Set Finished Successfully
            if ([self.selectedLoctionString isEqualToString:@"BAR CENTRAL"]) {
                if (self.barcentralSelected) self.barcentralImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.barcentralImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.barcentralSelected = !self.barcentralSelected;
                
            } else if ([self.selectedLoctionString isEqualToString:@"BAR OFFIC"]) {
                if (self.barofficeSelected) self.barofficeImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.barofficeImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.barofficeSelected = !self.barofficeSelected;
                
            } else if ([self.selectedLoctionString isEqualToString:@"BAR LAX"]) {
                if (self.barlaxSelected) self.barlaxImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.barlaxImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.barlaxSelected = !self.barlaxSelected;
                
            } else if ([self.selectedLoctionString isEqualToString:@"STOCK"]) {
                if (self.stockSelected) self.stockImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.stockImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.stockSelected = !self.stockSelected;
                
            } else if ([self.selectedLoctionString isEqualToString:@"BAR DJ"]) {
                if (self.bardjSelected) self.bardjImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.bardjImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.bardjSelected = !self.bardjSelected;
                
            } else if ([self.selectedLoctionString isEqualToString:@"EVENTO"]) {
                if (self.eventoSelected) self.eventoImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.eventoImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.eventoSelected = !self.eventoSelected;
                
            } else if ([self.selectedLoctionString isEqualToString:@"BAR VIP"]) {
                if (self.barvipSelected) self.barvipImageView.image = [UIImage imageNamed:@"location_unselected"];
                else self.barvipImageView.image = [UIImage imageNamed:@"location_selected"];
                
                self.barvipSelected = !self.barvipSelected;
                
            } else {
                
                // fuck this, what the hell
            }
            
            [self.locationChangeConfirmView setHidden:YES];
            self.locationChangeParTextField.text = @"";
                        
        }
        
        
    } andFailBock:^(NSError *error) {
        
        [hud hide:YES];
        [self.view makeToast:@"Please check internect connection" duration:1.5 position:CSToastPositionCenter];
        
    }];
    
}

- (IBAction)locationChangeCancelAction:(id)sender {
    

    
    [self.locationChangeConfirmView setHidden:YES];
    
}


@end
