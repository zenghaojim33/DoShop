//
//  NSString+md5.m
//  DoShop
//
//  Created by Anson on 15/5/8.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (md5)


+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH*1];
    //CC_MD5( cStr, strlen(cStr), digest ); 这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时
    CC_MD5( cStr, (int)srcString.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 1];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH*1; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

@end
