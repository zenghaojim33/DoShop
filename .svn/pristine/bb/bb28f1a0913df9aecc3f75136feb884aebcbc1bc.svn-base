//
//  HTTPRequestManager.h
//  DoShop
//
//  Created by Anson on 15/2/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface HTTPRequestManager : AFHTTPRequestOperationManager
typedef void(^responseBlock)(NSDictionary* dict, NSError *error);
typedef void(^responseBlockWithStatusCode)(NSInteger statusCode, NSError *error);

+(instancetype)sharedManager;

+(AFHTTPRequestOperation*)postURL:(NSString*)url andParameter:(NSDictionary*)param onCompletion:(responseBlock)completionBlock;
+(AFHTTPRequestOperation*)getURL:(NSString*)url andParameter:(NSDictionary*)param onCompletion:(responseBlock)completionBlock;
+(AFHTTPRequestOperation *)postURLWithData:(NSData *)data andURL:(NSString *)url andParameter:(NSDictionary *)param onCompletion:(responseBlockWithStatusCode)completionBlock;


@end
