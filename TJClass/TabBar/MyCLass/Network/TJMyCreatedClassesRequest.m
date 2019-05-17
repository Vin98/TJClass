//
//  TJMyCreatedClassesRequest.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMyCreatedClassesRequest.h"

@implementation TJMyCreatedClassesRequest

- (instancetype)init
{
    self = [super initWithUrl:[NSString stringWithFormat:@"%@/api.php", server_url]];
    if (self) {
        self.params = @{
                        @"ac" : @"getClasses",
                        };
    }
    return self;
}
@end
