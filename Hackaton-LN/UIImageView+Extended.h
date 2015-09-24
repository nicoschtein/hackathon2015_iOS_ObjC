//
//  UIImageView+Extended.h
//  LvKit
//
//  Created by Carlos Garcia on 1/10/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extended)

@property (nonatomic, copy) NSURL *imageURL;

- (void)loadImageFromURL:(NSString*)urlStr placeholderImage:(UIImage*)placeholder;

@end
