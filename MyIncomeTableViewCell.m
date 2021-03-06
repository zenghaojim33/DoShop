//
//  MyIncomeTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/2/13.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "MyIncomeTableViewCell.h"

@implementation MyIncomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellWithModel:(DSIncome_RecordModel *)recordModel
{
    self.timeLabel.text = recordModel.time;
    CGFloat  income = [recordModel.money floatValue];
    NSNumber * orderPrice = recordModel.orderprice;
    self.incomeLabel.text = [NSString stringWithFormat:@"￥%.2f",income];
    if ([orderPrice isEqualToNumber:@0]  || !orderPrice)
    {
        self.incomeDetail.text = [NSString stringWithFormat:@"提现"];
    }else{
        
        self.incomeDetail.text = [NSString stringWithFormat:@"好友消费%@获得佣金%.2f",orderPrice,income];
    }
    
    
    
    
}

@end



