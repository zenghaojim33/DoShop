//
//  DSPostage_ResultModel.m
//
//  Created by JSON2Mantle on 04/23/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSPostage_ResultModel.h"

@implementation DSPostage_ResultModel

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
 * Converts 'provinces' property from 'DSPostage_ProvincesModel' class.
 *
 * @return NSValueTransformer
 */
+ (NSValueTransformer *)provincesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:DSPostage_ProvincesModel.class];
}

@end
