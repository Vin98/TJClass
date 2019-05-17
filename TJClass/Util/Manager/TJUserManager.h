//
//  TJUserManager.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJUser.h"

NS_ASSUME_NONNULL_BEGIN

#define CurrentUser [[TJUserManager manager] currentUser]

@interface TJUserManager : NSObject

@property (nonatomic, strong) TJUser *currentUser;

+ (instancetype)manager;

- (void)updateUserName:(NSString *)name phoneNumber:(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END
