//
//  SettingViewController.m
//  Dome
//
//  Created by BTW on 14/12/22.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "AMScanViewController.h"
#import "QRCodeReaderView.h"
#import "SSKeychain.h"
@interface SettingViewController ()<UIActionSheetDelegate,AMScanViewControllerDelegate>
{

}
@property (weak, nonatomic) IBOutlet UIView *BGView1;
@property (weak, nonatomic) IBOutlet UIView *BGView2;
@property (weak, nonatomic) IBOutlet UIView *BGView3;
@property (weak, nonatomic) IBOutlet UIView *BGView4;
@end

#define DoShopKeyChainService  @"DoShopKeyChainService"


@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"设置";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";

    self.navigationItem.backBarButtonItem = backItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BGView1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView1.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView1.layer.shadowOpacity = 0.1;
    
    self.BGView2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView2.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView2.layer.shadowOpacity = 0.1;
    
    self.BGView3.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView3.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView3.layer.shadowOpacity = 0.1;
    
    self.BGView4.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView4.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView4.layer.shadowOpacity = 0.1;
    
    // Do any additional setup after loading the view.
}
#pragma mark ----扫描二维码

- (IBAction)scanQRCode:(id)sender {
    
    
    AMScanViewController * scanner = [[AMScanViewController alloc]init];
    scanner.delegate=self;
    
    [self.navigationController pushViewController:scanner animated:YES];
    
    
}





#pragma mark 退出当前账号
- (IBAction)TouchQuit:(UIButton *)sender
{
    UIActionSheet * actionSheet =
    [[UIActionSheet alloc]initWithTitle:nil
                               delegate:nil
                      cancelButtonTitle:@"取消"
                 destructiveButtonTitle:@"退出"
                      otherButtonTitles:nil];
    actionSheet.delegate=self;//有时不调用时需要输入这句话
    [actionSheet showInView:self.view];
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    if (buttonIndex==0) {
        NSString * phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        
        [SSKeychain deletePasswordForService:DoShopKeyChainService account:phone];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{ NSLog(@"您选择了取消");}
};
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------二维码扫描回调-------


-(void)scanViewController:(AMScanViewController *)aCtler didSuccessfullyScan:(NSString *)aScannedValue
{
    
    [aCtler stopScanning];

    [aCtler.navigationController popViewControllerAnimated:YES];
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSDictionary * postDict = @{@"userid":userid,@"parentid":aScannedValue};
    [HTTPRequestManager postURL:SCAN_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
        NSLog(@"%@",dict[@"msg"]);
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
