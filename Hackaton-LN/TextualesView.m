//
//  TextualesView.m
//  Canchallena
//
//  Created by Carlos Garcia on 5/30/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "TextualesView.h"

@implementation TextualesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"TextualesView" owner:self options:nil];
    id mainView = [subviewArray objectAtIndex:0];
    
    return mainView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)shareAction{
    [_delegate shareTweetWithText:_textLbl.text];
}

@end
