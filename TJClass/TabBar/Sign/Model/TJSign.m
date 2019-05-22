//
//  TJSign.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSign.h"

@implementation TJSign

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"signedUsers" : TJSignedUser.class};
}

@end
