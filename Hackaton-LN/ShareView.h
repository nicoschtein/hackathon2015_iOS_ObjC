//
//  ShareView.h
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 5/30/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate

- (void)shareWithText:(NSString*)text;

@end;


@interface ShareView : UIView

@property (nonatomic, weak) IBOutlet UILabel *textLbl;

@property (nonatomic, strong) id<ShareViewDelegate> delegate;

@end
