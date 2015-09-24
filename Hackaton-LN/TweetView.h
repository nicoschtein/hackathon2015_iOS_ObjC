//
//  TweetView.h
//  Canchallena
//
//  Created by Carlos Garcia on 5/30/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetView : UIWebView <UIWebViewDelegate>

- (void)loadTweetWithId:(NSString*)tweetId;

@end
