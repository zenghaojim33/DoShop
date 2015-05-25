//
//  OrderInfoViewController.m
//  Dome
//
//  Created by BTW on 14/12/24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderInfoTableViewCell.h"
#import "DSOrderInfo_ResultModel.h"
#import "ExpressViewController.h"
#import "TTTAttributedLabel.h"
@interface OrderInfoViewController ()<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *BGView1;

@property (weak, nonatomic) IBOutlet UIImageView *BGView2;
@property (weak, nonatomic) IBOutlet UITableView *orderInfoTableView;


//下面是订单信息+收件人信息
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderAccount;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@property (weak, nonatomic) IBOutlet UILabel *receiverName;

@property (weak, nonatomic) IBOutlet  TTTAttributedLabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *postCode;
@property (weak, nonatomic) IBOutlet UILabel *postage;


@end
static NSString * cellidentifier = @"OrderInfo";

typedef NS_ENUM(NSInteger, OrderType){
    
    NotPaid = 0,
    Paid  = 1,
    Sent = 2,
    Received = 3,
    Finished = 4,
    Closed = 5
    
};


@implementation OrderInfoViewController

{
    
    

    DSOrderInfo_ResultModel * _orderInfoModel;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"订单详情";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    self.BGView1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView1.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView1.layer.shadowOpacity = 0.2;
    
    self.BGView2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView2.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView2.layer.shadowOpacity = 0.2;
    
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_ORDERINFO_API,self.orderModel.orderId] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {

        _orderInfoModel= [DSOrderInfo_ResultModel init:dict[@"result"]];

        
        [self setHeaderViewInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_orderInfoTableView reloadData];
        });
        
        
    }];
    
    
    
    
}


-(void)setHeaderViewInfo
{
    
    self.orderNum.text = _orderInfoModel.orderNo;
    self.orderAccount.text = _orderInfoModel.buyer;
    self.orderTime.text = _orderInfoModel.createTime;
    self.payTime.text = _orderInfoModel.payTime;
    NSInteger orderType = _orderInfoModel.statu;
    
    switch (orderType) {
            case NotPaid:
            self.orderStatus.text = @"未付款";
            break;
            case Paid:
            self.orderStatus.text = @"已付款";
            break;
            case Sent   :
            self.orderStatus.text = @"已发货";
            break;
            case Received :
            self.orderStatus.text = @"已签收";
            break;
            case Finished:
            self.orderStatus.text = @"已完成";
            break;
            case Closed:
            self.orderStatus.text = @"已关闭";
            break;
        default:
            break;
    }
    
    
    self.receiverName.text = _orderInfoModel.linkMan;
    self.phoneNum.delegate = self;
    self.phoneNum.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.phoneNum.text = _orderInfoModel.mobile;
    NSRange range = [self.phoneNum.text rangeOfString:_orderInfoModel.mobile];
    [self.phoneNum addLinkToPhoneNumber:self.phoneNum.text withRange:range];
    NSString * address = [NSString stringWithFormat:@"%@%@%@",_orderInfoModel.city,_orderInfoModel.county,_orderInfoModel.area];
    self.address.text = address;
    self.postCode.text = _orderInfoModel.postcode;
    self.postage.text = [NSString stringWithFormat:@"%@",_orderInfoModel.postage];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ------UITableView-------


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    DSOrderInfo_ProductsModel * productModel = _orderInfoModel.products[indexPath.row];
    [cell updateCellWithOrderModel:productModel];

    
    
    return cell;
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _orderInfoModel.products.count;
    
    
}


#pragma mark ---打电话
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    
    NSString *phoneURL = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
    
    
}


- (IBAction)expressInfoButtonClicked:(id)sender {
    
    NSString * emsName = [_orderInfoModel.emsName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * emsCode = _orderInfoModel.emsNum;
    
    ExpressViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpressViewController"];
    vc.emsName = emsName;
    vc.emsCode = emsCode;
    [self.navigationController pushViewController:vc animated:YES];
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
