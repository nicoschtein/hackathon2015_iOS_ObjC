//
//  NoticiaAvance.m
//  Hackaton-LN
//
//  Created by Carlos Garcia on 22/9/15.
//  Copyright © 2015 Carlos Garcia. All rights reserved.
//

#import "NoticiaAvance.h"

@implementation NoticiaAvance


- (id) initWithAtributos:(NSDictionary*) atribs{
    self = [super init];
    if (self) {
        // campos
        self.atributos = atribs;
    }
    
    return self;
}

#pragma mark - Getters

- (NSString*) titulo
{
    if ([self.atributos[@"parametros"] isKindOfClass:[NSArray class]]) {
        NSDictionary *params = self.atributos[@"parametros"][0];
        if ([params isKindOfClass:[NSDictionary class]])
        {
            //                NSLog(@"parametros: %@", params);
            if (params[@"titulo_home"]) {
                NSString *param = [NSString stringWithFormat:@"%@", params[@"titulo_home"]];
                if ([param length]>2) {
                    return param;
                }
            }
        }
    }
    
    if([self.atributos[@"titulo"] isKindOfClass:[NSArray class]])
    {
        return [self.atributos[@"titulo"] lastObject][@"valor"];
    } else {
        return self.atributos[@"titulo"];
    }
}

- (NSString*) preTitulo
{
    //    NSLog(@"self.atributos: %@", self.atributos);
    if ([[self volanta] length]>0) {
        return [self volanta];
    } else {
        return nil;
    }
}

- (NSString*) volanta
{
    if([self.atributos[@"volanta"] isKindOfClass:[NSArray class]])
    {
        return [self.atributos[@"volanta"] lastObject][@"valor"];
    } else {
        return self.atributos[@"volanta"];
    }
}

- (NSString*) bajada
{
    if([self.atributos[@"bajada"] isKindOfClass:[NSArray class]])
    {
        return [self.atributos[@"bajada"] lastObject][@"valor"];
    } else {
        return self.atributos[@"bajada"];
    }
}

- (NSString*) notaId {
    if ([self.atributos objectForKey:@"NOTA_ID"]) {
        return [self.atributos objectForKey:@"NOTA_ID"];
    } else if ([self.atributos objectForKey:@"nota_id"]){
        return [self.atributos objectForKey:@"nota_id"];
    } else if ([self.atributos objectForKey:@"id"]){
        return [self.atributos objectForKey:@"id"];
    } else {
        return @"";
    }
}


@end
