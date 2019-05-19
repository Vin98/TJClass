//
//  TJUserManager.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJUserManager.h"
#import <MJExtension/MJExtension.h>

#define TJCurrentUserKey @"TJCurrentUserKey"
#define TJCurrentUserLoginStateKey @"TJCurrentUserLoginStateKey"

@implementation TJUserManager

+ (instancetype)manager {
    static TJUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)updateUserName:(NSString *)name phoneNumber:(NSString *)phoneNumber {
    TJUser *user = self.currentUser;
    user.userName = name;
    user.phoneNumber = phoneNumber;
    self.currentUser = user;
}

- (void)setCurrentUser:(TJUser *)currentUser {
    NSDictionary *userInfo = currentUser.mj_keyValues;
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:TJCurrentUserKey];
}

- (TJUser *)currentUser {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:TJCurrentUserKey];
    TJUser *user = [TJUser mj_objectWithKeyValues:userInfo];
    return user;
}

- (void)setLogedIn:(BOOL)logedIn {
    NSNumber *state = [NSNumber numberWithBool:logedIn];
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:TJCurrentUserLoginStateKey];
}

- (BOOL)logedIn {
    NSNumber *state = [[NSUserDefaults standardUserDefaults] objectForKey:TJCurrentUserLoginStateKey];
    return [state boolValue];
}

@end
