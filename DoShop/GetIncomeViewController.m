//
//  GetIncomeViewController.m
//  DoShop
//
//  Created by Anson on 15/3/6.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "GetIncomeViewController.h"
#import "ChangeInfoViewController.h"
#import "RegExpValidateFormat.h"
#import "UIAlertView+Blocks.h"
#import "BlocksKit+UIKit.h"
@interface GetIncomeViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

@implementation GetIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.moneyTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventAllEditingEvents];
}


- (IBAction)applyImmediately:(id)sender {
    
    
    NSString * money = self.moneyTextfield.text;
    NSString * password = self.passwordTextfield.text;
    if (self.moneyTextfield.text.length==0)
    {
        [UIAlertView bk_alertViewWithTitle:@"请输入提现金额"];
        return;
    }
    
    if (self.passwordTextfield.text.length==0){
        [UIAlertView bk_alertViewWithTitle:@"请输入登录密码"];
        return;
    }
    
    
    [UIAlertView bk_showAlertViewWithTitle:@"确认提现" message:[NSString stringWithFormat:@"%@元将会提现到你的账户",self.moneyTextfield.text] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
       
        if (buttonIndex==1)
        {
            
            NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
            NSDictionary * postDict = @{@"UserID":userid,
                                        @"pwd":password,
                                        @"AMOUNT":money};
            [HTTPRequestManager postURL:WITHDRAW_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
                
                self.moneyTextfield.text = @"";
                self.passwordTextfield.text = @"";
                
                
            }];
            
        }
        
    }];
    
}


- (IBAction)enterMyAccount:(id)sender {
    
    ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(void)textFieldDidChange:(UITextField*)textfield
{
    [RegExpValidateFormat formatToPriceStringWithTextField:textfield];
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
