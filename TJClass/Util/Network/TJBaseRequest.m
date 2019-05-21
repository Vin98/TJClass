//
//  TJBaseRequest.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJBaseRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface TJBaseRequest()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, weak) NSURLSessionDataTask *task;

@end

@implementation TJBaseRequest

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
        self.requestType = TJReauestTypeGet;
    }
    return self;
}

- (void)start {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = self.params.mutableCopy ?: @{}.mutableCopy;
    if (!params[@"userId"]) {
        NSString *userId = [TJUserManager manager].currentUser.userId;
        [params addEntriesFromDictionary:@{@"userId" : userId ?: @""}];
    }
    switch (self.requestType) {
        case TJReauestTypeGet:
        {
            self.task = [manager GET:self.url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (self.successBlock) {
                    self.successBlock(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (self.failureBlock) {
                    self.failureBlock(error);
                }
            }];
        }
            break;
            
        case TJReauestTypePost:
        {
            self.task = [manager POST:self.url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (self.successBlock) {
                    self.successBlock(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (self.failureBlock) {
                    self.failureBlock(error);
                }
            }];
        }
    }
}

- (void)cancel {
    if (self.task) {
        [self.task cancel];
    }
}

@end
