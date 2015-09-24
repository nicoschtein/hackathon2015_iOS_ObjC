//
//  MiniLiveView.h
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 6/1/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniLiveView : UIView

- (void)loadWithId:(NSString*)encuentroId;
- (void)loadWithDic:(NSDictionary*)dic;

@end
