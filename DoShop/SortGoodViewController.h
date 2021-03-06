//
//  SortGoodViewController.h
//  DoShop
//
//  Created by Anson on 15/2/15.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortGoodsDelegate <NSObject>

-(void)sortGoodsWithCategory:(NSString*)category andBrand:(NSString*)brand andSupplier:(NSString *)supplier;

@end

@interface SortGoodViewController : UIViewController
@property(nonatomic,weak)id <SortGoodsDelegate>delegate;

@end
