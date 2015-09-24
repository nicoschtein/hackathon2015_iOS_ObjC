//
//  TweetView.h
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 5/30/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetView : UIWebView <UIWebViewDelegate>

- (void)loadTweetWithId:(NSString*)tweetId;

@end
