//
//  DSOrderInfo_ResultModel.m
//
//  Created by JSON2Mantle on 04/15/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSOrderInfo_ResultModel.h"

@implementation DSOrderInfo_ResultModel

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
 * Converts 'products' property from 'DSOrderInfo_ProductsModel' class.
 *
 * @return NSValueTransformer
 */
+ (NSValueTransformer *)productsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:DSOrderInfo_ProductsModel.class];
}

@end
