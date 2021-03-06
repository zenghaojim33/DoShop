//
//  DSOrderInfo_ProductsModel.h
//
//  Created by JSON2Mantle on 04/15/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "Mantle.h"
#import "DSBaseModel.h"

/**
 *  The DSOrderInfo_ProductsModel class represents a Mantle model.
 */
@interface DSOrderInfo_ProductsModel : DSBaseModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber * price;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productImg;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSNumber * allPrice;
@property (nonatomic, assign) NSInteger productId;

@end
