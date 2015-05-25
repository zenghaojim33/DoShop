//
//  NSString+MyContainsString.m
//  DoShop
//
//  Created by Anson on 15/3/12.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "NSString+MyContainsString.h"

@implementation NSString (MyContainsString)

- (BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}



@end
