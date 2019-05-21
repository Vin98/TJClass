//
//  TJGetCurrentSignRequest.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJGetCurrentSignRequest.h"

@implementation TJGetCurrentSignRequest

- (instancetype)initWithTeamId:(NSString *)teamId {
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/api.php", server_url]];
    if (self) {
        self.params = @{
                        @"ac" : @"getSign",
                        @"teamid" : teamId ?: @"",
                        };
    }
    return self;
}

@end
