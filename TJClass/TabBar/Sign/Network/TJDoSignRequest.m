//
//  TJDoSignRequest.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJDoSignRequest.h"

@implementation TJDoSignRequest

- (instancetype)initWithSignId:(NSUInteger)signId {
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/api.php", server_url]];
    if (self) {
        self.requestType = TJReauestTypePost;
        self.params = @{
                        @"ac" : @"doSign",
                        @"signId" : @(signId),
                        };
    }
    return self;
}

@end
