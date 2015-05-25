//
//  MessageInfoViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MessageInfoViewController.h"
#import "UIWebView+AFNetworking.h"
@interface MessageInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *messageInfoWebView;

@end

@implementation MessageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息详情";
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_MESSAGEINFO_API,self.messageId]]];
    
    [self.messageInfoWebView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
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
