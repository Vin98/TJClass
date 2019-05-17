//
//  TJMineHeaderView.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMineHeaderView.h"

static const CGFloat TJMineHeaderViewAvatarDiamater = 80.f;

@implementation TJMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = THEME_COLOR;
    [self addSubview:self.avatarView];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(TJMineHeaderViewAvatarDiamater, TJMineHeaderViewAvatarDiamater));
    }];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = UIImageView.new;
        _avatarView.layer.cornerRadius = TJMineHeaderViewAvatarDiamater / 2;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.image = [UIImage imageNamed:@"placeholderAvatar"];
    }
    return _avatarView;
}

+ (CGFloat)typicalHeight {
    return 2.f * SCREEN_WIDTH / 3.f;
}

@end
