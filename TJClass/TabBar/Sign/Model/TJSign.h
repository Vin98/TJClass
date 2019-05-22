//
//  TJSign.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJSignedUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJSign : NSObject <YYModel>

@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *creater;
@property (nonatomic, assign) NSUInteger startTime;
@property (nonatomic, assign) NSUInteger endTime;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSArray <TJSignedUser *> *signedUsers;

@end

NS_ASSUME_NONNULL_END
