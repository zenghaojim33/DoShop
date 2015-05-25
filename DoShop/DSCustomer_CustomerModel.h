//
//  DSCustomer_CustomerModel.h
//
//  Created by JSON2Mantle on 04/14/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSCustomer_ResultModel.h"
#import "DSBaseModel.h"
/**
 *  The DSCustomer_CustomerModel class represents a Mantle model.
 */
@interface DSCustomer_CustomerModel : DSBaseModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSMutableArray *result;
@property (nonatomic, assign) NSInteger ret;

@end
