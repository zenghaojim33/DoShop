//
//  MyGoodsTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/2/28.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSNewGoodModel.h"
@class MyGoodsTableViewCell;
@protocol MyGoodsButtonDelegate <NSObject>

@optional
-(void)putGoodsOffSale:(NSNumber*)productID andCell:(UITableViewCell*)cell;
-(void)shareToSocialMedia:(MyGoodsTableViewCell*)cell;
-(void)copyAddress;

@end

@interface MyGoodsTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *productInfo;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *getOnSaleButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *URLCopyButton;
@property(nonatomic)NSNumber * productID;
@property(nonatomic,assign)id<MyGoodsButtonDelegate>delegate;



-(void)updateCellWithModel:(DSNewGoodModel *)model;

@end
