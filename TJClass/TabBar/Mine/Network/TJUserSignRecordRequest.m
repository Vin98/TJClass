//
//  TJUserSignRecordRequest.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJUserSignRecordRequest.h"

@implementation TJUserSignRecordRequest

- (instancetype)init
{
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/api.php", server_url]];
    if (self) {
        self.params = @{
                        @"ac" : @"userSignRecord",
                        @"userid" : [NIMSDK sharedSDK].loginManager.currentAccount ?: @""
                        };
    }
    return self;
}

@end
