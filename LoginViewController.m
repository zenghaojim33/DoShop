//
//  LoginViewController.m
//  DoShop
//
//  Created by Anson on 15/2/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "LoginViewController.h"
#import "HomViewController.h"
#import "SSKeychain.h"
#import "NSString+md5.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

#define DoShopKeyChainService  @"DoShopKeyChainService"

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSString * encrptedPwd = [NSString getMd5_32Bit_String:@"123456"].uppercaseString;
    
    
    
    //如果有登陆过，就保留用户名
    NSString * phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    NSString * password = [SSKeychain passwordForService:DoShopKeyChainService account:phone];
    
    if (phone && password)
    {
        NSString * useridString = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        NSString * passwordString = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        self.userName.text = useridString;
        self.password.text = passwordString;
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  ------登录----------


- (IBAction)login:(id)sender {
    
    NSString * UUID = [NSString stringWithFormat:@"ios_%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"]];
    
    
    
    
    NSDictionary * dict = @{@"phone":self.userName.text,@"pwd":self.password.text,@"equipcode":UUID};
    
    
    if (self.userName.text.length==0 || self.userName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名和密码"];
    }else{
    
      [HTTPRequestManager postURL:LOGIN_API andParameter:dict onCompletion:^(NSDictionary *dict, NSError *error) {
        
        if (!error && [dict[@"ret"] isEqualToNumber:@1])
        {
            /**
             *  记录用户userid等信息
             */
            
            NSString * userid = [dict[@"result"] objectForKey:@"userid"];
            NSString * uimg = [NSString stringWithFormat:@"%@%@",BASE_URL,dict[@"result"][@"uimg"]];
            NSString * name = dict[@"result"][@"name"];
            NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:userid forKey:@"userid"];
            [userdefault setObject:uimg forKey:@"uimg"];
            [userdefault setObject:name forKey:@"name"];
            [userdefault setObject:self.userName.text forKey:@"phone"];
            //[userdefault setObject:self.password.text forKey:@"password"];
            [SSKeychain setPassword:self.password.text forService:DoShopKeyChainService account:self.userName.text];
            [userdefault synchronize];
            
            
            HomViewController * homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigarionController"];
            homeVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController presentViewController:homeVC animated:YES completion:nil];
        }
           
        
        
    }];
    }
    
    
    
    
    
    
    
    
    
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
