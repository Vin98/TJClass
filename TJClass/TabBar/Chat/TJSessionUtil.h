//
//  TJSessionUtil.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 最近会话本地扩展标记类型
typedef NS_ENUM(NSInteger, TJRecentSessionMarkType){
    // @ 标记
    TJRecentSessionMarkTypeAt,
    // 置顶标记
    TJRecentSessionMarkTypeTop,
};

@interface TJSessionUtil : NSObject
+ (void)addRecentSessionMark:(NIMSession *)session type:(TJRecentSessionMarkType)type;

+ (void)removeRecentSessionMark:(NIMSession *)session type:(TJRecentSessionMarkType)type;

+ (BOOL)recentSessionIsMark:(NIMRecentSession *)recent type:(TJRecentSessionMarkType)type;

@end

NS_ASSUME_NONNULL_END
