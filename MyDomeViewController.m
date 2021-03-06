//
//  MyDomeViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MyDomeViewController.h"

#import "Tools.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "MyDomeTableViewCell.h"
@interface MyDomeViewController ()
<
    UMSocialUIDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (strong, nonatomic)  UIButton *EditorButton;
@property (strong, nonatomic)  UIButton *CopyButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)  UIButton *ShareButton;
@end

@implementation MyDomeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我的都美";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifier = @"Cell" ;
    
    
    MyDomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    float width = self.view.frame.size.width;
    
    UIButton * copyBth = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/2-1, 34)];
    [copyBth setBackgroundColor:[UIColor whiteColor]];
    [copyBth setTitle:@"复制地址" forState:UIControlStateNormal];
    [copyBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    copyBth.titleLabel.font = [UIFont systemFontOfSize:14.0];
    copyBth.tag = indexPath.row;
    [copyBth addTarget:self action:@selector(TouchCopyCellButton:) forControlEvents:UIControlEventTouchUpInside];
    [copyBth setImage:[UIImage imageNamed:@"25_link1.png"] forState:UIControlStateNormal];
    [cell.ButtonView addSubview:copyBth];
    
    UIButton * shareBth = [[UIButton alloc]initWithFrame:CGRectMake(width/2, 0, width/2, 34)];
    [shareBth setBackgroundColor:[UIColor whiteColor]];
    shareBth.titleLabel.font = [UIFont systemFontOfSize:14.0];
    shareBth.tag = indexPath.row;
    [shareBth addTarget:self action:@selector(TouchShareCellButton:) forControlEvents:UIControlEventTouchUpInside];
     [shareBth setImage:[UIImage imageNamed:@"25_share1.png"] forState:UIControlStateNormal];
    [shareBth setBackgroundImage:[UIImage imageNamed:@"CellBGView.png"] forState:UIControlStateNormal];
    [shareBth setTitle:@"分享到..." forState:UIControlStateNormal];
    [shareBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell.ButtonView addSubview:shareBth];
    
    
    
//    cell.layer.shadowColor = [UIColor blackColor].CGColor;
//    cell.layer.shadowOffset = CGSizeMake(1, 1);
//    cell.layer.shadowOpacity = 0.2;
    return cell;
}
#pragma mark 点击产品复制
-(void)TouchCopyCellButton:(UIButton*)button
{
    NSString * CopyStr = @"http://www.dome123.com";
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = CopyStr;
    
    [Tools showPromptToView:self.view atPoint:self.view.center withText:@"复制成功" duration:1.5];
}
#pragma mark 点击产品分享
-(void)TouchShareCellButton:(UIButton*)button
{
    //微信网页类型
    
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    
    if (isInstalledWeixin){
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        NSString *shareText = @"测试";             //分享内嵌文字
        UIImage *shareImage =[UIImage imageNamed:@"测试头像.png"];  //分享内嵌图片
        
        
        NSString * link = [NSString stringWithFormat:@"http://www.dome123.com"];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        
        //如果得到分享完成回调，需要设置delegate为self
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"54a350bffd98c51f0900012d" shareText:shareText shareImage:shareImage shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline] delegate:self];
        
    }else{
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
        av.tag = 999;
        [av show];
    }

}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    float width = self.view.frame.size.width/3-1;
    
    self.EditorButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    [self.EditorButton setBackgroundColor:[UIColor whiteColor]];
    [self.EditorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.EditorButton setTitle:@"编辑" forState:UIControlStateNormal];
    self.EditorButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.EditorButton addTarget:self action:@selector(TouchEditorButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.ButtonView addSubview:self.EditorButton];
    
    self.CopyButton = [[UIButton alloc]initWithFrame:CGRectMake(1+width, 0, width, 30)];
    [self.CopyButton setBackgroundColor:[UIColor whiteColor]];
    [self.CopyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.CopyButton setTitle:@"复制地址" forState:UIControlStateNormal];
    self.CopyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.CopyButton addTarget:self action:@selector(TouchCopyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.ButtonView addSubview:self.CopyButton];
    
    self.ShareButton = [[UIButton alloc]initWithFrame:CGRectMake(2+width*2, 0, width, 30)];
    [self.ShareButton setBackgroundColor:[UIColor whiteColor]];
    [self.ShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.ShareButton setTitle:@"分享到..." forState:UIControlStateNormal];
    self.ShareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.ShareButton addTarget:self action:@selector(TouchShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.ButtonView addSubview:self.ShareButton];
    
 
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
//    self.myTableView.tableHeaderView = [[UIView alloc] init];
//    self.myTableView.tableFooterView = [[UIView alloc] init];

    
     self.myTableView.tableHeaderView = self.userView;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyDomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView reloadData];
    // Do any additional setup after loading the view.
}
//- (void)TouchEditorButton:(UIButton*)button
//{
//    ChangInfoViewController * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"ChangInfoViewController"];
//    vc.isChange = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark 点击店铺复制
- (void)TouchCopyButton:(UIButton*)button
{
    NSString * CopyStr = @"http://www.dome123.com";
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = CopyStr;
    
    [Tools showPromptToView:self.view atPoint:self.view.center withText:@"复制成功" duration:1.5];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [av show];
        
        //Because November is luck month
    }
}
#pragma mark 点击店铺分享
- (void)TouchShareButton:(UIButton*)button
{
    //微信网页类型
    
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    
    if (isInstalledWeixin){
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        NSString *shareText = @"测试";             //分享内嵌文字
        UIImage *shareImage =[UIImage imageNamed:@"测试头像.png"];  //分享内嵌图片
        
        
        NSString * link = [NSString stringWithFormat:@"http://www.dome123.com"];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        
        //如果得到分享完成回调，需要设置delegate为self
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"54a350bffd98c51f0900012d" shareText:shareText shareImage:shareImage shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline] delegate:self];
        
    }else{
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
        av.tag = 999;
        [av show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==999&&buttonIndex==1)
    {
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/S8gTy.i"]];
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
