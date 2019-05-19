//
//  TJGetNIMTokenRequest.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/18.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJGetNIMTokenRequest : TJBaseRequest

- (instancetype)initWithUserid:(NSString *)userid;

@end

NS_ASSUME_NONNULL_END
