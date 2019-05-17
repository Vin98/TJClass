//
//  TJCreateSignRequest.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJCreateSignRequest.h"

@implementation TJCreateSignRequest

- (instancetype)initWithGroupId:(NSString *)groupId groupName:(NSString *)groupName {
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/api.php", server_url]];
    if (self) {
        self.params = @{
                        @"ac" : @"createSign",
                        @"classId" : groupId,
                        @"className" : groupName,
                        };
    }
    return self;
}

@end
