//
//  TJGroup.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJGroup.h"

@implementation TJGroup

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"groupId" : @"id",
             @"groupName" : @"name",
             };
}

@end
