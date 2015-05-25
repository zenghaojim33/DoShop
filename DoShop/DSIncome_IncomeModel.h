//
//  DSIncome_IncomeModel.h
//  DoShop
//
//  Created by Anson on 15/4/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "DSBaseModel.h"
#import "DSIncome_RecordModel.h"
@interface DSIncome_IncomeModel : DSBaseModel

@property(nonatomic,copy)NSNumber * cashBalance;
@property(nonatomic,strong)NSMutableArray * records;
@property(nonatomic,copy)NSNumber * sum;

@end
