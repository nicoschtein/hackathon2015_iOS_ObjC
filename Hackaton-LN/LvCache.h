//
//  LvCache.h
//  Zupa
//
//  Created by Juan Manuel Abrigo on 7/30/13.
//  Copyright (c) 2013 Lateral View. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LvCache : NSObject

+ (void)resetAndCleanCache;
+ (void)setObject:(NSData*)data forKey:(NSString*)key;
+ (id)objectForKey:(NSString*)key;

@end
