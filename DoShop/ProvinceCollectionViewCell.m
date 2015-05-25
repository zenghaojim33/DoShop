//
//  ProvinceCollectionViewCell.m
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "ProvinceCollectionViewCell.h"

@implementation ProvinceCollectionViewCell

-(void)awakeFromNib
{
    
    
    self.provinceLabel.layer.borderWidth = 1;
    self.provinceLabel.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.provinceLabel.layer.cornerRadius = 3;
    
    self.cellSelected = NO;
}

//-(void)setCollectionViewCellSelected
//{
//    if (!self.cellSelected)
//    {
//        self.provinceLabel.textColor = [UIColor whiteColor];
//        self.provinceLabel.backgroundColor = [UIColor colorWithRed:0.737 green:0.180 blue:0.197 alpha:1.000];
//        
//    }
//    
//    self.cellSelected = !self.cellSelected;
//    
//}


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (selected) {
        self.provinceLabel.backgroundColor = [UIColor colorWithRed:0.737 green:0.180 blue:0.197 alpha:1.000];
        [self.provinceLabel setTextColor:[UIColor whiteColor]];
    } else{
        
        self.provinceLabel.backgroundColor = [UIColor whiteColor];
        [self.provinceLabel setTextColor:[UIColor blackColor]];

    }

    
    
}







-(void)setCollectionViewCellUserInteractionUnable
{
    
    
    self.userInteractionEnabled=NO;
    self.provinceLabel.backgroundColor = [UIColor whiteColor];
    self.provinceLabel.textColor = [UIColor colorWithWhite:0.760 alpha:1.000];

    
}


@end
