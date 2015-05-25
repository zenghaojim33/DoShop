//
//  CustomerTableViewCell.m
//  Dome
//
//  Created by BTW on 14/12/24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "CustomerTableViewCell.h"

@implementation CustomerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellWithModel:(DSCustomer_ResultModel *)model
{
    self.selectionStyle = UITableViewCellAccessoryNone;
    
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.2;
    
    self.customerName.text = model.name;
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,model.imgUrl];
    
    
    [self.customerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    self.totlaConsumption.text = [NSString stringWithFormat:@"￥%@",model.turnover];
    self.buyerid = [NSString stringWithFormat:@"%ld",model.buyerid];
    [[SDImageCache sharedImageCache]storeImage:self.customerImageView.image forKey:self.buyerid];
    
}

@end
