//
//  SupplierTableViewCell.m
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "SupplierTableViewCell.h"

@implementation SupplierTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.checkButton setImage:[UIImage imageNamed:@"checked_button"] forState:UIControlStateSelected];
    [self.checkButton setImage:[UIImage imageNamed:@"uncheck_button"] forState:UIControlStateNormal];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
    
    
}

@end
