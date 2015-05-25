//
//  HomeChildViewController.m
//  DoShop
//
//  Created by Anson on 15/2/12.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "HomeChildViewController.h"
#import "MyDomeViewController.h"
#import "CommodityViewController.h"
#import "CustomerViewController.h"
#import "MyIncomeViewController.h"
#import "AMScanViewController.h"
#import "OrderViewController.h"
#import "NewGoodViewController.h"
@interface HomeChildViewController ()

@end

@implementation HomeChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)clickMyShop:(id)sender {
    
    
    NSLog(@"我的店铺");
    MyDomeViewController * myDoShop = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDomeViewController"];
    [self.parentViewController.navigationController pushViewController:myDoShop animated:YES];
    
    
}
- (IBAction)clickNewGoods:(id)sender {
    
    NSLog(@"销售管理");
    NewGoodViewController * newGood = [self.storyboard instantiateViewControllerWithIdentifier:@"NewGoodViewController"];
    [self.parentViewController.navigationController pushViewController:newGood animated:YES];
    
}

- (IBAction)clickSalesManagement:(id)sender {
    NSLog(@"销售管理");
    CommodityViewController * commodity = [self.storyboard instantiateViewControllerWithIdentifier:@"CommodityViewController"];
    [self.parentViewController.navigationController pushViewController:commodity animated:YES];
}

- (IBAction)clickCheckMyOrder:(id)sender {
    
    
    
    
    NSLog(@"订单管理");
    OrderViewController * order = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
    [self.parentViewController.navigationController pushViewController:order animated:YES];
    
    
}

- (IBAction)clickMyWealth:(id)sender {
    
    
    NSLog(@"我的财富");
    MyIncomeViewController * myincome = [self.storyboard instantiateViewControllerWithIdentifier:@"MyIncomeViewController"];
    [self.parentViewController.navigationController pushViewController:myincome animated:YES];
    
}

- (IBAction)clickCustomerManagement:(id)sender {
    
    CustomerViewController * customer = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerViewController"];
    [self.parentViewController.navigationController pushViewController:customer animated:YES];

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
