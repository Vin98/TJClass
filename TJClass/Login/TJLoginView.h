//
//  TJLoginView.h
//  TJGroup
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJLoginView : UIView

@property (nonatomic, copy) dispatch_block_t loginBlock;
@property (nonatomic, readonly, strong) NSString *userName;
@property (nonatomic, readonly, strong) NSString *password;

@end

NS_ASSUME_NONNULL_END
