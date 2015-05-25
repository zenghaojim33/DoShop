//
//  DSUserInfoModel.h
//  DoShop
//
//  Created by Anson on 15/4/16.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "DSBaseModel.h"

@interface DSUserInfoModel : DSBaseModel
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString * province;
@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)NSString * county;
@property(nonatomic,copy)NSString * area;
@property(nonatomic,copy)NSString * bankName;
@property(nonatomic,copy)NSString * bankUser;
@property(nonatomic,copy)NSString * bankCode;
@property(nonatomic,copy)NSString * email;
@property(nonatomic,copy)NSString * uimg;


@end
