//
//  LvCache.m
//  Zupa
//
//  Created by Juan Manuel Abrigo on 7/30/13.
//  Copyright (c) 2013 Lateral View. All rights reserved.
//

#import "LvCache.h"

static NSTimeInterval cacheTime =  (double)3600*24*7; // 7days

@implementation LvCache

+ (void)resetAndCleanCache {
	[[NSFileManager defaultManager] removeItemAtPath:[LvCache cacheDirectory] error:nil];
}

+ (NSString*)cacheDirectory {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [NSString stringWithFormat:@"%@/LvCache",[paths objectAtIndex:0]];
	return cacheDirectory;
}

+ (NSData*)objectForKey:(NSString*)key {
    key = [self normalizeKey:key];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
	
	if ([fileManager fileExistsAtPath:filename])
	{
		NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
		if ([modificationDate timeIntervalSinceNow] > cacheTime) {
			[fileManager removeItemAtPath:filename error:nil];
		} else {
			NSData *data = [NSData dataWithContentsOfFile:filename];
			return data;
		}
	}
	return nil;
}

+ (void)setObject:(NSData*)data forKey:(NSString*)key {
    key = [self normalizeKey:key];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    BOOL isFolder = TRUE;
	if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isFolder]) {
		[fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	NSError *error;
	@try {
		[data writeToFile:filename options:NSDataWritingAtomic error:&error];
	}
	@catch (NSException * e) {
		NSLog(@"LvCache - Error writing to file: %@", [e description]);
	}
}

+ (NSString*)normalizeKey:(NSString*)keyStr{
    NSString *finalkey = [keyStr stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    finalkey = [finalkey stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    finalkey = [finalkey stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    return finalkey;
}

@end
