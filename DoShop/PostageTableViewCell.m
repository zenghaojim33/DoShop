//
//  PostageTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "PostageTableViewCell.h"

@implementation PostageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateCellWithModel:(DSPostage_ProvincesModel *)provinceModel
{
    self.province = provinceModel.province;
    self.provinceList.text = provinceModel.provinceValue;
    self.price.text = provinceModel.price.stringValue;
    self.provinceid  = provinceModel.provinceid;
    self.expressName.text = [NSString stringWithFormat:@"%@ :",provinceModel.postagename];
}


@end
