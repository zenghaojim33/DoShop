//
//  RushOrdersInfoTableViewCell.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "RushOrdersInfoTableViewCell.h"

@implementation RushOrdersInfoTableViewCell

typedef NS_ENUM(NSInteger, OrderType){
    
    NotPaid = 0,
    Paid  = 1,
    Sent = 2,
    Received = 3,
    Finished = 4,
    Closed = 5
    
};


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)sendMyProduct:(id)sender {
    
    
    
    
    [self.delegate sendMyGoodWithOrderID:self.orderId];
    
    
}


-(void)updateCelllWithModel:(DSOrder_ResultModel *)model andType:(NSString *)type
{
    DSOrder_ProductsModel * product = model.products[0];
    NSString * orderImg = product.productImg;
    NSString * createTime = [NSString stringWithFormat:@"下单时间:%@",model.createTime];
    NSInteger orderID = model.orderId;
    NSString * orderNo = model.orderNo;
    NSNumber *  price = model.price;
    [self.OrdersImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,orderImg]] placeholderImage:nil];
    self.orderId = orderID;
    self.OrdersLastTime.text = createTime;
    self.orderNo = orderNo;
    self.OrdersPrice.text = [NSString stringWithFormat:@"￥%@",price];
    self.BuyerLabel.text = model.buyer;
    self.OrdersTitle.text = model.orderNo;
    self.selectionStyle = UITableViewCellAccessoryNone;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.2;
    
    
    if (![type isEqualToString:@"1"])
    {
        self.sendProductButton.hidden=YES;
    }else{
        self.sendProductButton.hidden=NO;
    }

}


-(void)updateCellWithModelInCustomerManagement:(DSOrder_ResultModel *)model
{
    DSOrder_ProductsModel * productModel = model.products[0];
    NSString * orderImg = productModel.productImg;
    NSString * createTime = model.createTime;
    NSInteger  orderID = model.orderId;
    NSString * orderNo = model.orderNo;
    self.orderId = orderID;
    self.BuyerLabel.text = model.buyer;
    self.OrdersTitle.text = model.orderNo;
    self.OrdersLastTime.text = [NSString stringWithFormat:@"下单时间:%@",createTime];
    self.orderNo = orderNo;
    self.OrdersPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    [self.OrdersImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,orderImg]] placeholderImage:[UIImage imageNamed:@"测试头像"]];
    self.statusLabel.hidden = NO;
    self.sendProductButton.hidden = YES;
    
    NSInteger orderType = model.statu;
    switch (orderType) {
        case NotPaid:
            self.statusLabel.text = @"未付款";
            break;
        case Paid:
            self.statusLabel.text = @"已付款";
            break;
        case Sent   :
            self.statusLabel.text = @"已发货";
            break;
        case Received :
            self.statusLabel.text = @"已签收";
            break;
        case Finished:
            self.statusLabel.text = @"已完成";
            break;
        case Closed:
            self.statusLabel.text = @"已关闭";
            break;
        default:
            break;
    }
    
}

@end
