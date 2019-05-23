//
//  TJUserSignRecord.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJUserSignRecord : NSObject

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *signLat;
@property (nonatomic, copy) NSString *signLon;
@property (nonatomic, copy) NSString *userLat;
@property (nonatomic, copy) NSString *userLon;

@end

NS_ASSUME_NONNULL_END
