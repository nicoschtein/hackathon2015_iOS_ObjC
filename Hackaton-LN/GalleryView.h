//
//  GalleryView.h
//  Canchallena
//
//  Created by Carlos Garcia on 6/1/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryView : UIView <UIScrollViewDelegate>

- (void)loadGalleryWithId:(NSString *)galleryId;

@end
