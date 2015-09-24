//
//  UIColor+Extended.h
//  LvKit
//
//  Created by Leandro on 1/10/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extended)

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

- (UIColor *)initWithHex:(NSString *)hex alpha:(CGFloat)alpha;

@end
