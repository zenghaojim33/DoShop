//
//  HTTPRequestManager.m
//  DoShop
//
//  Created by Anson on 15/2/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "HTTPRequestManager.h"
#import "SVProgressHUD.h"



@implementation HTTPRequestManager
static HTTPRequestManager * manager = nil;
static dispatch_once_t onceToken;


/**
 *  创建请求单例
 *
 *  @return 单例
 */
+(instancetype)sharedManager
{
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]initWithBaseURL:[NSURL URLWithString:@""]];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 5.0f;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                [manager.operationQueue cancelAllOperations];
                
            }
        }];
        
    });
    
    
    
    
    
    return manager;
}



/**
 *  封装的Post方法
 *
 *  @param url             接口URL
 *  @param param           接口字典参数
 *  @param completionBlock 成功的回调方法
 *
 *  @return 返回一个成功的执行的 AFHTTPRequestOperation类
 */
+(AFHTTPRequestOperation*)postURL:(NSString*)url andParameter:(NSDictionary*)param onCompletion:(responseBlock)completionBlock
{
    
    manager = [self sharedManager];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];

    return [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);

        if (responseObject && completionBlock)
        {
            if ([responseObject[@"ret"] isEqualToNumber:@1])
            {
                completionBlock(responseObject,nil);
                [SVProgressHUD showSuccessWithStatus:@"载入成功" maskType:SVProgressHUDMaskTypeNone];
            }
            else{
                NSString * errorMsg = responseObject[@"msg"];
                [SVProgressHUD showErrorWithStatus:errorMsg maskType:SVProgressHUDMaskTypeNone];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (error.code==-1001)
        {
            [SVProgressHUD showErrorWithStatus:@"请求超时" maskType:SVProgressHUDMaskTypeNone];
            return ;
        }

        if (completionBlock)
        {
            completionBlock(nil,error);
            [SVProgressHUD showErrorWithStatus:@"载入失败" maskType:SVProgressHUDMaskTypeNone];
        }
    }];
    
    
}


/**
 *  封装的Post方法
 *
 *  @param url             接口URL
 *  @param param           接口字典参数
 *  @param completionBlock 成功的回调方法
 *
 *  @return 返回一个成功的执行的 AFHTTPRequestOperation类
 */


+(AFHTTPRequestOperation*)getURL:(NSString*)url andParameter:(NSDictionary*)param onCompletion:(responseBlock)completionBlock
{
    manager = [self sharedManager];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack] ;

    return [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (responseObject && completionBlock)
        {
            if ([responseObject[@"ret"] isEqualToNumber:@1])
            {
                completionBlock(responseObject,nil);
                [SVProgressHUD showSuccessWithStatus:@"载入成功" maskType:SVProgressHUDMaskTypeNone];
            }else{
                NSString * errorMsg = responseObject[@"msg"];
                [SVProgressHUD showErrorWithStatus:errorMsg maskType:SVProgressHUDMaskTypeNone];
            }
            if (((NSArray*)responseObject[@"result"]).count==0)
            {
                [SVProgressHUD showSuccessWithStatus:@"没有更多数据了"];
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error.code==-1001)
        {
            [SVProgressHUD showErrorWithStatus:@"请求超时" maskType:SVProgressHUDMaskTypeNone];
            return ;
        }
        if (completionBlock)
        {
            completionBlock(nil,error);
            [SVProgressHUD showErrorWithStatus:@"载入失败" maskType:SVProgressHUDMaskTypeNone];
        }
    }];
    
    
}



+(AFHTTPRequestOperation *)postURLWithData:(NSData *)data andURL:(NSString *)url andParameter:(NSDictionary *)param onCompletion:(responseBlockWithStatusCode)completionBlock
{
    
    manager = [self sharedManager];
    [SVProgressHUD showWithStatus:@"正在更新个人信息..." maskType:SVProgressHUDMaskTypeBlack];
    
    return [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

    
        [formData appendPartWithFileData:data name:@"Filedata" fileName:@"Filedata.jpeg" mimeType:@"image/jpg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        
        if (operation.response.statusCode == 200 && completionBlock)
        {
                completionBlock(operation.response.statusCode == 200,nil);
                [SVProgressHUD showSuccessWithStatus:@"修改信息成功" maskType:SVProgressHUDMaskTypeNone];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"修改信息失败" maskType:SVProgressHUDMaskTypeNone];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        if (error.code==-1001)
        {
            [SVProgressHUD showErrorWithStatus:@"请求超时" maskType:SVProgressHUDMaskTypeNone];
            return ;
        }
        if (completionBlock)
        {
            completionBlock(0,error);
            [SVProgressHUD showErrorWithStatus:@"修改信息失败" maskType:SVProgressHUDMaskTypeNone];
        }
    }];
    
    
}








@end
