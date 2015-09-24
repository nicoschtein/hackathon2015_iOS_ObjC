//
//  NoteViewController.h
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 3/31/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBYouTubeVideoViewController.h"
#import "TextualesView.h"
#import "ShareView.h"

@interface NoteViewController : UIViewController <PBYouTubeVideoViewControllerDelegate, TextualesViewDelegate, ShareViewDelegate>

@property (nonatomic, strong) NSString *noteId;
@property (nonatomic, strong) NSString *tema;

@end
