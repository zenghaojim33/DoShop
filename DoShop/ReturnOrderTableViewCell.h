//
//  ReturnOrderTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/3/23.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSReturn_ResultModel.h"
@interface ReturnOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *backTime;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property(nonatomic,assign)NSInteger  backId;

-(void)updateCellWithModel:(DSReturn_ResultModel*)model;


@end
