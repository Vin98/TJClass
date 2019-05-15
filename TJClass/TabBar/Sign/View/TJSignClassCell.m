//
//  TJSignClassCell.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignClassCell.h"

static const CGFloat TJSignClassAvatarDiameter = 60.f;

@interface TJSignClassCell()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *signView;

@end

@implementation TJSignClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.signView];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.bottom.offset(-10);
        make.size.mas_equalTo(CGSizeMake(TJSignClassAvatarDiameter, TJSignClassAvatarDiameter));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
        make.right.mas_greaterThanOrEqualTo(10);
    }];
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.nameLabel.mas_right).offset(10);
        make.right.mas_offset(-20);
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    UIView *bottomLine = UIView.new;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(ONEPIXEL);
    }];
}

#pragma mark - getter & setter
- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = UIImageView.new;
        _avatarView.layer.cornerRadius = TJSignClassAvatarDiameter / 2;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UIImageView *)signView {
    if (!_signView) {
        _signView = UIImageView.new;
        _signView.image = [UIImage imageNamed:@"sign_uncheck"];
    }
    return _signView;
}

- (void)setCls:(TJClass *)cls {
    self.nameLabel.text = cls.className;
    if (!cls.coverUrl) {
        [self setCoverWithText:cls.className];
    }
}

- (void)setCoverWithText:(NSString *)text {
    [self.avatarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *coverLabel = UILabel.new;
    self.avatarView.backgroundColor = THEME_COLOR;
    coverLabel.font = [UIFont boldSystemFontOfSize:40];
    coverLabel.text = [text substringToIndex:1];
    coverLabel.textColor = [UIColor whiteColor];
    coverLabel.contentMode = UIViewContentModeCenter;
    [self.avatarView addSubview:coverLabel];
    [coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.avatarView.center);
    }];
}

@end
