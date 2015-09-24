//
//  ImageView.m
//  Canchallena
//
//  Created by Carlos Garcia on 6/1/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "ImageView.h"
#import "UIImageView+Extended.h"
#define IMGW 640
#define IMGH 424


@interface ImageView (){
    IBOutlet UILabel *epigrafeLbl;
    IBOutlet UIImageView *pictureView;
}

@end

@implementation ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ImageView" owner:self options:nil];
    id mainView = [subviewArray objectAtIndex:0];
    
    return mainView;
}

- (void)loadImageWithId:(NSString*)imageId andEpigrafe:(NSString*)epigrafe{
    
    NSString *url = @"http://bucket.lanacion.com.ar/anexos/fotos/";
    
    NSString *carpeta = [imageId substringFromIndex:[imageId length]-2];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@w%dh%d.%@", url, carpeta, imageId, IMGW, IMGH, @"jpg"];
    
    [pictureView loadImageFromURL:imageUrl placeholderImage:nil];
    pictureView.contentMode = UIViewContentModeScaleAspectFill;
    pictureView.layer.masksToBounds = TRUE;
    
    epigrafeLbl.text = epigrafe;
}

@end
