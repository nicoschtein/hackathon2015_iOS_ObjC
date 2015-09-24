//
//  UIImageView+Extended.m
//  LvKit
//
//  Created by Carlos Garcia on 1/10/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "UIImageView+Extended.h"
#import <objc/runtime.h>
#import "LvCache.h"

static char URLKEY;

@implementation UIImageView (Extended)

@dynamic imageURL;

- (void)loadImageFromURL:(NSString*)urlStr placeholderImage:(UIImage*)placeholder{
    
    NSData *cachedData = [LvCache objectForKey:urlStr];
	if (cachedData) {
        self.imageURL = nil;
        self.image = [UIImage imageWithData:cachedData];
        return;
	}else{
        NSURL *url = [NSURL URLWithString:urlStr];
        self.imageURL = url;
        if (placeholder)
            self.image = placeholder;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *imageFromData = [UIImage imageWithData:data];
            [LvCache setObject:data forKey:urlStr];
            if (imageFromData) {
                if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        self.image = imageFromData;
                        
                        [UIView transitionWithView:self
                                          duration:0.5f
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            self.image = imageFromData;
                                        } completion:nil];
                    });
                }
            }
            self.imageURL = nil;
        });
    }
}

- (void)setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URLKEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*)imageURL {
	return objc_getAssociatedObject(self, &URLKEY);
}

@end
