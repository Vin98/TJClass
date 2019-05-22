//
//  TJDoSignRequest.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJDoSignRequest : TJBaseRequest

- (instancetype)initWithSignId:(NSUInteger)signId lat:(NSString *)lat lon:(NSString *)lon;

@end

NS_ASSUME_NONNULL_END
