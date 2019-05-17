//
//  TJUser.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TJUserType) {
    TJUserTypeStudent = 0,
    TJUserTypeTeacher = 1,
};

@interface TJUser : NSObject

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, copy) NSString *userAccount;   //学号、工号
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *phoneNumber;

@end

NS_ASSUME_NONNULL_END
