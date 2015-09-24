//
//  NoticiaAvance.h
//  Hackaton-LN
//
//  Created by Carlos Garcia on 22/9/15.
//  Copyright © 2015 Carlos Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticiaAvance : NSObject

@property (nonatomic, retain) NSDictionary * atributos;

//metodos para inicializar
- (id) initWithAtributos:(NSDictionary*) atribs;

//metodos para traer datos - Getters
- (NSString*) titulo;
- (NSString*) volanta;
- (NSString*) fecha;
- (NSString*) preTitulo;
- (NSString*) notaId;
- (NSString*) bajada;

@end
