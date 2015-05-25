//
//  MyIncomeTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/2/13.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSIncome_RecordModel.h"
@interface MyIncomeTableViewCell : UITableViewCell
/**
 *  收入时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  收入金额
 */
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

/**
 *  收入详情
 */
@property (weak, nonatomic) IBOutlet UILabel *incomeDetail;


-(void)updateCellWithModel:(DSIncome_RecordModel*)recordModel;

@end
