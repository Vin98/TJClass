//
//  TJSessionUtil.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSessionUtil.h"

static NSString *const TJRecentSessionAtMark  = @"TJRecentSessionAtMark";
static NSString *const TJRecentSessionTopMark = @"TJRecentSessionTopMark";

@implementation TJSessionUtil

+ (void)addRecentSessionMark:(NIMSession *)session type:(TJRecentSessionMarkType)type
{
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
    if (recent)
    {
        NSDictionary *localExt = recent.localExt?:@{};
        NSMutableDictionary *dict = [localExt mutableCopy];
        NSString *key = [TJSessionUtil keyForMarkType:type];
        [dict setObject:@(YES) forKey:key];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:dict recentSession:recent];
    }
    
    
}

+ (void)removeRecentSessionMark:(NIMSession *)session type:(TJRecentSessionMarkType)type
{
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:session];
    if (recent) {
        NSMutableDictionary *localExt = [recent.localExt mutableCopy];
        NSString *key = [TJSessionUtil keyForMarkType:type];
        [localExt removeObjectForKey:key];
        [[NIMSDK sharedSDK].conversationManager updateRecentLocalExt:localExt recentSession:recent];
    }
}

+ (BOOL)recentSessionIsMark:(NIMRecentSession *)recent type:(TJRecentSessionMarkType)type
{
    NSDictionary *localExt = recent.localExt;
    NSString *key = [TJSessionUtil keyForMarkType:type];
    return [localExt[key] boolValue] == YES;
}

+ (NSString *)keyForMarkType:(TJRecentSessionMarkType)type
{
    static NSDictionary *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @{
                 @(TJRecentSessionMarkTypeAt)  : TJRecentSessionAtMark,
                 @(TJRecentSessionMarkTypeTop) : TJRecentSessionTopMark
                 };
    });
    return [keys objectForKey:@(type)];
}

@end
