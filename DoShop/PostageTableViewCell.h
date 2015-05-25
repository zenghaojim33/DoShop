//
//  PostageTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPostage_ResultModel.h"
@interface PostageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *provinceList;
@property (nonatomic,strong)NSNumber * provinceid;
@property (nonatomic,strong)NSString * province;
@property (weak, nonatomic) IBOutlet UILabel *expressName;



-(void)updateCellWithModel:(DSPostage_ProvincesModel *)cell;

@end
