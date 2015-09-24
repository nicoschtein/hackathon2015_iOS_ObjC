//
//  UITextField+Styles.m
//  La Nacion
//
//  Created by Carlos Garcia on 2/19/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "UITextField+Styles.h"
#import "Cosmicss.h"

@implementation UITextField (Styles)

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
//            self.layer.borderColor = [UIColor colorWithHex:classDict[BorderColor] alpha:1.0].CGColor;
//            self.layer.borderWidth = [classDict[BorderWidth]floatValue];
            [self setTextColor:[UIColor colorWithHex:classDict[TextColor] alpha:1.0]];
            self.font = [UIFont fontWithName:classDict[Font] size:[classDict[FontSize]floatValue]];
        }
    }
}

- (void)updateScreen:(NSTimer*)cn{
    NSDictionary *userInfo = [cn userInfo];
    [self applyStyleWithClass:[userInfo objectForKey:StyleClassName]];
}

@end
