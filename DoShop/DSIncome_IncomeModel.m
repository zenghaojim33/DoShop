//
//  DSIncome_IncomeModel.m
//  DoShop
//
//  Created by Anson on 15/4/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "DSIncome_IncomeModel.h"
#import <Mantle.h>
@implementation DSIncome_IncomeModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // modelProperty : json_field_name
    return @{
             
             };
}

+ (NSValueTransformer *)recordsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DSIncome_RecordModel class]];
}




@end
