//
//  DSCustomer_CustomerModel.m
//
//  Created by JSON2Mantle on 04/14/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSCustomer_CustomerModel.h"

@implementation DSCustomer_CustomerModel

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
 * Converts 'result' property from 'DSCustomer_ResultModel' class.
 *
 * @return NSValueTransformer
 */
+ (NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:DSCustomer_ResultModel.class];
}

@end
