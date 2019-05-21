//
//  TJSessionConfig.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJSessionConfig : NSObject <NIMSessionConfig>

@property (nonatomic,strong)    NIMSession *session;

@end

NS_ASSUME_NONNULL_END
