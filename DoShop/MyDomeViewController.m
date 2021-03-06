//
//  MyDomeViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MyDomeViewController.h"
#import "Tools.h"
#import "MyGoodsTableViewCell.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "NewGoodTableViewCell.h"
#import "ChangeInfoViewController.h"
#import "CustomTitleLabelTableView.h"
#import "ProductDetailViewController.h"
#import "DSNewGoodModel.h"
#import "DSUserInfoModel.h"
#import <MJRefresh.h>
@interface MyDomeViewController ()
<
    UMSocialUIDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    MyGoodsButtonDelegate,
    UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (strong, nonatomic)  UIButton *EditorButton;
@property (strong, nonatomic)  UIButton *CopyButton;
@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView * myTableView;
@property (strong, nonatomic)  UIButton *ShareButton;
@property (weak, nonatomic) IBOutlet UIImageView *myAvatar;
@property (weak, nonatomic) IBOutlet UILabel *myShopName;
@property (weak, nonatomic) IBOutlet UILabel *myShopurl;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

#define AvatarUpdateNotification @"AvatarUpdateNotification"
#define UserInfoCacheKey @"userinfo"

static NSString *CellIdentifier = @"MyGoodCell" ;

@implementation MyDomeViewController
{
    
    
    NSMutableArray * _productList;
    NSMutableArray * _indexPathArray;
    NSString * _offSaleProductID;
    NSInteger _page;
    NSString * _key;
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我的店铺";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    
    
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    MyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DSNewGoodModel * model = _productList[indexPath.row];
    [cell updateCellWithModel:model];
    cell.delegate=self;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyGoodsTableViewCell * cell = (MyGoodsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSNumber * productID = cell.productID;
    
    ProductDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    
    vc.productId = productID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}




#pragma mark 点击产品复制
-(void)TouchCopyCellButton:(UIButton*)button
{
    NSString * CopyStr = @"http://www.dome123.com";
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = CopyStr;
    
    [Tools showPromptToView:self.view atPoint:self.view.center withText:@"复制成功" duration:1.5];
}






- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    self.myShopName.text = [NSString stringWithFormat:@"%@的小店",name];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAvatar:) name:AvatarUpdateNotification object:nil];
    
    [self.searchTextField addTarget:self action:@selector(searchOrderWithKeywords) forControlEvents:UIControlEventEditingDidEndOnExit];
    DSUserInfoModel * userInfo = [DSUserInfoModel cacheObjectByKey:UserInfoCacheKey];
    [self.myAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,userInfo.uimg]] placeholderImage:[UIImage imageNamed:@"测试头像"]];
    
    /**
     *  获取信息
     */
    _productList = [[NSMutableArray alloc]init];
    _indexPathArray = [[NSMutableArray alloc]init];
    _page = 1;
    _key = @"";
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=up&size=15&index=%ld&key=%@",GET_PRODUCT_API,userid,(long)_page,_key] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTableView reloadData];
        });
    }];
    
    
    
    
    [self createDockButtons];
    
    

}


-(void)createDockButtons
{
    
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
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    
}


- (void)TouchEditorButton:(UIButton*)button
{
    ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


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
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"54a350bffd98c51f0900012d" shareText:shareText shareImage:shareImage shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToEmail,UMShareToSms] delegate:self];
        
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
    }else if (alertView.tag==888 && buttonIndex==1)
    {
        
        //确认下架
        NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        NSDictionary * postDict = @{@"userid":userid,
                                    @"type":@"down",
                                    @"productid":_offSaleProductID
                                    
                                    };
        
        
        [HTTPRequestManager postURL:CONFIRM_ON_SALE_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
            
            NSMutableIndexSet * indexPathNumbers = [[NSMutableIndexSet alloc]init];
            
            for (NSIndexPath * indexPath in _indexPathArray)
            {
                [indexPathNumbers addIndex:indexPath.row];
            }
            
            [_productList removeObjectsAtIndexes:indexPathNumbers];
            [self.myTableView beginUpdates];
            [self.myTableView deleteRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            [self.myTableView endUpdates];
            [_indexPathArray removeAllObjects];
        }];
        
        
        
    }
}



#pragma mark --------MyGoodButtonDelegate------


-(void)putGoodsOffSale:(NSNumber *)productID andCell:(UITableViewCell *)cell
{
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认下架此商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 888;
    [alertView show];
    

    
    
    _offSaleProductID = productID.stringValue;
    
    
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
    
    
    
    //将indexpath记录到数组里
    if ([_indexPathArray containsObject:indexPath])
    {
        [_indexPathArray removeObject:indexPath];
    }else{
        [_indexPathArray addObject:indexPath];
    }
    
    
}


-(void)copyAddress
{
    
    
    NSString * CopyStr = @"http://www.dodovan.com";
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = CopyStr;
    
    [Tools showPromptToView:self.view atPoint:self.view.center withText:@"复制成功" duration:1.5];
    
}



-(void)shareToSocialMedia:(MyGoodsTableViewCell *)cell
{
    
    NSNumber * productID = cell.productID;
    UIImage * productImage = cell.goodImageView.image;
    NSString * productName = cell.goodName.text;
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    
    if (isInstalledWeixin){
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            //分享内嵌文字
        UIImage *shareImage = productImage;  //分享内嵌图片
        
        
        NSString * link = [NSString stringWithFormat:PRODUCT_DETAIL_PAGE,productID,userid];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        
        //如果得到分享完成回调，需要设置delegate为self
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:productName shareImage:shareImage shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToEmail,UMShareToSms] delegate:self];
        
    }else{
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
        av.tag = 999;
        [av show];
    }
    
    
    
}



//顶部刷新
-(void)headerRefresh
{
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    _page = 1;
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=up&size=15&index=%ld&key=%@",GET_PRODUCT_API,userid,(long)_page,_key] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        [_productList removeAllObjects];
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTableView reloadData];
            [self.myTableView headerEndRefreshing];
        });
        
    }];
    
    
    
}

//底部刷新
-(void)footerRefresh
{
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    _page++;
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=up&size=15&index=%ld&key=%@",GET_PRODUCT_API,userid,(long)_page,_key] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTableView reloadData];
            [self.myTableView footerEndRefreshing];
        });
    }];
    
    
    
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}


#pragma mark --------头像更新--------
-(void)updateAvatar:(NSNotification*)noti
{
    UIImage * updatedAvatar = noti.object;
    
    [self.myAvatar setImage:updatedAvatar];
    
}

#pragma mark --------商品搜索--------

-(void)searchOrderWithKeywords
{
    _key = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self headerRefresh];
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    _key = @"";
    [self headerRefresh];
    return YES;
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
