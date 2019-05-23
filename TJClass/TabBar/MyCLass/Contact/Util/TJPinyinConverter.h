//
//  TJPinyinConverter.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJPinyinConverter : NSObject

+ (TJPinyinConverter *)sharedInstance;

- (NSString *)toPinyin: (NSString *)source;

@end

NS_ASSUME_NONNULL_END
