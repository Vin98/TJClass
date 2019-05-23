//
//  TJSettingPortraitCell.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSettingPortraitCell.h"
#import "NIMCommonTableData.h"
#import "UIView+Ex.h"
#import "TJSessionUtil.h"
#import "NIMAvatarImageView.h"

@interface TJSettingPortraitCell()

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *accountLabel;

@end

@implementation TJSettingPortraitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat avatarWidth = 55.f;
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, avatarWidth, avatarWidth)];
        [self addSubview:_avatar];
        _nameLabel      = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:18.f];
        [self addSubview:_nameLabel];
        _accountLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
        _accountLabel.font = [UIFont systemFontOfSize:14.f];
        _accountLabel.textColor = [UIColor grayColor];
        [self addSubview:_accountLabel];
    }
    return self;
}

- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text       = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    NSString *uid = rowData.extraInfo;
    if ([uid isKindOfClass:[NSString class]]) {
        NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:uid option:nil];
        self.nameLabel.text   = info.showName ;
        [self.nameLabel sizeToFit];
        self.accountLabel.text = [NSString stringWithFormat:@"帐号：%@",uid];
        [self.accountLabel sizeToFit];
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:info.avatarUrlString] placeholderImage:info.avatarImage options:SDWebImageRetryFailed];
    }
}


#define AvatarLeft 20
#define TitleAndAvatarSpacing 20
#define TitleTop 22
#define AccountBottom 22

- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatar.left    = AvatarLeft;
    self.avatar.centerY = self.height * .5f;
    self.nameLabel.left = self.avatar.right + TitleAndAvatarSpacing;
    self.nameLabel.top  = TitleTop;
    self.accountLabel.left    = self.nameLabel.left;
    self.accountLabel.bottom  = self.height - AccountBottom;
}

@end
