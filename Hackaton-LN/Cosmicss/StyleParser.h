//
//  StyleParser.h
//  Colors
//
//  Created by Carlos Garcia on 9/17/13.
//  Copyright (c) 2013 La Nacion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleParser : NSObject

- (NSMutableDictionary*)getStylesFromPath:(NSString*)path;

@end
