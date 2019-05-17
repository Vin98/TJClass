//
//  TJBaseRequest.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TJReauestType) {
    TJReauestTypeGet = 0,
    TJReauestTypePost = 1,
};

typedef void(^TJRequestSuccessBlock)(id result);
typedef void(^TJRequestFailureBlock)(NSError *error);

@class TJBaseResponse;
@interface TJBaseRequest : NSObject

@property (nonatomic, assign) TJReauestType requestType;  //请求方式，默认 GET
@property (nonatomic, copy) NSDictionary *params;         //请求参数
@property (nonatomic, copy) TJRequestSuccessBlock successBlock;  //成功回调
@property (nonatomic, copy) TJRequestFailureBlock failureBlock;  //失败回调

- (instancetype)initWithUrl:(NSString *)url;

- (void)start;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
