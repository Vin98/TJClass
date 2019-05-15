//
//  TJChatCell.m
//  TJClass
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJChatCell.h"

@interface TJChatCell()

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong ,nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation TJChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
        self.avatarView.image = [UIImage imageNamed:@"placeholderAvatar"];
        self.nameLabel.text = @"宝宝";
        self.messageLabel.text = @"我想你啦";
        self.timeLabel.text = @"now";
    }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.bottom.offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView.mas_top).offset(5);
        make.left.mas_equalTo(self.avatarView.mas_right).offset(10);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.avatarView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_greaterThanOrEqualTo(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.left.mas_greaterThanOrEqualTo(self.nameLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLabel.mas_top);
    }];
    
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = UIImageView.new;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = UILabel.new;
        _messageLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _messageLabel.textColor = [UIColor lightGrayColor];
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.new;
        _timeLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.contentMode = UIViewContentModeLeft;
    }
    return _timeLabel;
}

@end
