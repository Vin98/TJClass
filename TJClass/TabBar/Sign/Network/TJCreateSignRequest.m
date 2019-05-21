//
//  TJCreateSignRequest.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJCreateSignRequest.h"

@implementation TJCreateSignRequest

- (instancetype)initWithTeamId:(NSString *)teamId
                       creater:(NSString *)creater
                     startTime:(NSUInteger)startTime
                       endTime:(NSUInteger)endTime {
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/api.php", server_url]];
    if (self) {
        self.requestType = TJReauestTypePost;
        self.params = @{
                        @"ac" : @"createSign",
                        @"teamId" : teamId ?: @"",
                        @"creater" : creater ?: @"",
                        @"startTime" : @(startTime),
                        @"endTime" : @(endTime),
                        };
    }
    return self;
}

@end
