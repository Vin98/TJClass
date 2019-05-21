//
//  TJGetCurrentSignRequest.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJGetCurrentSignRequest : TJBaseRequest

- (instancetype)initWithTeamId:(NSString *)teamId;

@end

NS_ASSUME_NONNULL_END
