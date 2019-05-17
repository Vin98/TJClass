//
//  TJGroup.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJGroup : NSObject <YYModel>

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSArray <TJUser *> *users;
@property (nonatomic, strong) TJUser *creater;
@property (nonatomic, copy) NSString *coverUrl;

@end

NS_ASSUME_NONNULL_END
