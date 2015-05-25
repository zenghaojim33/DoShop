//
//  NewGoodTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "NewGoodTableViewCell.h"

@implementation NewGoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [UIView setAnimationsEnabled:NO];

    [self.getOnSaleButton setTitle:@"取消上架" forState:UIControlStateSelected];
    [self.getOnSaleButton setTitle:@"上架商品" forState:UIControlStateNormal];
    [UIView setAnimationsEnabled:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)putGoodsOnSale:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(putGoodsOnSale:andCell:)])
    {
        [self.delegate putGoodsOnSale:self.productID andCell:self];
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


-(void)setShareDisable
{
    [self.shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
}






@end
