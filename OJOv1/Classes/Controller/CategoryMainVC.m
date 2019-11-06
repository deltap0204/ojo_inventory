//
//  CategoryMainVC.m
//  OJOv1
//
//  Created by MilosHavel on 10/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "CategoryMainVC.h"
#import "AdminMainVC.h"
#import "Category.h"
#import "CategoryTVC.h"



@interface CategoryMainVC ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addCategoryButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITextField *addCategoryName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addFullOpen;
@property (assign, nonatomic) NSInteger addFullOpenSelectedIndex;
@property (weak, nonatomic) IBOutlet UIButton *addViewButton;
@property (weak, nonatomic) IBOutlet UIButton *viewCloseButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tabGesture;


@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *forthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@property (assign, nonatomic) NSInteger frequencyInt;

@property (strong, nonatomic) NSMutableArray *searchResult;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) BOOL isFiltered;

@end

@implementation CategoryMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.categoryArray = [[NSMutableArray alloc] init];
    self.isFiltered = NO;
    self.searchBar.delegate = self;
    
    [self.addView setHidden:YES];
    [self initialStar];
    
    [self loadAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews{
    
    self.addViewButton.layer.borderWidth = 2.0f;
    self.addViewButton.layer.cornerRadius = self.addViewButton.bounds.size.height / 2;
    self.addViewButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.addCategoryName.layer.borderWidth = 2.0f;
    self.addCategoryName.layer.cornerRadius = self.addCategoryName.bounds.size.height / 2;
    self.addCategoryName.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.addView.layer.cornerRadius = self.addView.bounds.size.height / 20;

    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.backButton setTitle:@"\uf053" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.addCategoryButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:40.0]];
    [self.addCategoryButton setTitle:@"\uf067" forState:UIControlStateNormal];
    [self.addCategoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.viewCloseButton.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.viewCloseButton setTitle:@"\uf05c" forState:UIControlStateNormal];
    [self.viewCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}


#pragma mark - navitation view action  

- (IBAction)onBack:(id)sender {
    
    AdminMainVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"adminPage"];
    [svc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [svc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:svc animated:YES completion:nil];
    
}


#pragma mark - server connect method

- (void) loadAllData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OJOClient *ojoClicent = [OJOClient sharedWebClient];
        [ojoClicent getAllCateogories:GET_ALL_CATEGORY onFinish:^(NSArray *data) {
            
            NSDictionary *dicData = (NSDictionary *)data;
            NSString *stateCode = [dicData objectForKey:STATE];
            if ([stateCode isEqualToString:@"200"]) {
                
                NSArray *response = (NSArray *)[dicData objectForKey:MESSAGE];
                NSInteger count = response.count;
                
                [self.categoryArray removeAllObjects];
                Category *categoryModel = nil;
                
                for (int i = 0; i < count; i++) {
                    
                    NSDictionary *userDict = (NSDictionary *) response[i];
                    NSString *CategoryName = [userDict objectForKey:CATEGORY_NAME];
                    NSInteger fullOpent = [[userDict objectForKey:FULL_OPEN] integerValue];
                    NSInteger frequency = [[userDict objectForKey:FREQUENCY] integerValue];
                    
                    categoryModel = [[Category alloc] initWithCategoryName:CategoryName
                                                        andWithFullAndOpen:fullOpent
                                                          andWithFrequency:frequency];
                    [self.categoryArray addObject:categoryModel];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.tableView reloadData];
                });
            }
            
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self.categoryArray removeAllObjects];
                    [self.tableView reloadData];
                    NSString *response = [dicData objectForKey:MESSAGE];
                    [self.view makeToast:response duration:2.5 position:CSToastPositionCenter];
                    
                });
            }
            
        } onFail:^(NSError *error) {
            [self.view makeToast:@"Please check internect connection" duration:2.5 position:CSToastPositionCenter];
            
        }];
    });
}


#pragma mark - UItableView delegate Method

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowCount;
    if (self.isFiltered) {
        rowCount = self.searchResult.count;
    } else{
        rowCount = self.categoryArray.count;
    }
   return rowCount;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellItentifier = @"categoryCell";
    CategoryTVC *categoryCell = [tableView dequeueReusableCellWithIdentifier:cellItentifier];
    Category *categoryModel;
    
    if(self.isFiltered) categoryModel = (Category *)self.searchResult[indexPath.row];
    else categoryModel = (Category*)self.categoryArray[indexPath.row];
    
    
    categoryCell.categoryName.text = categoryModel.categoryName;
    NSInteger fullOpen = categoryModel.fullAndOpen;
    if (fullOpen == 1) {
        categoryCell.fullAndOpen.text = @"FULL/OPEN";
    } else{
        categoryCell.fullAndOpen.text = @"FULL";
    }
    
    NSInteger frequency = categoryModel.frequency;
    switch (frequency) {
        case 0:
            [categoryCell starZero];
            break;
        case 1:
            [categoryCell starOne];
            break;
        case 2:
            [categoryCell starTwo];
            break;
        case 3:
            [categoryCell starThree];
            break;
        case 4:
            [categoryCell starFour];
            break;
            
        case 5:
            [categoryCell starFive];
            break;
        default:
            break;
    }
    
    categoryCell.backgroundColor = categoryCell.contentView.backgroundColor;
    return categoryCell;
}
    
    

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
    
    
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        UIAlertController *alert = nil;
        Category *categoryModel = nil;
        categoryModel = self.categoryArray[indexPath.row];
        
        alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to delete this category ?"
                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                       hud.userInteractionEnabled = NO;
                                                       [hud show:YES];
                                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                           OJOClient *ojoClient = [OJOClient sharedWebClient];
                                                           [ojoClient deleteCategory:DELETE_CATEGORY
                                                                     andCategoryName:categoryModel.categoryName
                                                                        onFinish:^(NSArray *data) {
                                                                            NSDictionary *dicData = (NSDictionary *)data;
                                                                            NSString *stateCode = [dicData objectForKey:STATE];
                                                                            if ([stateCode isEqualToString:@"200"]) {
                                                                                [hud hide:YES];
                                                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                [self.categoryArray removeObjectAtIndex:indexPath.row];
                                                                                [self.tableView reloadData];
                                                                                
                                                                            } else {
                                                                                NSString *errorStr = [dicData objectForKey:MESSAGE];
                                                                                [self.view makeToast:errorStr duration:2.5 position:CSToastPositionTop];
                                                                                
                                                                            }
                                                                        } onFail:^(NSError *error) {
                                                                            [hud hide:YES];
                                                                            [self.view makeToast:@"Please check internect connection" duration:2.5 position:CSToastPositionCenter];
                                                                            
                                                                        }];
                                                           
                                                       });
                                                       
                                                   }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

