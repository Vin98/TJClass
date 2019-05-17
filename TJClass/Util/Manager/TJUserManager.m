//
//  TJUserManager.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJUserManager.h"

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
    CurrentUser.userName = name;
    CurrentUser.phoneNumber = phoneNumber;
}

@end
