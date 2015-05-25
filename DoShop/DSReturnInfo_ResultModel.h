//
//  DSReturnInfo_ResultModel.h
//
//  Created by JSON2Mantle on 04/15/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSBaseModel.h"

/**
 *  The DSReturnInfo_ResultModel class represents a Mantle model.
 */
@interface DSReturnInfo_ResultModel : DSBaseModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger backType;
@property (nonatomic, copy) NSString *linkman;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *backTime;
@property (nonatomic, copy) NSString *productImg;
@property (nonatomic, copy) NSString *postcode;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) NSInteger statu;
@property (nonatomic, copy) NSString *thimg;
@property (nonatomic, copy) NSString *emsNum;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) NSInteger backId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *buyer;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *emsName;
@property (nonatomic, assign) NSInteger detailId;
@property (nonatomic, copy) NSNumber * allprice;

@end
