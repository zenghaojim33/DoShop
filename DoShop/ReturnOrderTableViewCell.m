//
//  ReturnOrderTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/3/23.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ReturnOrderTableViewCell.h"

@implementation ReturnOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}



-(void)updateCellWithModel:(DSReturn_ResultModel *)model
{
    NSString * productImg = model.productImg;
    NSString * orderNo = model.orderNo;
    NSString * backtime = model.backTime;
    NSInteger  backId = model.backId;
    NSNumber *  price = model.price;;
    
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,productImg]] placeholderImage:nil];
    self.backId = backId;
    self.orderNo.text = [NSString stringWithFormat:@"退货单号:%@",orderNo];
    self.price.text = [NSString stringWithFormat:@"￥%@",price];
    self.backTime.text = [NSString stringWithFormat:@"退货时间:%@",backtime];
    
    self.selectionStyle = UITableViewCellAccessoryNone;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.2;

}

@end
