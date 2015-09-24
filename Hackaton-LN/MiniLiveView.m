//
//  MiniLiveView.m
//  Canchallena
//
//  Created by Juan Manuel Abrigo on 6/1/14.
//  Copyright (c) 2014 Lateral View. All rights reserved.
//

#import "MiniLiveView.h"

@interface MiniLiveView (){
    int status;
    IBOutlet UILabel *teamALbl;
    IBOutlet UILabel *teamBLbl;
    IBOutlet UIImageView *teamAView;
    IBOutlet UIImageView *teamBView;
    IBOutlet UILabel *scoreLbl;
    IBOutlet UILabel *statusLbl;
    IBOutlet UILabel *timeLbl;
}

@end

@implementation MiniLiveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    NSArray *subviewArray = [[NSArray alloc] init];
    int altoPantalla = [UIScreen mainScreen].bounds.size.height;
    switch (altoPantalla) {
        case 480:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MiniLiveView480" owner:self options:nil];
            break;
        case 520:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MiniLiveView480" owner:self options:nil];
            break;
        case 667:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MiniLiveView667" owner:self options:nil];
            break;
        case 736:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MiniLiveView736" owner:self options:nil];
            break;
        default:
            subviewArray = [[NSBundle mainBundle] loadNibNamed:@"MiniLiveView736" owner:self options:nil];
            break;
    }
    
    id mainView = [subviewArray objectAtIndex:0];
    
    return mainView;
}

- (void)loadWithDic:(NSDictionary*)dic{
    status = [[dic objectForKey:@"estadoId"] intValue];
    [self loadStatus];
    dic = [dic objectForKey:@"campeonato"];
    NSString *teamA = [dic[@"equipo"] firstObject][@"descripcion"];
    teamALbl.text = [teamA uppercaseString];
    
    NSString *idA = [dic[@"equipo"] firstObject][@"Id"];
    
    [teamAView loadImageFromURL:[NSString stringWithFormat:@"http://bucket.lanacion.com.ar/canchallena/escudos/%@_2h%d.png", idA, 140] placeholderImage:nil];
    //                teamAId = teamA[@"equipo_id"];
    
    NSString *teamB = [dic[@"equipo"] objectAtIndex:1][@"descripcion"];
    NSString *idB = [dic[@"equipo"] objectAtIndex:1][@"Id"];

    teamBLbl.text = [teamB uppercaseString];
    
    [teamBView loadImageFromURL:[NSString stringWithFormat:@"http://bucket.lanacion.com.ar/canchallena/escudos/%@_2h%d.png", idB, 140] placeholderImage:nil];
    
    scoreLbl.text = @"0 - 0";
    
}

-(void)loadStatus{
    if (status==1) {
        statusLbl.hidden = FALSE;
        statusLbl.text = @"SIN COMIENZO";
    }else if (status==2){
        statusLbl.hidden = FALSE;
        statusLbl.text = @"EN VIVO";
    }else if (status==3){
        statusLbl.hidden = FALSE;
        statusLbl.text = @"FINALIZADO";
    }else if (status==4){
        statusLbl.hidden = FALSE;
        statusLbl.text = @"SUSPENDIDO";
    }else if (status==5){
        statusLbl.hidden = FALSE;
        statusLbl.text = @"EN VIVO";
    }
    timeLbl.text = @"";
}

- (void)loadWithId:(NSString*)encuentroId{
    
    [[CanchallenaJsonAPI shared] getLiveWithId:encuentroId response:^(id object, NSError *error) {
        if (!error) {
            status = [object[@"encuentro"][@"estado"] intValue];
            //NSArray *teams = object[@"equiposArray"];
            //if (teams.count>1) {
            NSDictionary *teamA = object[@"encuentro"][@"local"];
            if (teamA) {
                NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                                           NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
                
                NSData *dataA = [teamA[@"nombre"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSAttributedString *attStringA = [[NSAttributedString alloc] initWithData:dataA options:options documentAttributes:nil error:nil];
                
                teamALbl.text = [[attStringA string] uppercaseString];
                
                [teamAView loadImageFromURL:[NSString stringWithFormat:@"http://bucket.lanacion.com.ar/canchallena/escudos/%@_2h%d.png", teamA[@"id"], 140] placeholderImage:nil];
                //                teamAId = teamA[@"equipo_id"];
                
                NSDictionary *teamB = object[@"encuentro"][@"visitante"];
                
                NSData *dataB = [teamB[@"nombre"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSAttributedString *attStringB = [[NSAttributedString alloc] initWithData:dataB options:options documentAttributes:nil error:nil];
                
                teamBLbl.text = [[attStringB string] uppercaseString];
                
                [teamBView loadImageFromURL:[NSString stringWithFormat:@"http://bucket.lanacion.com.ar/canchallena/escudos/%@_2h%d.png", teamB[@"id"], 140] placeholderImage:nil];
                
                scoreLbl.text = [NSString stringWithFormat:@"%@ - %@", teamA[@"total"], teamB[@"total"]];
                
                
                timeLbl.hidden = TRUE;
                statusLbl.hidden = TRUE;
                if (status==1) {
                    statusLbl.hidden = FALSE;
                    
                    if (object[@"encuentro_fecha"])timeLbl.text = object[@"encuentro_fecha"];
                    else timeLbl.text = @"SIN COMIENZO";
                }else if (status==2){
                    statusLbl.hidden = FALSE;
                    statusLbl.text = @"EN VIVO";
                    timeLbl.hidden = FALSE;
                    
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *string = [dateFormatter1 stringFromDate:[NSDate date]];
                    NSString *subStr = [string substringToIndex:10];
                    
                    NSString *dateString1 = [NSString stringWithFormat:@"%@ %@", subStr, object[@"encuentro"][@"hora"]];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    NSDate *date1 = [dateFormatter dateFromString:dateString1];
                    NSDate *date2 = [NSDate date];
                    
                    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
                    
                    int numberOfMinutes = round(secondsBetween) / 60;
                    timeLbl.text = [NSString stringWithFormat:@"%d' %@T", numberOfMinutes, object[@"encuentro"][@"tiempo"]];
                    
                }else if (status==3){
                    statusLbl.hidden = FALSE;
                    statusLbl.text = @"FINALIZADO";
                }else if (status==4){
                    statusLbl.hidden = FALSE;
                    statusLbl.text = @"SUSPENDIDO";
                }else if (status==5){
                    statusLbl.hidden = FALSE;
                    statusLbl.text = @"EN VIVO";
                    timeLbl.text = @"ENTRE TIEMPO";
                }
            }
            else{
                statusLbl.hidden = FALSE;
                statusLbl.text = @"SIN COMIENZO";
                timeLbl.text = @"";
                timeLbl.hidden = FALSE;
                
                teamBLbl.text = @"";
                teamALbl.text = @"";
                
                scoreLbl.text = @"0 - 0";
                scoreLbl.hidden = FALSE;

            }
            
            
            
            
            
            
            //}
        }
    }];
}

@end
