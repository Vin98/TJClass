//
//  TJSignClassCell.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignClassCell.h"

static const CGFloat TJSignClassAvatarDiameter = 25.f;

@interface TJSignClassCell()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signStatusLabel;    //签到中/已结束
@property (nonatomic, strong) UILabel *myStatusLabel;      //未签到/已签到

@end

@implementation TJSignClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sign_clock"]];
            imageView;
        });
        
        self.nameLabel = ({
            UILabel *label = UILabel.new;
            label.font = [UIFont systemFontOfSize:15.f];
            label;
        });
        
        self.signStatusLabel = ({
            UILabel *label = UILabel.new;
            label.font = [UIFont systemFontOfSize:12.f];
            label.textColor = [UIColor darkTextColor];
            label.layer.borderWidth = ONEPIXEL;
            label.layer.borderColor = THEME_COLOR.CGColor;
            label.layer.cornerRadius = 6.f;
            label.layer.masksToBounds = YES;
            label;
        });
        
        self.myStatusLabel = ({
            UILabel *label = UILabel.new;
            label.layer.cornerRadius = 7.f;
            label.layer.masksToBounds = YES;
            label.font = [UIFont systemFontOfSize:14.f];
            label.backgroundColor = THEME_COLOR;
            label.textColor = [UIColor whiteColor];
            label;
        });
    
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.signStatusLabel];
    [self.contentView addSubview:self.myStatusLabel];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.bottom.offset(-10);
        make.size.mas_equalTo(CGSizeMake(TJSignClassAvatarDiameter, TJSignClassAvatarDiameter));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.avatarView.mas_centerY);
    }];
    
    [self.signStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.nameLabel.centerY);
    }];
    
    [self.myStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.signStatusLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.signStatusLabel.centerY);
        make.right.mas_offset(-10);
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

- (void)setSign:(TJSign *)sign {
    _sign = sign;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sign.startTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-d HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    self.nameLabel.text = dateString;
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    BOOL didTimeOut = currentTime >= sign.endTime;
    if (didTimeOut) {
        self.signStatusLabel.text = @"  签到已结束  ";
    } else {
        self.signStatusLabel.text = @"  签到中  ";
    }
    
    __block BOOL isSigned = NO;
    [sign.signedUsers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            isSigned = YES;
            *stop = YES;
        }
    }];
    if (isSigned) {
        self.myStatusLabel.text = @"  已签到  ";
        self.myStatusLabel.backgroundColor = THEME_COLOR;
    } else {
        if (didTimeOut) {
            self.myStatusLabel.text = @"  未签到  ";
            self.myStatusLabel.backgroundColor = [UIColor redColor];
        } else {
            self.myStatusLabel.text = @"  点击签到  ";
            self.myStatusLabel.backgroundColor = THEME_COLOR;
        }
    }

    self.userInteractionEnabled = !didTimeOut && !isSigned;
}

@end
