//
//  ReturnInfoViewController.m
//  DoShop
//
//  Created by Anson on 15/3/23.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ReturnInfoViewController.h"
#import "OrderInfoTableViewCell.h"
#import "ReturnDetailViewController.h"
#import "DSReturnInfo_ResultModel.h"
#import "ExpressViewController.h"
#import "TTTAttributedLabel.h"
@interface ReturnInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *returnOrderTableView;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *buyer;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *reason;
@property (weak, nonatomic) IBOutlet UILabel *backTime;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *linkman;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *statu;
@property (nonatomic,assign)NSInteger backType;
@property (weak, nonatomic) IBOutlet UIButton *confirmRefundBtn;
@end
static NSString * cellIdentifier = @"returnCell";



typedef NS_ENUM(NSInteger, OrderType){
    
    ApplyForReturn = 4,
    Agree  = 5,
    NotAgree = 6,
    InReturn = 7,
    Success = 8,
    
};

@implementation ReturnInfoViewController{
    
    NSMutableArray * _returnInfoArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    
    
    
    _returnInfoArray = [[NSMutableArray alloc]init];
    [HTTPRequestManager getURL:[NSString stringWithFormat:GET_BACKLISTINFO_API,self.returnModel.backId] andParameter:nil onCompletion:^(NSDictionary *dict, NSError *error) {
        
        
        for (NSDictionary * modelDict in dict[@"result"])
        {
            DSReturnInfo_ResultModel * model = [DSReturnInfo_ResultModel init:modelDict];
            [_returnInfoArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            DSReturnInfo_ResultModel * model = _returnInfoArray[0];
            self.orderNo.text = model.orderNo;
            self.buyer.text = model.buyer;
            self.createTime.text = model.createTime;
            self.payTime.text = model.payTime;
            NSInteger  orderType =model.statu;
            
            switch (orderType) {
                    case ApplyForReturn:
                    self.statu.text = @"申请退货中";
                    break;
                    case Agree:
                    self.statu.text = @"同意退货";
                    break;
                    case InReturn   :
                    self.statu.text = @"退货中";
                    break;
                    case NotAgree :
                    self.statu.text = @"不同意退货";
                    break;
                    case Success:
                    self.statu.text = @"退货成功";
                    break;

                default:
                    break;
            }
            
            
            if (orderType == InReturn){
                self.confirmRefundBtn.hidden = NO;
            }
            
            self.reason.text = model.reason;
            self.backTime.text = model.backTime;
            self.price.text = [NSString stringWithFormat:@"%@",model.price];
            self.linkman.text = model.linkman;
            self.phone.delegate = self;
            self.phone.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            self.phone.text = model.phone;
            NSRange range = [self.phone.text rangeOfString:model.phone];
            [self.phone addLinkToPhoneNumber:self.phone.text withRange:range];
            self.address.text = model.address;
            self.backType = model.backType;
            [self.returnOrderTableView reloadData];
        });
    }];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    DSReturnInfo_ResultModel * model = _returnInfoArray[0];
    [cell updateCellWithReturnModel:model];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _returnInfoArray.count;
}

- (IBAction)returnDetailButtonClicked:(id)sender {
    
    ReturnDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReturnDetailViewController"];
    vc.backid = self.returnModel.backId;
    vc.backType = self.backType;
    vc.reason = self.reason.text;
    
    DSReturnInfo_ResultModel * model = _returnInfoArray[0];
    vc.thimgUrl = model.thimg;
    vc.detailId = model.detailId;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}
- (IBAction)confirmRefund:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确认" message:@"请确认是否同意将此订单退款" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1){
        
        
        NSDictionary * postDict = @{@"backid":@(self.returnModel.backId),
                                    @"merchantType":@(2)
                                    
                                    };
        
        [HTTPRequestManager postURL:CONFIRM_REFUND_API andParameter:postDict onCompletion:^(NSDictionary *dict, NSError *error) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TableViewReloadNotification" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
    }
    
    
}

#pragma mark ---打电话
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    
    NSString *phoneURL = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
    
    
}



- (IBAction)checkExpressDetail:(id)sender {
    
    DSReturnInfo_ResultModel * _orderInfoModel = _returnInfoArray[0];
    
    NSString * emsName = _orderInfoModel.emsName;
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
