//
//  NoteViewController.m
//  Canchallena
//
//  Created by Carlos Garcia on 3/31/14.
//  Copyright (c) 2014 La Nacion. All rights reserved.
//

#import "NoteViewController.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "LvYouTubeView.h"
#import "YTPlayerView.h"
#import "TweetView.h"
#import "TextualesView.h"
#import "GalleryView.h"
#import "ImageView.h"
#import "MiniLiveView.h"
//#import "LiveController.h"
//#import "CommentsViewController.h"
#import "AFNetworking.h"


#define IMGW 640
static NSString * const NOTA_URL = @"http://contenidos.lanacion.com.ar/json/nota/";


@interface NoteViewController (){
    UIView *noteView;
    NSDictionary *note;
    UIScrollView *scroll;
    NSArray *multimedios;
    NSString *encuentroId;
}

@end

@implementation NoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    /*[[CanchallenaJsonAPI shared]getNote:_noteId response:^(id object, NSError *error) {
        if (!error) {
            //DLog(@"NOTE: %@", [object description]);
            note = object;
            [self generateNoteView];
        }
    }];*/
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSDictionary *parameters = @{@"foo": @"bar"};
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:[NSString stringWithFormat:@"%@%@", NOTA_URL, self.noteId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        note = json;
        [self generateNoteView];
        NSLog(@"Se trajo la nota");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    scroll.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.topItem.title = self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareAction:(id)sender{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    UIImageView *imageView = (UIImageView*)[scroll viewWithTag:201];
    
    NSArray *titleArray = note[@"titulo"];
    NSDictionary *titleDic = [titleArray firstObject];
    NSString *text = titleDic[@"valor"];
    
    NSString *string = [NSString stringWithFormat:@"%@ http://canchallena.com/%@", text, note[@"url"]];
    
    if (string) {
        [sharingItems addObject:string];
    }
    if (imageView.image) {
        [sharingItems addObject:imageView.image];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)generateNoteView{
    
    //DLog(@"Note: %@", note);
    
    multimedios = note[@"multimedios"];
    
    NSString *tagStr = @"";
    NSArray *tags = note[@"tags"];
    for (NSDictionary *tag in tags) {
        if ([tag[@"tipoDescripcion"]isEqualToString:@"Tópico"]) {
            tagStr = tag[@"valor"];
        }
    }
    
    if (![tagStr isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *fechaFormateada = [dateFormatter dateFromString:note[@"fechaActualizacion"]];
        
        NSString * fechaSola = note[@"fechaActualizacion"];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        
        if ([[fechaSola substringWithRange:NSMakeRange(0, 10)] isEqualToString:[[NSString stringWithFormat:@"%@", [NSDate date]]substringWithRange:NSMakeRange(0, 10)]])
        {
            [timeFormat setDateFormat:@"HH:mm"];
            tagStr = [NSString stringWithFormat:@"%@ | %@", tagStr, [timeFormat stringFromDate:fechaFormateada]];
            
        } else {
            
            [timeFormat setDateFormat:@"dd-MM"];
            tagStr = [NSString stringWithFormat:@"%@ | %@", tagStr, [timeFormat stringFromDate:fechaFormateada]];
        }
        
    }
    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-64)];
    scroll.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:scroll];
    noteView = [[UIView alloc]init];
    
    // Config
    int yy = 10;
    
    // Tema
    UILabel *temaLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, yy, [UIScreen mainScreen].bounds.size.width-20, 20)];
    [temaLbl setValue:@"NoteTemaLabel" forKey:@"styleClass"];
    if (![tagStr isEqualToString:@""]) {
        temaLbl.text = tagStr;
    }else{
        temaLbl.text = _tema;
    }
    [noteView addSubview:temaLbl];
    
    yy = yy + 30;
    
    // Titulo
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, yy, [UIScreen mainScreen].bounds.size.width-20, 20)];
    titleLbl.numberOfLines = 0;
    [titleLbl setValue:@"NoteH1Label" forKey:@"styleClass"];
    NSArray *titleArray = note[@"titulo"];
    NSDictionary *titleDic = [titleArray firstObject];
    
    NSString *text = titleDic[@"valor"];
    NSString *trimmedString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titleLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
    CGRect newFrame = titleLbl.frame;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
    CGSize expectedSize = [titleLbl sizeThatFits:maximumLabelSize];
    newFrame.size.height = expectedSize.height;
    titleLbl.frame = newFrame;
    
    [noteView addSubview:titleLbl];
    yy = yy + titleLbl.frame.size.height + 20;
    
    // Bajada
    UILabel *bajadaLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, yy, [UIScreen mainScreen].bounds.size.width-20, 20)];
    bajadaLbl.numberOfLines = 0;
    [bajadaLbl setValue:@"NoteBajadaLabel" forKey:@"styleClass"];
    NSArray *bajadaArray = note[@"bajada"];
    if (bajadaArray>0) {
        NSDictionary *bajadaDict = [bajadaArray firstObject];
        NSString *text = bajadaDict[@"valor"];
        NSString *trimmedString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        bajadaLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
        
        CGRect newFrame = bajadaLbl.frame;
        CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
        CGSize expectedSize = [bajadaLbl sizeThatFits:maximumLabelSize];
        newFrame.size.height = expectedSize.height;
        bajadaLbl.frame = newFrame;
        
        [noteView addSubview:bajadaLbl];
        yy = yy + bajadaLbl.frame.size.height + 20;
    }
    
    // Autores
    NSArray *autores = note[@"autores"];
    if (autores.count>0) {
        NSDictionary *autor = [autores firstObject];
        
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, yy, [UIScreen mainScreen].bounds.size.width-20, 20)];
        titleLbl.numberOfLines = 0;
        [titleLbl setValue:@"NoteAutorLabel" forKey:@"styleClass"];
        
        NSString *text = [NSString stringWithFormat:@"Por %@", autor[@"valor"]];
        NSString *trimmedString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        titleLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
        CGRect newFrame = titleLbl.frame;
        CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
        CGSize expectedSize = [titleLbl sizeThatFits:maximumLabelSize];
        newFrame.size.height = expectedSize.height;
        titleLbl.frame = newFrame;
        
        [noteView addSubview:titleLbl];
        yy = yy + titleLbl.frame.size.height + 20;
    }
    
    
    // Contenido
    NSArray *contenidoArray = note[@"contenido"];
    for (NSDictionary *item in contenidoArray) {
        
        NSString *type = item[@"_t"];
        if ([type isEqualToString:@"sub"]){
            
            NSString *valor = item[@"valor"];
            
            UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
            itemLbl.numberOfLines = 0;
            [itemLbl setValue:@"NoteSubLabel" forKey:@"styleClass"];
            
            NSString *trimmedString = [valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            itemLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
            
            CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
            CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
            itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
            
            [noteView addSubview:itemLbl];
            yy = yy + itemLbl.frame.size.height + 20;
            
            
        }else
        if ([type isEqualToString:@"des"]){
            //DLog(@"des");
            
            ShareView *shareView = [[ShareView alloc]init]; // h= 140
            shareView.delegate = self;
            shareView.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 140);
            
            NSString *text = @"";
            id valor = item[@"valor"];
            if ([valor isKindOfClass:[NSString class]]) {
                text = valor;
            }else if ([valor isKindOfClass:[NSArray class]]){
                
                NSArray *list = valor;
                for (id obj in list) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        text = [NSString stringWithFormat:@"%@%@", text, obj];
                    }else if([obj isKindOfClass:[NSDictionary class]]){
                        text = [NSString stringWithFormat:@"%@%@", text, obj[@"valor"]];
                    }
                }
            }
            shareView.textLbl.text = text;
            [noteView addSubview:shareView];
            yy = yy + 156 + 10;
            
        }else
        if ([type isEqualToString:@"p"]) {
            id valor = item[@"valor"];
            if ([valor isKindOfClass:[NSString class]]) {
                UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
                itemLbl.numberOfLines = 0;
                [itemLbl setValue:@"NotePLabel" forKey:@"styleClass"];
                
                NSString *trimmedString = [valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                itemLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
                
                CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
                CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
                itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
                
                [noteView addSubview:itemLbl];
                yy = yy + itemLbl.frame.size.height + 20;
            }else
            if ([valor isKindOfClass:[NSDictionary class]]) {
                NSDictionary *newItem = valor;
                NSString *type = newItem[@"_t"];
                if ([type isEqualToString:@"img"]) {
                    //DLog(@"IMG: %@", newItem);
                    ImageView *imageView = [[ImageView alloc]init];
                    imageView.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 252);
                    NSString *imgageId = [NSString stringWithFormat:@"%@", newItem[@"id"]];
                    NSString *epigrafe = newItem[@"epigrafe"][@"valor"];
                    if ([epigrafe isEqualToString:@""]) {
                        NSArray *titleArray = note[@"titulo"];
                        NSDictionary *titleDic = [titleArray firstObject];
                        epigrafe = titleDic[@"valor"];
                    }
                    [imageView loadImageWithId:imgageId andEpigrafe:epigrafe];
                    
                    [noteView addSubview:imageView];
                    yy = yy + imageView.frame.size.height + 10;
                }
                else if ([type isEqualToString:@"textual"]){
                    //DLog(@"textual");
                    
                    
                    TextualesView *textualView = [[TextualesView alloc]init]; // h= 140
                    textualView.delegate = self;
                    textualView.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 140);
                    textualView.textLbl.text = newItem[@"valor"];
                    [noteView addSubview:textualView];
                    yy = yy + 156 + 10;
                    
                }
                else if ([type isEqualToString:@"des"]){
                    //DLog(@"des");
                    
                    ShareView *shareView = [[ShareView alloc]init]; // h= 140
                    shareView.delegate = self;
                    shareView.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 140);
                    shareView.textLbl.text = newItem[@"valor"];
                    [noteView addSubview:shareView];
                    yy = yy + 156 + 10;
                        
                }
                else if ([type isEqualToString:@"vid"]){
                        
                        // Video
//                        NSString *videoId = [NSString stringWithFormat:@"%@",newItem[@"id"]];
//
//                        NSString *url = @"http://cdntx.lanacion.com.ar/anexos/Videos/";
//                        
//                        NSString *carpeta = [videoId substringFromIndex:[videoId length]-2];
//                        NSString *videoUrl = [NSString stringWithFormat:@"%@%@/%@.%@", url, carpeta, videoId, @"mp4"];
//                        
//                        
//                        NSURL *movieURL = [NSURL URLWithString:videoUrl];
//                        MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
//                        movieController.view.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 310);
//                        [self.view addSubview:movieController.view];
//                        [movieController.moviePlayer play];
                        
                        
                        
                        if (multimedios.count>0) {
                            NSDictionary *multimedio = [multimedios firstObject];
                            NSArray *multimedioImagenes = multimedio[@"multimedioImagen"];
                            if (multimedioImagenes.count>0) {
                                NSDictionary *img = [multimedioImagenes firstObject];
                                NSString *imageId = [NSString stringWithFormat:@"%d", [img[@"id"]intValue]];
                                
                                NSString *url = @"http://bucket.lanacion.com.ar/anexos/fotos/";
                                
                                NSString *carpeta = [imageId substringFromIndex:[imageId length]-2];
                                NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@w%d.%@", url, carpeta, imageId, IMGW, @"jpg"];
                                
                                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 180)];
                                [imgView loadImageFromURL:imageUrl placeholderImage:nil];
                                
                                [noteView addSubview:imgView];
                                
                                
                                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 180)];
                                [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                                [button addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
                                [noteView addSubview:button];
                                
                                
                                yy = yy + imgView.frame.size.height + 10;
                            }
                        }
                        
                }
                else if ([type isEqualToString:@"gal"]){
                        
                    // Galeria
                    NSString *galleryId = [NSString stringWithFormat:@"%@",newItem[@"id"]];
                    GalleryView *galleryView = [[GalleryView alloc]init];
                    galleryView.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width-10);
                    [galleryView loadGalleryWithId:galleryId];
                    
                    [noteView addSubview:galleryView];
                    yy = yy + galleryView.frame.size.height + 10;
                    
                }
                else if ([type isEqualToString:@"b"]){
                    
                    NSString *valor = newItem[@"valor"];
                    
                    UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
                    itemLbl.numberOfLines = 0;
                    [itemLbl setValue:@"NoteBLabel" forKey:@"styleClass"];
                    
                    NSString *trimmedString = [valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    itemLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
                    
                    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
                    CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
                    itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
                    
                    [noteView addSubview:itemLbl];
                    yy = yy + itemLbl.frame.size.height + 20;
                    
                        
                }
                else if ([type isEqualToString:@"enc"]){
                    //DLog(@"enc");
                    NSNumber *idTenis = [NSNumber numberWithInt:2];
                    if (![note[@"encuentros"][0][@"campeonato"][@"deporteId"] isEqualToNumber:idTenis]){
                        MiniLiveView *encView = [[MiniLiveView alloc]init]; // h= 134
                        encView.frame = CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 134);
                        encuentroId = [NSString stringWithFormat:@"%@",newItem[@"id"]];
                        NSDictionary * encuentroDic = [[note objectForKey:@"encuentros"] firstObject];
                        
                        if (encuentroDic && [[encuentroDic objectForKey:@"estadoId"] intValue] == 1) {
                            [encView loadWithDic:encuentroDic];
                            //[encView loadWithId:[NSString stringWithFormat:@"%@",newItem[@"id"]]];
                        }
                        else [encView loadWithId:[NSString stringWithFormat:@"%@",newItem[@"id"]]];
                        [noteView addSubview:encView];
                    
                        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 134)];
                        [but addTarget:self action:@selector(gotoLive) forControlEvents:UIControlEventTouchUpInside];
                        [noteView addSubview:but];
                    
                        yy = yy + 134 + 10;
                    }
                    
                }else
                if ([type isEqualToString:@"sub"]){
                        
                    NSString *valor = newItem[@"valor"];
                        
                    UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
                    itemLbl.numberOfLines = 0;
                    [itemLbl setValue:@"NoteSubLabel" forKey:@"styleClass"];
                        
                    NSString *trimmedString = [valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    itemLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
                        
                    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
                    CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
                    itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
                        
                    [noteView addSubview:itemLbl];
                    yy = yy + itemLbl.frame.size.height + 20;
                        
                        
                }else
                if ([type isEqualToString:@"ul"]){
                        //DLog(@"ul: %@", newItem);
                    id valor = newItem[@"valor"];
                    if ([valor isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *element in valor) {
                            id valor = element[@"valor"];
                            if ([valor isKindOfClass:[NSArray class]]) {
                                NSArray *itemList = valor;
                                NSString *text = @"";
                                for (id item in itemList) {
                                    if ([item isKindOfClass:[NSString class]]) {
                                        
                                        NSString *trimmedString = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                        NSString *textItem = [NSString stringWithFormat:@"%@ ", trimmedString];
                                        
                                        text = [text stringByAppendingString:textItem];
                                    }else if ([item isKindOfClass:[NSDictionary class]]){
                                        id valor = item[@"valor"];
                                        if ([valor isKindOfClass:[NSString class]]) {
                                            
                                            NSString *textStr = item[@"valor"];
                                            NSString *trimmedString = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                            NSString *textItem = [NSString stringWithFormat:@"%@ ", trimmedString];
                                            
                                            text = [text stringByAppendingString:textItem];
                                        }
                                        
                                    }else if ([valor isKindOfClass:[NSString class]]) {
                                        
                                        NSString *trimmedString = [valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                        text = [NSString stringWithFormat:@"%@ ", trimmedString];
                                        
                                    }
                                }
                                
                                UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
                                itemLbl.numberOfLines = 0;
                                [itemLbl setValue:@"NotePLabel" forKey:@"styleClass"];
                                itemLbl.text = text;
                                
                                CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
                                CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
                                itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
                                
                                [noteView addSubview:itemLbl];
                                yy = yy + itemLbl.frame.size.height + 20;
                            }else if ([valor isKindOfClass:[NSString class]]) {
                                UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
                                itemLbl.numberOfLines = 0;
                                [itemLbl setValue:@"NotePLabel" forKey:@"styleClass"];
                                
                                NSString *trimmedString = [valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                itemLbl.text = [NSString stringWithFormat:@"%@ ", trimmedString];
                                
                                CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
                                CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
                                itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
                                
                                [noteView addSubview:itemLbl];
                                yy = yy + itemLbl.frame.size.height + 20;
                            }
                        }
                    }
                }else
                    if ([type isEqualToString:@"ext"]){
                        //DLog(@"ext %@", newItem);
                        id valor = newItem[@"valor"];
                        if ([valor isKindOfClass:[NSArray class]]) {
                            NSArray *itemList = valor;
                            NSString *urlSrc = @"";
                            NSString *twitterUrlSrc = @"";
                            if (itemList>0) {
                                NSDictionary *nodo = [itemList firstObject];
                                NSArray *array = nodo[@"contenido"][@"atributos"];
                                for (NSDictionary *atributo in array) {
                                    if ([[atributo allKeys] containsObject:@"src"]) {
                                        urlSrc = atributo[@"src"];
                                    }
                                }
                                
                                
                                NSArray *hijos = nodo[@"contenido"][@"hijos"];
                                if (hijos.count >1) {
                                    NSDictionary *nodo = [hijos objectAtIndex:1];
                                    NSArray *atributos = nodo[@"contenido"][@"atributos"];
                                    if (atributos.count>0) {
                                        NSDictionary *href = [atributos firstObject];
                                        twitterUrlSrc = href[@"href"];
                                    }
                                }
                            }
                            
                            
                            NSRange isYouTubeRange = [urlSrc rangeOfString:@"youtube" options:NSCaseInsensitiveSearch];
                            NSRange isTwitterRange = [twitterUrlSrc rangeOfString:@"twitter" options:NSCaseInsensitiveSearch];
                            if(isYouTubeRange.location != NSNotFound) {
                                // Youtube
                                urlSrc = [urlSrc stringByReplacingOccurrencesOfString:@"//www.youtube.com/embed/" withString:@""];
                                
                                YTPlayerView *playerView = [[YTPlayerView alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 180)];
                                [playerView loadWithVideoId:urlSrc];
                                [noteView addSubview:playerView];
                                yy = yy + playerView.frame.size.height + 10;
                            }else if (isTwitterRange.location != NSNotFound){
                                // Twitter
                                
                                NSRange range = [twitterUrlSrc rangeOfString:@"/" options:NSBackwardsSearch];
                                NSRange subRange = {range.location+1, [twitterUrlSrc length]-(range.location+1)};
                                NSString *twitterId = [twitterUrlSrc substringWithRange:subRange];
                                
                                TweetView *webView = [[TweetView alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 460)];
                                [webView loadTweetWithId:twitterId];
                                [noteView addSubview:webView];
                                yy = yy + webView.frame.size.height + 10;
                            }
                            
                            
                            
                        }
                    }
            }else
            if ([valor isKindOfClass:[NSArray class]]) {
                NSArray *itemList = valor;
                NSString *text = @"";
                for (id item in itemList) {
                    if ([item isKindOfClass:[NSString class]]) {
                        
                        NSString *trimmedString = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSString *textItem = [NSString stringWithFormat:@"%@ ", trimmedString];
                        
                        text = [text stringByAppendingString:textItem];
                    }else if ([item isKindOfClass:[NSDictionary class]]){
                        id valor = item[@"valor"];
                        if ([valor isKindOfClass:[NSString class]]) {
                            
                            NSString *textStr = item[@"valor"];
                            NSString *trimmedString = [textStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            NSString *textItem = [NSString stringWithFormat:@"%@ ", trimmedString];
                            
                            text = [text stringByAppendingString:textItem];
                        }
                        
                    }
                }
                
                UILabel *itemLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 20)];
                itemLbl.numberOfLines = 0;
                [itemLbl setValue:@"NotePLabel" forKey:@"styleClass"];
                itemLbl.text = text;
                
                CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 9999);
                CGSize expectedSize = [itemLbl sizeThatFits:maximumLabelSize];
                itemLbl.frame = CGRectMake(10, yy, expectedSize.width, expectedSize.height);
                
                [noteView addSubview:itemLbl];
                yy = yy + itemLbl.frame.size.height + 20;
            }
        }
        
    }
    
    UIButton *commentsButton = [[UIButton alloc]initWithFrame:CGRectMake(10, yy, [UIScreen mainScreen].bounds.size.width-20, 39)];
    [commentsButton setImage:[UIImage imageNamed:@"ver-comentarios"] forState:UIControlStateNormal];
    [commentsButton addTarget:self action:@selector(gotoComments) forControlEvents:UIControlEventTouchUpInside];
    [noteView addSubview:commentsButton];
    yy = yy + commentsButton.frame.size.height + 20;
    
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 50)];
    spaceView.backgroundColor = [UIColor clearColor];
    [noteView addSubview:spaceView];
    yy = yy + 50;
    
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(0, yy, [UIScreen mainScreen].bounds.size.width, 900)];
    //blueView.backgroundColor = [UIColor colorWithHex:@"49ACC5" alpha:1.0];
    [noteView addSubview:blueView];
    yy = yy + 5;
    
    noteView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, yy);
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, yy);
    [scroll addSubview:noteView];
}

