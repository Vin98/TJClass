//
//  TJCreateClassRequest.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJCreateClassRequest : TJBaseRequest

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
