//
//  UITextField+PaddingLabel.h
//  OJOv1
//
//  Created by MilosHavel on 14/11/2016.
//  Copyright © 2016 MilosHavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PaddingLabel)

-(void) setLeftPaddingText:(NSString*) paddingValue width:(CGFloat) width;

-(void) setRightPaddingText:(NSString*) paddingValue width:(CGFloat) width;

@end
