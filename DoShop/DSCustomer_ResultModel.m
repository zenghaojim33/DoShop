//
//  DSCustomer_ResultModel.m
//
//  Created by JSON2Mantle on 04/14/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSCustomer_ResultModel.h"

@implementation DSCustomer_ResultModel

/**
 * The dictionary returned by this method specifies
 * how your model object's properties map to the keys
 * in the JSON representation.
 * 
 * @see https://github.com/Mantle/Mantle#jsonkeypathsbypropertykey
 * @return NSDictionary
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // modelProperty : json_field_name
    return @{
            
            };
}


/**
 * Converts 'lastDealProducts' property from 'DSCustomer_LastDealProductsModel' class.
 *
 * @return NSValueTransformer
 */
+ (NSValueTransformer *)lastDealProductsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:DSCustomer_LastDealProductsModel.class];
}

@end
