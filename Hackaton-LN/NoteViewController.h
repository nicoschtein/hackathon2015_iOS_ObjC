//
//  NoteViewController.h
//  Canchallena
//
//  Created by Carlos Garcia on 3/31/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBYouTubeVideoViewController.h"
#import "TextualesView.h"
#import "ShareView.h"
#import "UIImageView+Extended.h"

@interface NoteViewController : UIViewController <PBYouTubeVideoViewControllerDelegate, TextualesViewDelegate, ShareViewDelegate>

@property (nonatomic, strong) NSString *noteId;
@property (nonatomic, strong) NSString *tema;

@end
