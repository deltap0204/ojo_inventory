//
//  UITextField+PaddingLabel.m
//  OJOv1
//
//  Created by MilosHavel on 14/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import "UITextField+PaddingLabel.h"

@implementation UITextField (PaddingLabel)

-(void) setLeftPaddingText:(NSString*) paddingValue width:(CGFloat) width
{
    UILabel *paddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    paddingLabel.text = paddingValue;
    self.leftView = paddingLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPaddingText:(NSString*) paddingValue width:(CGFloat) width
{
    UILabel *paddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    paddingLabel.text = paddingValue;
    self.rightView = paddingLabel;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
