//
//  TJSignClassCell.m
//  TJGroup
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
@property (nonatomic, strong)UILabel *placeholderLabel;;

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
    bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
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

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = UILabel.new;
        _placeholderLabel.font = [UIFont boldSystemFontOfSize:30];
        _placeholderLabel.textColor = [UIColor whiteColor];
        _placeholderLabel.contentMode = UIViewContentModeCenter;
    }
    return _placeholderLabel;
}

- (void)setCls:(TJGroup *)cls {
    self.nameLabel.text = cls.groupName;
    if (!cls.coverUrl) {
        [self setCoverWithText:cls.groupName];
    } else {
        [self.placeholderLabel removeFromSuperview];
        self.avatarView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCoverWithText:(NSString *)text {
    if (!self.placeholderLabel.superview) {
        [self.avatarView addSubview:self.placeholderLabel];
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.avatarView.center);
        }];
    }
    self.avatarView.backgroundColor = THEME_COLOR;
    self.placeholderLabel.text = [text substringToIndex:1];
    [self.placeholderLabel sizeToFit];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.avatarView.backgroundColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.avatarView.backgroundColor = THEME_COLOR;
}

@end
