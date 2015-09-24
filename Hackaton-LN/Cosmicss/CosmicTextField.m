//
//  CosmicTextField.m
//  La Nacion
//
//  Created by Carlos Garcia on 2/19/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "CosmicTextField.h"
#import "UIColor+Extended.h"

@implementation CosmicTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithHex:@"D4D4D4" alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
//        self.layer.cornerRadius = 4.0;
//        self.textColor = [UIColor colorWithHex:@"777777" alpha:1.0];
//        self.font = [UIFont fontWithName:@"Gotham-Book" size:18.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.borderColor = [UIColor colorWithHex:@"D4D4D4" alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
//        self.layer.cornerRadius = 4.0;
//        self.textColor = [UIColor colorWithHex:@"777777" alpha:1.0];
//        self.font = [UIFont fontWithName:@"Gotham-Book" size:18.0];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect ret = [super textRectForBounds:bounds];
    ret.origin.x = ret.origin.x + 5;
    ret.size.width = ret.size.width - 10;
    return ret;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


@end
