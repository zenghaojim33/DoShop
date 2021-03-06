//
//  HomViewController.m
//  DoShop
//
//  Created by Anson on 15/2/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "HomViewController.h"
#import "API&Key.h"
#import "HomeChildViewController.h"
#import "BWMCoverView.h"
#import "BWMCoverViewModel.h"
#import "UIAlertView+Blocks.h"
#import "ChangeInfoViewController.h"
#import "ChangeInfoViewController.h"
#import "BlocksKit+UIKit.h"
#import <Masonry.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface HomViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet BWMCoverView *topScrollview;

@end



@implementation HomViewController{
    BWMCoverView * _coverView;
}


-(void)viewDidLayoutSubviews
{
    
    if (!_coverView){
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    
    for (int i=0;i<3;i++)
    {
        
        NSString * urlstring = [[[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"%d",i+1] withExtension:@"png"] absoluteString];
        
        
        BWMCoverViewModel * model = [[BWMCoverViewModel alloc]initWithImageURLString:urlstring imageTitle:nil];
        
        
        
        [imageArray addObject:model];
        
        
        
    }
    NSLog(@"%@",NSStringFromCGRect(self.topScrollview.frame));
    _coverView = [BWMCoverView coverViewWithModels:imageArray andFrame:self.topScrollview.frame andPlaceholderImageNamed:nil andImageViewsContentMode:UIViewContentModeScaleToFill andClickdCallBlock:^(int index) {
        NSLog(@"clicked");
    } andScrolledCallBlock:^(int index) {
        NSLog(@"scrolled");
    }];
    
    [self.view addSubview:_coverView];
        
    }
    
    [self.view layoutSubviews];
    
    


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.149 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (_firstLogin)
    {
        DEF_WEAKSELF
        [UIAlertView bk_showAlertViewWithTitle:@"欢迎进入嘟店" message:@"请先完善您的个人资料" cancelButtonTitle:@"取消" otherButtonTitles:@[@"前往修改"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1){
                DEF_STRONGSELF
                ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        
        
        
        
    }
    
    

    


    
}


#pragma mark ------设置顶部scrollview--------




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"homelist"])
    {
        HomeChildViewController * homelist = segue.destinationViewController;
        [self addChildViewController:homelist];
        
    }
    
    
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
