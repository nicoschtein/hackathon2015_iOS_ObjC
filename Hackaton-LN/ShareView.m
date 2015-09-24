//
//  ShareView.m
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 5/30/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    NSArray *subviewArray = [[NSArray alloc] init];
    int altoPantalla = [UIScreen mainScreen].bounds.size.height;
    switch (altoPantalla) {
        case 480:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ShareView480" owner:self options:nil];
            break;
        case 520:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ShareView480" owner:self options:nil];
            break;
        case 667:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ShareView667" owner:self options:nil];
            break;
        case 736:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ShareView736" owner:self options:nil];
            break;
        default:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ShareView736" owner:self options:nil];
            break;
    }
    
    id mainView = [subviewArray objectAtIndex:0];
    
    return mainView;
}

- (IBAction)shareAction{
    [_delegate shareWithText:_textLbl.text];
}

@end
