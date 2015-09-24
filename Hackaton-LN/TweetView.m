//
//  TweetView.m
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 5/30/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import "TweetView.h"
#import "LvHttpClient.h"

@interface TweetView (){
    int nroRequest;
}

@end

@implementation TweetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)loadTweetWithId:(NSString*)tweetId{
    self.delegate = self;
    nroRequest = 0;
    
    LvHttpClient *client = [[LvHttpClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1/"]];
    
    [client getMethod:[NSString stringWithFormat:@"statuses/oembed.json?id=%@&align=center&maxwidth=%f", tweetId, [UIScreen mainScreen].bounds.size.width] withParams:nil response:^(id object, NSError *error) {
        if (!error) {
            // Print the response body in text
            DLog(@"Response: %@", [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding]);
            
            NSString *responseStr = [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding];
            responseStr = [responseStr stringByRemovingPercentEncoding];
            
            NSData* data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *html = obj[@"html"];
            html = [html stringByReplacingOccurrencesOfString:@"//platform.twitter.com" withString:@"http://platform.twitter.com"];
            DLog(@"HTML: %@", html);
            [self loadHTMLString:html baseURL:nil];
        }
    }];
    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1/"]];
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
//                                                            path:[NSString stringWithFormat:@"statuses/oembed.json?id=%@&align=center&maxwidth=320", tweetId]
//                                                      parameters:nil];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // Print the response body in text
//        DLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        
//        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        responseStr = [responseStr stringByRemovingPercentEncoding];
//        
//        NSData* data = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSString *html = obj[@"html"];
//        html = [html stringByReplacingOccurrencesOfString:@"//platform.twitter.com" withString:@"http://platform.twitter.com"];
//        DLog(@"HTML: %@", html);
//        [self loadHTMLString:html baseURL:nil];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    [operation start];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (nroRequest<6) {
        nroRequest++;
        return YES;
    }
    
    [[UIApplication sharedApplication]openURL:request.URL];
    return NO;
}


@end
