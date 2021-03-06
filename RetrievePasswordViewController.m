//
//  RetrievePasswordViewController.m
//  DoShop
//
//  Created by Anson on 15/2/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "UIAlertView+Blocks.h"
@interface RetrievePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *autoCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getAuthoCodeButton;

@end

@implementation RetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden=NO;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)getAutoCode:(id)sender {
    NSDictionary * postDict = @{@"phone":self.phoneNumTextfield.text};
    [HTTPRequestManager postURL:GET_AUTH_CODE_CPi andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        
    }];
    
    
    
    
    
    
    
    
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getAuthoCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.getAuthoCodeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.getAuthoCodeButton setTitle:[NSString stringWithFormat:@"请等待%@秒",strTime] forState:UIControlStateNormal];
                self.getAuthoCodeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)confirm:(id)sender {
    
    if (![self.phoneNumTextfield.text isEqualToString:self.passwordTextfield.text]){
        [UIAlertView showWithTitle:@"两次输入的密码不一致"];
        return;
    }
    
    
    NSDictionary * postDict = @{@"phone":self.phoneNumTextfield.text,
                                @"pwd":self.passwordTextfield.text,
                                @"code":self.autoCodeTextfield.text};
    
    [HTTPRequestManager postURL:RESET_PASSWORD_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
    
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
    }];
    
    

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
