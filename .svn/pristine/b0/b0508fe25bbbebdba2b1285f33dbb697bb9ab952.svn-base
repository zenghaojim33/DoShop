//
//  RegisterViewController.m
//  DoShop
//
//  Created by Anson on 15/2/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegExpValidate.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *AuthCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextfield;
@property (weak, nonatomic) IBOutlet UITextField *storeIDTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getAuthoCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
#pragma mark -----------注册---------
    
    
}

- (IBAction)getAuthCode:(id)sender {
    
    //获取验证码
    
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
- (IBAction)registerButtonClicked:(id)sender {
    
    if ([self checkInfoValidity]){
        
        NSDictionary * registerDict =
        @{@"phone":self.phoneNumTextfield.text,
          @"pwd":self.passwordTextfield.text,
          @"code":self.AuthCodeTextfield.text,
          @"inviteCode":self.storeIDTextfield.text
          };

        
        [HTTPRequestManager postURL:REGISTER_API andParameter:registerDict onCompletion:^(NSDictionary *dict, NSError *error) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        }];
        
        
        
    }

}



-(BOOL)checkInfoValidity{
    if (![self.passwordTextfield.text isEqualToString:self.passwordConfirmTextfield.text])
    {
        [self showAlertViewForTitle:@"错误" AndMessage:@"两次输入的密码不一致"];
        return NO;
    }
    
    
    if (![RegExpValidate validateMobile:self.phoneNumTextfield.text])
    {
        [self showAlertViewForTitle:@"错误" AndMessage:@"输入的手机号码不合法"];
        return NO;
    }
    

    return YES;
    
    
}




-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
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
