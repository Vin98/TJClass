//
//  TJMineHeaderView.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJMineHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, copy) dispatch_block_t avatarDidTap;

+ (CGFloat)typicalHeight;

@end

NS_ASSUME_NONNULL_END
