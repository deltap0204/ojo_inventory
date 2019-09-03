//
//  ACFloating TextField.h
//  OJOv1
//
//  Created by MilosHavel on 06/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACFloatingTextField : UITextField
{
    UIView *bottomLineView;
}

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) UIColor *placeHolderColor;
@property (nonatomic,strong) UIColor *selectedPlaceHolderColor;
@property (nonatomic,strong) UIColor *selectedLineColor;

@property (nonatomic,strong) UILabel *labelPlaceholder;

@property (assign) BOOL disableFloatingLabel;

-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame;

-(void)setTextFieldPlaceholderText:(NSString *)placeholderText;
-(void)upadteTextField:(CGRect)frame;

@end
