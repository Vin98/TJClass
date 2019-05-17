//
//  TJJoinedClassesRequest.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJJoinedClassesRequest.h"

@implementation TJJoinedClassesRequest

- (instancetype)init {
    NSString *url = [NSString stringWithFormat:@"%@/api.php", server_url];
    self = [super initWithUrl:url];
    if (self) {
        
    }
    return self;
}

@end
