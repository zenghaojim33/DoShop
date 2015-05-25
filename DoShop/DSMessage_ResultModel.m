//
//  DSMessage_ResultModel.m
//
//  Created by JSON2Mantle on 04/20/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Mantle.h>
#import "DSMessage_ResultModel.h"

@implementation DSMessage_ResultModel

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
            @"modelId": @"id",
            };
}



@end
