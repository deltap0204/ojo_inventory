//
//  KPDropMenu.m
//  KPDropMenu
//
//  Created by Krishna Patel on 22/03/17.
//  Copyright © 2017 Krishna. All rights reserved.
//

#import "KPDropMenu.h"

@interface KPDropMenu () <UITableViewDelegate, UITableViewDataSource>
{
    UIFont *selectedFont, *font, *itemFont;
    UITapGestureRecognizer *tapGestureBackground;
    
}

@property (strong, nonatomic) UITableView *tblView;
@property (strong, nonatomic) UILabel *label;
@property (assign, nonatomic) BOOL isCollapsed;

@end

@implementation KPDropMenu
@synthesize selectedIndex;

- (instancetype)init {
    if (self = [super init])
        [self initLayer];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self initLayer];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self initLayer];
    return self;
}

- (void)initLayer {
    
    selectedIndex = 0;
    self.isCollapsed = TRUE;
    _itemTextAlignment = _titleTextAlignment = NSTextAlignmentCenter;
    _titleColor = [UIColor blackColor];
    _titleFontSize = 14.0;
    _itemHeight = 40.0;
    _itemBackground = [UIColor whiteColor];
    _itemTextColor = [UIColor blackColor];
    _itemFontSize = 14.0;
    _itemsFont = [UIFont systemFontOfSize:14.0];
    _DirectionDown = YES;
}

#pragma mark - Setter

-(void)setTitle:(NSString *)title{
    _title = title;
}

-(void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment{
    if(titleTextAlignment)
        _titleTextAlignment = titleTextAlignment;
}

-(void)setItemTextAlignment:(NSTextAlignment)itemTextAlignment{
    if(itemTextAlignment)
        _itemTextAlignment = itemTextAlignment;
}

-(void)setTitleColor:(UIColor *)titleColor{
    if(titleColor)
        _titleColor = titleColor;
}

-(void)setTitleFontSize:(CGFloat)titleFontSize{
    if(titleFontSize)
        _titleFontSize = titleFontSize;
    
}

-(void)setItemHeight:(double)itemHeight{
    if(itemHeight)
        _itemHeight = itemHeight;
}

-(void)setItemBackground:(UIColor *)itemBackground{
    if(itemBackground)
        _itemBackground = itemBackground;
}

-(void)setItemTextColor:(UIColor *)itemTextColor{
    if(itemTextColor)
        _itemTextColor = itemTextColor;
}

-(void)setItemFontSize:(CGFloat)itemFontSize{
    if(itemFontSize)
        _itemFontSize = itemFontSize;
}

-(void)setItemsFont:(UIFont *)itemFont1{
    if(itemFont1)
        _itemsFont = itemFont1;
}

-(void)setDirectionDown:(BOOL)DirectionDown{
    _DirectionDown = DirectionDown;
}

#pragma mark - Setups

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //self.layer.cornerRadius = 4;
    //self.layer.borderColor = [[UIColor grayColor] CGColor];
    //self.layer.borderWidth = 1;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label.textColor = _titleColor;
    self.label.text = _title;
    self.label.textAlignment = _titleTextAlignment;
    self.label.font = font;
    [self addSubview:self.label];
    
    UIButton *actionPress = [[UIButton alloc] initWithFrame:self.bounds];
    [actionPress addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    actionPress.backgroundColor = [UIColor clearColor];
    [self addSubview:actionPress];
    
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x + self.superview.frame.origin.x, self.frame.origin.y + self.superview.frame.origin.y, self.frame.size.width, self.frame.size.height)] ;
    
    [self.tblView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.backgroundColor = _itemBackground;
}

-(void)didTap : (id)sender {
    self.isCollapsed = !self.isCollapsed;
    if(!self.isCollapsed) {
        CGFloat height = (CGFloat)(_items.count > 5 ? _itemHeight*5 : _itemHeight * (double)(_items.count));
        
        self.tblView.layer.zPosition = 1;
        [self.tblView removeFromSuperview];
        self.tblView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.tblView.layer.borderWidth = 1;
        self.tblView.layer.cornerRadius = 4;
        [[self.superview superview] addSubview:self.tblView]; // go to superview that can show tableview in it's frame.
        [self.tblView reloadData];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if(self->_DirectionDown)
                self.tblView.frame = CGRectMake(self.frame.origin.x + self.superview.frame.origin.x, self.frame.origin.y + self.superview.frame.origin.y + self.frame.size.height+5, self.frame.size.width, height);
            else
                self.tblView.frame = CGRectMake(self.frame.origin.x + self.superview.frame.origin.x, self.frame.origin.y + self.superview.frame.origin.y - 5 - height, self.frame.size.width, height);
        }];
        
        if(_delegate != nil){
            [_delegate didShow:self];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.tag = 99121;
        [self.superview insertSubview:view belowSubview:self.tblView];
        
    }
    else{
        [self collapseTableView];
    }

}

-(void)collapseTableView{
    if(self.isCollapsed){
        [UIView animateWithDuration:0.25 animations:^{
            
            if(self->_DirectionDown)
                self.tblView.frame = CGRectMake(self.frame.origin.x + self.superview.frame.origin.x, self.frame.origin.y + self.superview.frame.origin.y + self.frame.size.height+5, self.frame.size.width, 0);
            else
                self.tblView.frame = CGRectMake(self.frame.origin.x + self.superview.frame.origin.x, self.frame.origin.y + self.superview.frame.origin.y, self.frame.size.width, 0);
        }];
        
        [[self.superview viewWithTag:99121] removeFromSuperview];
        
        if(_delegate != nil){
            [_delegate didHide:self];
        }
        
    }
}

#pragma mark - UITableView's Delegate and Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.textAlignment = _itemTextAlignment;
    cell.textLabel.text = _items[indexPath.row];
    
    cell.textLabel.font = _itemsFont;
    cell.textLabel.textColor = _itemTextColor;
    
    if (indexPath.row == selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.backgroundColor = _itemBackground;
    cell.tintColor = self.tintColor;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _itemHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = (int)indexPath.row;
    self.label.text = _items[selectedIndex];
    
    if(_itemsIDs.count > 0)
        self.tag = [_itemsIDs[selectedIndex] integerValue];
    
    self.isCollapsed = TRUE;
    [self collapseTableView];
    if(_delegate != nil){
        [_delegate didSelectItem:self atIndex:(int)selectedIndex];
    }
    
}






























@end
