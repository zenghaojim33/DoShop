//
//  OrderInfoTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/3/4.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "OrderInfoTableViewCell.h"

@implementation OrderInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundImageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.backgroundImageView.layer.shadowOpacity = 0.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateCellWithReturnModel:(DSReturnInfo_ResultModel *)model
{
    
    self.productName.text = model.productName;
    self.productId = model.productId;
    self.productDetail.text = model.size;
    NSNumber * price = model.price;
    NSInteger number = model.number;
    NSNumber * allPrice = model.allprice;
    self.productPrice.text = [NSString stringWithFormat:@"￥%@x%ld =￥%@",price,number,allPrice];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.productImg] placeholderImage:nil];
    
}



-(void)updateCellWithOrderModel:(DSOrderInfo_ProductsModel *)model
{
    self.productName.text = model.productName;
    self.productId = model.productId;
    self.productDetail.text = model.size;
    NSNumber * price = model.price;
    NSInteger number = model.number;
    NSNumber * allPrice = model.allPrice;
    self.productPrice.text = [NSString stringWithFormat:@"￥%@x%ld =￥%@",price,number,allPrice];
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.productImg] placeholderImage:nil];
}

@end
