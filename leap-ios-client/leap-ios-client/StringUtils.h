//
//  StringUtils.h
//  sumaho-de-chance
//
//  Created by 山口 弘資 on 11/11/18.
//  Copyright (c) 2011年 jp.co.cyberagent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (NSString *)append:(NSString *)str1 str2:(NSString *)str2;

+ (BOOL)equals:(NSString *)str1 str2:(NSString *)str2;

+ (NSString *)join:(NSString *)str1, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSString *)join:(NSString *)separator :(NSArray *)array;

+ (NSString *)replace:(NSString *)str searchString:(NSString *)search replacement:(NSString *)rep;

+ (BOOL)isBlank:(NSString *)str;

+ (BOOL)isNotBlank:(NSString *)str;

+ (NSArray *)split:(NSString *)str separator:(NSString *)separator;

+ (NSDictionary *)getParameterFromURL:(NSString *)strURL;

@end
