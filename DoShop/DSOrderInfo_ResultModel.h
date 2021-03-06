//
//  DSOrderInfo_ResultModel.h
//
//  Created by JSON2Mantle on 04/15/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSOrderInfo_ProductsModel.h"
#import "DSBaseModel.h"
/**
 *  The DSOrderInfo_ResultModel class represents a Mantle model.
 */
@interface DSOrderInfo_ResultModel : DSBaseModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger statu;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *linkMan;
@property (nonatomic, copy) NSNumber * postage;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *emsName;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, copy) NSString *postcode;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *buyer;
@property (nonatomic, copy) NSString *emsNum;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *createTime;

@end
