//
//  ProvinceCollectionViewCell.h
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (nonatomic)BOOL cellSelected;


-(void)setCollectionViewCellUserInteractionUnable;



@end
