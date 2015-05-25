//
//  NewGoodTableViewCell.h
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewGoodTableViewCell;
@protocol GoodsButtonDelegate <NSObject>

@optional
-(void)putGoodsOnSale:(NSNumber*)productID andCell:(UITableViewCell*)cell;
-(void)shareToSocialMedia:(NewGoodTableViewCell*)cell;
-(void)copyAddress;

@end



@interface NewGoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UITextView *productInfo;

@property (weak, nonatomic) IBOutlet UIButton *getOnSaleButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *URLCopyButton;
@property(nonatomic)NSNumber * productID;
@property(nonatomic,assign)id<GoodsButtonDelegate>delegate;

-(void)setShareDisable;


@end
