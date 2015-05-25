//
//  MyGoodsTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/2/28.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "MyGoodsTableViewCell.h"

@implementation MyGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)putGoodsOffSale:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(putGoodsOffSale: andCell:)])
    {
    
        [self.delegate putGoodsOffSale:self.productID andCell:self];
        self.getOnSaleButton.selected = !self.getOnSaleButton.selected;
        
        
    }
}



- (IBAction)copyAddress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(copyAddress)])
    {
        [self.delegate copyAddress];
    }
}



- (IBAction)share:(id)sender {
    
    
    
    if ([self.delegate respondsToSelector:@selector(shareToSocialMedia:)])
    {
        [self.delegate shareToSocialMedia:self];
    }
    
}


-(void)updateCellWithModel:(DSNewGoodModel *)model
{
    NSString * imgUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,model.mainImgUrl];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    self.goodName.text = model.productName;
    self.productInfo.text = model.size;
    self.timeLabel.text = [NSString stringWithFormat:@"上架时间:%@",model.usetime];
    self.productID = model.modelId;
    self.saleNum.text = [NSString stringWithFormat:@"销量:%ld",model.saleNum];
    
    
    
    
    
}


@end
