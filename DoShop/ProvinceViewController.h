//
//  ProvinceViewController.h
//  DoShop
//
//  Created by Anson on 15/3/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PostageDelegate <NSObject>

-(void)reloadPostageTableView;

@end


@interface ProvinceViewController : UIViewController
//邮费设定的编号
@property(nonatomic,strong)NSNumber * provinceid;
//省份编号
@property(nonatomic,strong)NSNumber * postageid;
@property(nonatomic,strong)NSString * province;
@property(nonatomic,strong)NSString * chosenProvince;
@property(nonatomic,strong)NSString * expressPrice;//邮费
@property(nonatomic,strong)NSString * expressName;
@property (nonatomic)BOOL changeInfo;  //yes的话，代表是修改信息
@property(nonatomic,assign)id<PostageDelegate>delegate;

@end