#pragma mark - search bar delegate method

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;
        self.searchResult = [[NSMutableArray alloc] init];
        
        for (Category* category in self.categoryArray)
        {
            NSRange nameRange = [category.categoryName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.searchResult addObject:category];
            }
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Add category view button event method

- (IBAction)onFirst:(id)sender {
    
    self.frequencyInt = 1;

    [self.firstStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.firstStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.firstStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.secondStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.secondStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.secondStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.thirdStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.thirdStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.thirdStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.forthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.forthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fifthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.fifthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.fifthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}


- (IBAction)onSecond:(id)sender {
    self.frequencyInt = 2;
    
    [self.firstStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.firstStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.firstStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.secondStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.secondStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.secondStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.thirdStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.thirdStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.thirdStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.forthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.forthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fifthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.fifthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.fifthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}


- (IBAction)onThird:(id)sender {
    self.frequencyInt = 3;
    
    [self.firstStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.firstStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.firstStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.secondStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.secondStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.secondStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.thirdStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.thirdStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.thirdStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.forthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.forthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fifthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.fifthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.fifthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}

- (IBAction)onForth:(id)sender {
    self.frequencyInt = 4;
    
    [self.firstStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.firstStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.firstStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.secondStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.secondStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.secondStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.thirdStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.thirdStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.thirdStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.forthStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.forthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fifthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.fifthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.fifthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}

- (IBAction)onFifth:(id)sender {
    self.frequencyInt = 5;
    
    [self.firstStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.firstStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.firstStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.secondStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.secondStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.secondStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.thirdStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.thirdStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.thirdStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.forthStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.forthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fifthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.fifthStar setTitle:@"\uf005" forState:UIControlStateNormal];
    [self.fifthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}

- (void) initialStar{
    self.frequencyInt = 0;
    
    [self.firstStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.firstStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.firstStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.secondStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.secondStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.secondStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.thirdStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.thirdStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.thirdStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.forthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.forthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.fifthStar.titleLabel setFont:[UIFont fontWithName:@"fontawesome" size:30.0]];
    [self.fifthStar setTitle:@"\uf006" forState:UIControlStateNormal];
    [self.fifthStar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (IBAction)onAddCategory:(id)sender {
    
    [self.addView setHidden:NO];
    UIColor *color = [UIColor whiteColor];
    self.addCategoryName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CATEGORY NAME"
                                                                                 attributes:@{NSForegroundColorAttributeName:color}];
    self.addCategoryName.text = @"";
    [self.addFullOpen setSelectedSegmentIndex:0];
    [self initialStar];
    self.addFullOpenSelectedIndex = 0;
    
}

- (IBAction)onAddViewCategory:(id)sender {
    
    NSString *categoryName = self.addCategoryName.text;
    NSInteger fullAndOpen = self.addFullOpenSelectedIndex;
    NSInteger frequency = self.frequencyInt;
    
    if ([categoryName isEqualToString:@""]) {
        [self.addView makeToast:@"Empty category name" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [self.addView setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    OJOClient *ojoClient = [OJOClient sharedWebClient];
    [ojoClient addCategory:ADD_CATEGORY
           andCategoryName:categoryName
            andFullAndOpen:fullAndOpen
              andfrequency:frequency
             onFinishBlock:^(NSArray *data) {
                 
                 NSDictionary *dicData = (NSDictionary *)data;
                 NSString *stateCode = [dicData objectForKey:STATE];
                 if ([stateCode isEqualToString:@"200"]) {
                     Category *category = [[Category alloc] initWithCategoryName:categoryName
                                                              andWithFullAndOpen:fullAndOpen
                                                                andWithFrequency:frequency];
                     [self.categoryArray addObject:category];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadData];
                         [hud hide:YES];
                         [self.view makeToast:@"CATEGORY ADD SUCCESS" duration:1.0 position:CSToastPositionCenter];
                     });
                 }
                 else {
                     [hud hide:YES];
                     [self.view makeToast:[dicData objectForKey:MESSAGE] duration:2.5 position:CSToastPositionCenter];
                     
                 }
                 
    } onFailBlock:^(NSError *error) {
        [hud hide:YES];
        [self.view makeToast:@"Please check internect connection" duration:2.5 position:CSToastPositionCenter];
        
    }];
    
    
}
- (IBAction)fullAndOpenAction:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0: // bartender
            self.addFullOpenSelectedIndex = 0;
            break;
        case 1: // manager
            self.addFullOpenSelectedIndex = 1;
            break;
        default:
            break;
    }
}

- (IBAction)onViewClose:(id)sender {
    [self.addView setHidden:YES];
    
}

- (IBAction)onTabGeture:(id)sender {
    [self.addCategoryName resignFirstResponder];
    
}


@end
