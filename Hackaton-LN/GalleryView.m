//
//  GalleryView.m
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 6/1/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import "GalleryView.h"

@interface GalleryView (){
    IBOutlet UILabel *epigrafeLbl;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIPageControl *pageControl;
}

@end

@implementation GalleryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GalleryView" owner:self options:nil];
    id mainView = [subviewArray objectAtIndex:0];
    
    return mainView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)loadGalleryWithId:(NSString *)galleryId{
    [[CanchallenaAPI shared]getGaleriaWithId:galleryId response:^(id object, NSError *error) {
        if (!error) {
            
            
            NSString *epigrafe = object[@"XML"][@"CONTENIDO"][@"GALERIA"][@"GALERIA_EPIGRAFE"];
            if ([epigrafe isEqualToString:@""]) {
                epigrafe = @"Galeria de fotos.";
            }
            epigrafeLbl.text = epigrafe;
            
            NSArray *imagenes = object[@"XML"][@"CONTENIDO"][@"GALERIA"][@"IMAGENES"][@"IMAGENsArray"];
            
            for (int i=0; i<[imagenes count]; i++) {
                
                NSDictionary *picture = [imagenes objectAtIndex:i];
                NSString *imageId = [NSString stringWithFormat:@"%@",picture[@"IMAGEN_ID"]];
                NSString *url = @"http://bucket.lanacion.com.ar/anexos/fotos/";
                
                NSString *carpeta = [imageId substringFromIndex:[imageId length]-2];
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@w%d.%@", url, carpeta, imageId, IMGW, @"jpg"];
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 270)];
                [imgView loadImageFromURL:imageUrl placeholderImage:nil];
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                [scroll addSubview:imgView];
            }
            scroll.contentSize = CGSizeMake([imagenes count]*[UIScreen mainScreen].bounds.size.width, 270);
            scroll.backgroundColor = [UIColor colorWithHex:@"222222" alpha:1.0];
            scroll.delegate = self;
            pageControl.numberOfPages = [imagenes count];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging || scrollView.isDecelerating){
        pageControl.currentPage = lround(scroll.contentOffset.x / (scroll.contentSize.width / pageControl.numberOfPages));
    }
}

@end
