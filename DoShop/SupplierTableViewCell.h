//
//  SupplierTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplierTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *supplierName;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property(nonatomic)NSString * cellID;

@end
