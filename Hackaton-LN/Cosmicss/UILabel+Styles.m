//
//  UILabel+Styles.m
//  Kollectin
//
//  Created by Carlos Garcia on 10/23/13.
//  Copyright (c) 2013 La Nacion. All rights reserved.
//

#import "UILabel+Styles.h"
#import "Cosmicss.h"

@implementation UILabel (Styles)

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
            
            [self setFont:[UIFont fontWithName:classDict[Font] size:[classDict[FontSize]floatValue]]];
            [self setTextColor:[UIColor colorWithHex:classDict[TextColor] alpha:1.0]];
            
            NSString *backgroudColor = classDict[BackgroundColor];
            if (backgroudColor) {
                if ([[backgroudColor lowercaseString] isEqualToString:Clear]) {
                    [self setBackgroundColor:[UIColor clearColor]];
                }else{
                    [self setBackgroundColor:[UIColor colorWithHex:classDict[BackgroundColor] alpha:1.0]];
                    
                    self.layer.backgroundColor = [UIColor colorWithHex:classDict[BackgroundColor] alpha:1.0].CGColor;
                    self.layer.cornerRadius = [classDict[CornerRadius]floatValue];
                    self.layer.borderColor = [UIColor colorWithHex:classDict[BorderColor] alpha:1.0].CGColor;
                    self.layer.borderWidth = [classDict[BorderWidth]floatValue];
                    
                }
            }
        }
    }
}

- (void)updateScreen:(NSTimer*)cn{
    NSDictionary *userInfo = [cn userInfo];
    [self applyStyleWithClass:[userInfo objectForKey:StyleClassName]];
}

@end
