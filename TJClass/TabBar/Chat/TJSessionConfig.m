//
//  TJSessionConfig.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSessionConfig.h"

@implementation TJSessionConfig

- (NSArray<NIMMediaItem *> *)mediaItems {
    NSArray *defaultMediaItems = [NIMKit sharedKit].config.defaultMediaItems;
    
    
    NIMMediaItem *sign = [NIMMediaItem item:@"onTapMediaItemSign:"
                                     normalImage:[UIImage imageNamed:@"media_sign"]
                                   selectedImage:[UIImage imageNamed:@"media_sign"]
                                           title:@"签到"];
    if (self.session.sessionType == NIMSessionTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        if ([team.owner isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            sign.title = @"发起签到";
        }
        return [defaultMediaItems arrayByAddingObject:sign];
    } else {
        return defaultMediaItems;
    }
}

@end
