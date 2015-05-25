//
//  XYZResultModel.h
//
//  Created by JSON2Mantle on 04/03/15.
//  Copyright (c) 2015 John Smith. All rights reserved.
//

#import <Mantle.h>
#import "DSBaseModel.h"

@interface DSNewGoodModel : DSBaseModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *mainImgUrl;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) NSInteger saleNum;
@property (nonatomic, copy) NSString *usetime;
@property (nonatomic, copy) NSNumber *  modelId;
@property (nonatomic, copy) NSString *size;

@end
