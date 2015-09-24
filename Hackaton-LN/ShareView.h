//
//  ShareView.h
//  Canchallena
//
//  Created by Carlos Garcia on 5/30/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate

- (void)shareWithText:(NSString*)text;

@end;


@interface ShareView : UIView

@property (nonatomic, weak) IBOutlet UILabel *textLbl;

@property (nonatomic, strong) id<ShareViewDelegate> delegate;

@end
