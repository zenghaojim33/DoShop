//
//  NSString+md5.h
//  DoShop
//
//  Created by Anson on 15/5/8.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5)


+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

@end
