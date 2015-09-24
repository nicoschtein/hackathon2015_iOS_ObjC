//
//  UIColor+Extended.m
//  LvKit
//
//  Created by Carlos Garcia on 1/10/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "UIColor+Extended.h"

@implementation UIColor (Extended)

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    return [[UIColor alloc] initWithHex:hex alpha:alpha];
}

- (UIColor *)initWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    
	UIColor *defaultResult = [UIColor blackColor];
    
    if ([hex hasPrefix:@"#"] && [hex length] > 1) {
        hex = [hex substringFromIndex:1];
    }
    
    NSUInteger componentLength = 0;
    if ([hex length] == 3)
        componentLength = 1;
    else if ([hex length] == 6)
        componentLength = 2;
    else
        return defaultResult;
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hex substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:alpha];
}

@end
