//
//  RushOrdersInfoTableViewCell.h
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSOrder_ResultModel.h"
#import "DSOrder_ProductsModel.h"
@protocol OrderTableViewCellDelegate <NSObject>

-(void)sendMyGoodWithOrderID:(NSInteger )productid;

@end



@interface RushOrdersInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *OrdersImageView;
@property (weak, nonatomic) IBOutlet UILabel *OrdersTitle;
@property (weak, nonatomic) IBOutlet UILabel *BuyerLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrdersLastTime;
@property (weak, nonatomic) IBOutlet UILabel *OrdersPrice;
@property(nonatomic,assign)NSInteger  orderId;
@property(nonatomic,strong)NSString * orderNo;
@property(nonatomic,weak)id <OrderTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendProductButton;


-(void)updateCelllWithModel:(DSOrder_ResultModel*)model andType:(NSString *)type;

-(void)updateCellWithModelInCustomerManagement:(DSOrder_ResultModel*)model;
@end
