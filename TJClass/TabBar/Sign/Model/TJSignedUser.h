//
//  TJSignedUser.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/22.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJSignedUser : NSObject

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;

@end

NS_ASSUME_NONNULL_END
