//
//  TJCreateClassRequest.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJCreateClassRequest.h"

@implementation TJCreateClassRequest

- (instancetype)initWithName:(NSString *)name {
    NSString *url = [NSString stringWithFormat:@"%@/api.php", server_url];
    self = [super initWithUrl:url];
    if (self) {
        self.params = @{
                        @"name" : name ?: @"",
                        @"ac" : @"addClass",
                        };
    }
    return self;
}

@end
