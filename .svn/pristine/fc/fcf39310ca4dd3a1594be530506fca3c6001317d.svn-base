//
//  OrderInfoTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/3/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSReturnInfo_ResultModel.h"
#import "DSOrderInfo_ResultModel.h"
@interface OrderInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDetail;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property(nonatomic,assign)NSInteger  productId;


-(void)updateCellWithReturnModel:(DSReturnInfo_ResultModel*)model;

-(void)updateCellWithOrderModel:(DSOrderInfo_ProductsModel *)model;
@end