- (void)gotoComments{
    
}

- (void)youTubeVideoViewController:(PBYouTubeVideoViewController *)viewController didReceiveEventNamed:(NSString *)eventName eventData:(NSString *)eventData
{
    NSLog(@"event: %@ - value: %@", eventName, eventData ? eventData : @"");
}

- (void)playVideo{
    
    if (multimedios.count>0) {
        NSDictionary *multimedio = [multimedios firstObject];
        NSArray *multimedioImagenes = multimedio[@"multimedioFile"];
        if (multimedioImagenes.count>0) {
            NSDictionary *vid = [multimedioImagenes firstObject];
            NSString *videoId = [NSString stringWithFormat:@"%d", [vid[@"id"]intValue]];
            
            
            NSString *url = @"http://cdntx.lanacion.com.ar/anexos/Videos/";
            NSString *carpeta = [videoId substringFromIndex:[videoId length]-2];
            NSString *videoUrl = [NSString stringWithFormat:@"%@%@/%@.%@", url, carpeta, videoId, @"mp4"];
            
            NSURL *movieURL = [NSURL URLWithString:videoUrl];
            MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
            [self presentMoviePlayerViewControllerAnimated:movieController];
            [movieController.moviePlayer play];
            
        }
    }

    
}

- (void)gotoLive{
    
}

#pragma mark - Textual Delegate

- (void)shareTweetWithText:(NSString *)text{
    NSMutableArray *sharingItems = [NSMutableArray new];
    NSString *string = [NSString stringWithFormat:@"%@ http://canchallena.com/%@", text, note[@"url"]];
    
    if (string) {
        [sharingItems addObject:string];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];

}

- (void)shareWithText:(NSString *)text{
    NSMutableArray *sharingItems = [NSMutableArray new];
    NSString *string = [NSString stringWithFormat:@"%@ http://canchallena.com/%@", text, note[@"url"]];
    
    if (string) {
        [sharingItems addObject:string];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
