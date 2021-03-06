//
//  NewGoodViewController.m
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "NewGoodViewController.h"
#import "NewGoodTableViewCell.h"
#import "SortGoodViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "Tools.h"
#import "DSNewGoodModel.h"
#import "CustomTitleLabelTableView.h"
#import "ProductDetailViewController.h"
#import "UIAlertView+Blocks.h"
#import <MJRefresh.h>
@interface NewGoodViewController ()<UITableViewDataSource,UITableViewDelegate,GoodsButtonDelegate,SortGoodsDelegate,UMSocialUIDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *onSaleButton;
@property (weak, nonatomic) IBOutlet CustomTitleLabelTableView  * productTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end
static NSString * cellIdentifier = @"NewGoodCell";
@implementation NewGoodViewController{
    
    
    NSMutableArray * _onSaleList;
    NSMutableArray * _productList;
    NSMutableArray * _indexPathArray;
    NSString * _sortKeyWord;
    NSInteger _page;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.productTableView.tableFooterView = [[UIView alloc]init];
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.productTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.productTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.searchTextField addTarget:self action:@selector(searchGoodsWithKeywords) forControlEvents:UIControlEventEditingDidEndOnExit];

    _productList = [[NSMutableArray alloc]init];
    _onSaleList = [[NSMutableArray alloc]init];
    _indexPathArray = [[NSMutableArray alloc]init];
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    //初始化页数1，关键字空
    
    _page=1;
    _sortKeyWord = @"";
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=down&size=15&index=%ld&key=%@",GET_PRODUCT_API,userid,(long)_page,_sortKeyWord] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        [_productList removeAllObjects];
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
  
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_productTableView reloadData];
        });
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ---------UITableViewDelegate--------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return _productList.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NewGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    DSNewGoodModel * model  = _productList[indexPath.row];
    
     NSString * imageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,model.mainImgUrl];
    cell.goodName.text = model.productName;
    cell.productID = model.modelId;
   
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    cell.productInfo.text = model.size;
    cell.delegate=self;
    
    //检查数组里是否存在这个cell对应的id，有的话就更改上架按钮的文字
    
    BOOL found = CFArrayContainsValue ( (__bridge CFArrayRef)_onSaleList,
                                        CFRangeMake(0, _onSaleList.count),
                                        (CFStringRef)cell.productID ) ;
    if (found)
    {
        cell.getOnSaleButton.selected = YES;
    }else{
        cell.getOnSaleButton.selected = NO;
    }
    
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewGoodTableViewCell * cell = (NewGoodTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSNumber * productID = cell.productID;
    
    ProductDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    
    vc.productId = productID;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ------GoodsButtonDelegate----


-(void)putGoodsOnSale:(NSNumber *)productID andCell:(UITableViewCell *)cell
{
    NSIndexPath * indexPath = [self.productTableView indexPathForCell:cell];
    
    if ([_onSaleList containsObject:productID])
    {
        [_onSaleList removeObject:productID];
        [_indexPathArray removeObject:indexPath];
    
    }else{
        [_onSaleList addObject:productID];
        [_indexPathArray addObject:indexPath];
    }
    
    
    [self.onSaleButton setTitle:[NSString stringWithFormat:@"上架商品(%lu)",(unsigned long)_onSaleList.count] forState:UIControlStateNormal];
    
}


-(void)shareToSocialMedia:(NewGoodTableViewCell *)cell
{
    
    
    [UIAlertView showWithTitle:@"请先将商品上架再使用分享功能"];
    
//    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
//    NSNumber * productID = cell.productID;
//    NSString * productName = cell.goodName.text;
//    UIImage * productImage = cell.goodImageView.image;
//    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
//    
//    if (isInstalledWeixin){
//        
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//        
//        NSString * link = [NSString stringWithFormat:PRODUCT_DETAIL_PAGE,productID,userid];
//        
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
//        
//        //如果得到分享完成回调，需要设置delegate为self
//        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAppKey shareText:productName shareImage:productImage shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina] delegate:self];
//        
//    }else{
//        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
//        av.tag = 999;
//        [av show];
//    }

    
    
}



-(void)copyAddress
{
//    
//    NSString * CopyStr = @"http://www.dome123.com";
//    
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    
//    pasteboard.string = CopyStr;
//    
//    [Tools showPromptToView:self.view atPoint:self.view.center withText:@"复制成功" duration:1.5];
    [UIAlertView showWithTitle:@"请先将商品上架再使用复制地址"];


    
}



//点击上架商品
- (IBAction)contirmOnSale:(UIBarButtonItem*)sender {
    if (_onSaleList.count==0)
    {
        return ;
    }
    
    
    
    NSMutableString * firstProductID = [NSMutableString stringWithFormat:@"%@",_onSaleList[0]];

    [_onSaleList enumerateObjectsUsingBlock:^(NSString * productID, NSUInteger idx, BOOL *stop) {
        if (idx>0)
        {
            [firstProductID appendFormat:@",%@",productID];
        }
    }];
    
    
    NSNumber * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSDictionary * postDict = @{@"userid":userid,
                                @"productid":firstProductID,
                                @"type":@"add",
                                };
    [HTTPRequestManager postURL:CONFIRM_ON_SALE_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        //确认上架后，删除掉已经上架的货物
        
        NSMutableIndexSet * indexPathNumbers = [[NSMutableIndexSet alloc]init];
        
        for (NSIndexPath * indexPath in _indexPathArray)
        {
            [indexPathNumbers addIndex:indexPath.row];
        }
        
        
        [_productList removeObjectsAtIndexes:indexPathNumbers];
        [self.productTableView beginUpdates];
        [self.productTableView deleteRowsAtIndexPaths:_indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [self.productTableView endUpdates];
        [_onSaleList removeAllObjects];
        [_indexPathArray removeAllObjects];
        [self.onSaleButton setTitle:[NSString stringWithFormat:@"上架产品(%lu)",(unsigned long)_onSaleList.count] forState:UIControlStateNormal];
        
    }];
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Sort"])
    {
        SortGoodViewController * vc = segue.destinationViewController;
        vc.delegate=self;
    }
}


#pragma mark -----SortGoodsDelegate-----

-(void)sortGoodsWithCategory:(NSString *)category andBrand:(NSString *)brand andSupplier:(NSString *)supplier
{
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=down&size=15&index=%ld&category=%@&brand=%@&supplier=%@",GET_PRODUCT_API,userid,(long)_page,category,brand,supplier] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        [_productList removeAllObjects];
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_productTableView reloadData];
            [_productTableView headerEndRefreshing];
        });
        
    }];
    
}


#pragma mark --------MJRefresh---------
//顶部刷新
-(void)headerRefresh
{
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    _page = 1;
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=down&size=15&index=%ld&key=%@",GET_PRODUCT_API,userid,(long)_page,_sortKeyWord] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        [_productList removeAllObjects];
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_productTableView reloadData];
            [_productTableView headerEndRefreshing];
        });
        
    }];
    
    
    
}

//底部刷新
-(void)footerRefresh
{
    
    NSString * userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    _page++;
    
    [HTTPRequestManager getURL:[NSString stringWithFormat:@"%@&userid=%@&select=down&size=15&index=%ld&key=%@",GET_PRODUCT_API,userid,(long)_page,_sortKeyWord] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSNewGoodModel * model = [DSNewGoodModel init:modelDict];
            [_productList addObject:model];
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_productTableView reloadData];
            [_productTableView footerEndRefreshing];
        });
    }];
    
    
    
    
    
}



-(void)searchGoodsWithKeywords
{
    
    _sortKeyWord = [self.searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self headerRefresh];

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
