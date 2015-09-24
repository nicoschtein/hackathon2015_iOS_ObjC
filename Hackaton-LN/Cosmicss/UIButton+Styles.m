//
//  UIButton+Styles.m
//  Colors
//
//  Created by Carlos Garcia on 9/17/13.
//  Copyright (c) 2013 La Nacion. All rights reserved.
//

#import "UIButton+Styles.h"
#import "Cosmicss.h"

@implementation UIButton (Styles)

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:StyleClassName])
    {
        [self applyStyleWithClass:[value description]];
        
        if ([Cosmicss shared].monitorMode) {
            NSDictionary *userInfo = @{StyleClassName: [value description]};
            [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                           selector:@selector(updateScreen:)
                                           userInfo:userInfo
                                            repeats:YES];
        }
    }
}

- (void)applyStyleWithClass:(NSString*)className{
    if (![className isEqualToString:@""]) {
        NSDictionary *classDict = [[Cosmicss shared]getStyleClassWithName:className];
        if (classDict) {
            self.layer.backgroundColor = [UIColor colorWithHex:classDict[BackgroundColor] alpha:1.0].CGColor;
            self.layer.cornerRadius = [classDict[CornerRadius]floatValue];
            self.layer.borderColor = [UIColor colorWithHex:classDict[BorderColor] alpha:1.0].CGColor;
            self.layer.borderWidth = [classDict[BorderWidth]floatValue];
            [self setTitleColor:[UIColor colorWithHex:classDict[TextColor] alpha:1.0] forState:UIControlStateNormal];
            self.titleLabel.font = [UIFont fontWithName:classDict[Font] size:[classDict[FontSize]floatValue]];
            
            [self setBackgroundImage:[self imageWithColor:[UIColor colorWithHex:classDict[BackgroundColorHighlighted] alpha:1.0]] forState:UIControlStateHighlighted];
            
        }
    }
}

- (void)updateScreen:(NSTimer*)cn{
    NSDictionary *userInfo = [cn userInfo];
    [self applyStyleWithClass:[userInfo objectForKey:StyleClassName]];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
