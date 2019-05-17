//
//  TJCreateSignRequest.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJCreateSignRequest : TJBaseRequest

- (instancetype)initWithGroupId:(NSString *)groupId
                      groupName:(NSString *)groupName;


@end

NS_ASSUME_NONNULL_END
