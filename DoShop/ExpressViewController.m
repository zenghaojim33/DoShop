//
//  ExpressViewController.m
//  Dome
//
//  Created by BTW on 15/1/4.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ExpressViewController.h"
#import "UIWebView+AFNetworking.h"
@interface ExpressViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation ExpressViewController

- (void)viewDidLoad {

    
    self.title = @"快递详情";

    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:KUAIDI100,self.emsName,self.emsCode]]];
    
    [self.myWebView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        [SVProgressHUD showProgress:bytesWritten/totalBytesWritten status:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        
        
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [SVProgressHUD dismiss];
        return HTML;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
