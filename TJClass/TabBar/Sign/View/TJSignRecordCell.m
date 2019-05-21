//
//  TJSignRecordCell.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignRecordCell.h"

@interface TJSignRecordCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *signStatusLabel;
@property (nonatomic, strong) UILabel *signedCountLabel;

@end

@implementation TJSignRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = ({
            UILabel *label = UILabel.new;
            label.font = [UIFont systemFontOfSize:17.f];
            label;
        });
        
        self.signStatusLabel = ({
            UILabel *label = UILabel.new;
            label.font = [UIFont systemFontOfSize:14.f];
            label.textColor = [UIColor lightGrayColor];
            label.layer.cornerRadius = 7.f;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = ONEPIXEL;
            label.layer.borderColor = THEME_COLOR.CGColor;
            label;
        });
        
        self.signedCountLabel = ({
            UILabel *label = UILabel.new;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:13.f];
            label;
        });
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.signStatusLabel];
    [self.contentView addSubview:self.signedCountLabel];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sign_clock"]];
    [self.contentView addSubview:avatarView];
    
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.bottom.mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatarView.mas_right).offset(10);
        make.centerY.mas_equalTo(avatarView.mas_centerY);
    }];
    
    [self.signStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.titleLabel.centerY);
    }];
    
    [self.signedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.signStatusLabel.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleLabel.centerY);
    }];
}

- (void)updateCellWithSign:(TJSign *)sign {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sign.startTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-d HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    self.titleLabel.text = dateString;
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    BOOL didTimeOut = currentTime >= sign.endTime;
    if (didTimeOut) {
        self.signStatusLabel.text = @"  签到已结束  ";
        self.signStatusLabel.backgroundColor = [UIColor clearColor];
        self.signStatusLabel.textColor = [UIColor darkTextColor];
    } else {
        self.signStatusLabel.text = @"  签到中  ";
        self.signStatusLabel.backgroundColor = THEME_COLOR;
        self.signStatusLabel.textColor = [UIColor whiteColor];
    }
    self.signedCountLabel.text = [NSString stringWithFormat:@"%lu人已签", (unsigned long)sign.signedUsers.count];
}

@end
