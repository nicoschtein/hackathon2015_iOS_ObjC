//
//  GalleryView.h
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 6/1/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryView : UIView <UIScrollViewDelegate>

- (void)loadGalleryWithId:(NSString *)galleryId;

@end
