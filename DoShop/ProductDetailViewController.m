//
//  ProductDetailViewController.m
//  DoShop
//
//  Created by Anson on 15/4/1.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UIWebView+AFNetworking.h"
@implementation ProductDetailViewController


-(void)viewDidLoad
{
    
    self.title = @"商品详情";
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:PRODUCT_DETAIL_PAGE,self.productId,userid]]];
    
    [self.ProductDetailWebView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:bytesWritten/totalBytesWritten status:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        
        
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [SVProgressHUD dismiss];
        return HTML;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
    
}

@end
