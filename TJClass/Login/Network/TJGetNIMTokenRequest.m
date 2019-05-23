//
//  TJGetNIMTokenRequest.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/18.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJGetNIMTokenRequest.h"

@implementation TJGetNIMTokenRequest

- (instancetype)initWithUserid:(NSString *)userid
{
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/acount.php", server_url]];
    if (self) {
        self.params = @{
                        @"userid" : userid,
                        @"ac" : @"getToken",
                        };
    }
    return self;
}

@end
