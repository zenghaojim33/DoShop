//
//  DSMessage_MessageModel.m
//
//  Created by JSON2Mantle on 04/20/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSMessage_MessageModel.h"

@implementation DSMessage_MessageModel

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
 * Converts 'result' property from 'DSMessage_ResultModel' class.
 *
 * @return NSValueTransformer
 */
+ (NSValueTransformer *)resultJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:DSMessage_ResultModel.class];
}

@end