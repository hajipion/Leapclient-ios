//
//  StringUtils.m
//  sumaho-de-chance
//
//  Created by 山口 弘資 on 11/11/18.
//  Copyright (c) 2011年 jp.co.cyberagent. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString *)append:(NSString *)str1 str2:(NSString *)str2 {
    if (str1 == nil && str2 == nil) {
        return @"";
    } else if (str1 == nil) {
        return str2;
    } else if (str2 == nil) {
        return str1;
    }
    return [str1 stringByAppendingString:str2];
}

+ (BOOL)equals:(NSString *)str1 str2:(NSString *)str2
{
    if (str1 == nil && str2 == nil) {
        return YES;
    } else if (str1 == nil || str2 == nil) {
        return NO;
    }
    return [str1 isEqualToString:str2];
}

+ (NSString *)join:(NSString *)str1, ...
{
    va_list args;
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    if (str1 == nil) {
        return @"";
    }
    va_start(args, str1);
    NSString *s = str1;
    while (str1) {
        if (s == nil) {
            break;
        }
        [result appendString:s];
        s = va_arg(args, __typeof__(NSString *));
    }
    va_end(args);
    return result;
}

+ (NSString *)join:(NSString *)separator :(NSArray *)array;
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    if (array == nil || [array count] == 0) {
        return @"";
    }
    NSInteger n = 0;
    for (NSString *elem in array) {
        if (n == 0) {
            if ([elem isKindOfClass:[NSString class]]) {
                [result appendString:elem];
            } else {
                [result appendString:[[NSString alloc] initWithFormat:@"%@", elem]];
            }
        } else {
            if ([elem isKindOfClass:[NSString class]]) {
                [result appendString:[StringUtils append:separator str2:elem]];
            } else {
                [result appendString:[StringUtils append:separator str2:[[NSString alloc] initWithFormat:@"%@", elem]]];
            }
        }
        n++;
    }

    return result;
}

+ (NSString *)replace:(NSString *)str searchString:(NSString *)search replacement:(NSString *)rep
{
    if (str == nil) {
        return @"";
    } else if (search == nil || rep == nil) {
        return str;
    }
    
    return [str stringByReplacingOccurrencesOfString:search withString:rep];
}

+ (BOOL)isBlank:(NSString *)str
{
    if (str == nil) {
        return YES;
    } else if ([str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNotBlank:(NSString *)str
{
    return ![StringUtils isBlank:str];
}

+ (NSArray *)split:(NSString *)str separator:(NSString *)separator
{
    if ([StringUtils isBlank:str]) {
        return [NSArray array];
    }
    return [str componentsSeparatedByString:separator];
}

/**
 * URLからパラメータを解析してNSDictionaryで返却する
 * http://www.paktolos.com/blog_entry_50.html
 */
+ (NSDictionary *)getParameterFromURL:(NSString *)strURL
{
    NSRange range;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    //  パラメータが存在するか確認する
    range = [strURL rangeOfString:@"?"];
    if ( range.location != NSNotFound ) {
        range.location = range.location + 1;
        range.length = [strURL length] - range.location;
        
        //  パラメータ部分を切り出す
        NSString *strParameter = [strURL substringWithRange:range];
        
        //  パラメータを分割する
        NSArray *params = [strParameter componentsSeparatedByString:@"&"];
        
        for ( int intI=0; intI<[params count]; intI++ ) {
            //  変数名と値に分割する
            NSString *strElement = [params objectAtIndex:intI];
            NSArray *namevalue = [strElement componentsSeparatedByString:@"="];
            
            NSString *strName = @"";
            NSString *strValue = @"";
            
            if ( [namevalue count] > 0 ) {
                strName = [namevalue objectAtIndex:0];
                NSLog(@"パラメータ分割 name:%@", strName);
            }
            
            if ( [namevalue count] > 1 ) {
                strValue = [namevalue objectAtIndex:1];
                NSLog(@"パラメータ分割 val:%@", strValue);
            }
            
            //  取り出した名前と値を設定する
            [result setObject:strValue forKey:strName];
        }
    }
    
    return result;
}

@end
