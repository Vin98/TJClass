//
//  TJContactUtilCell.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJContactUtilCell.h"
#import "UIView+Ex.h"
//#import "TJBadgeView.h"

@interface TJContactUtilCell()

//@property (nonatomic,strong) TJBadgeView *badgeView;

@property (nonatomic,strong) id<TJContactItem> data;

@end

@implementation TJContactUtilCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _badgeView = [TJBadgeView viewWithBadgeTip:@""];
//        [self addSubview:_badgeView];
    }
    return self;
}

- (void)refreshWithContactItem:(id<TJContactItem>)item{
    self.data = item;
    self.textLabel.text = item.nick;
    self.imageView.image = item.icon;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressUtilImage:)];
    [self.imageView addGestureRecognizer: recognizer];
    [self.textLabel sizeToFit];
//
//    NSString *badge  = [item badge];
//    self.badgeView.hidden = badge.integerValue == 0;
//    self.badgeView.badgeValue = badge;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)onPressUtilImage:(id)sender{
    if ([self.delegate respondsToSelector:@selector(onPressUtilImage:)]) {
        [self.delegate onPressUtilImage:self.data.nick];
    }
}

- (void)addDelegate:(id)delegate{
    self.delegate = delegate;
}

#define BadgeValueRight 50
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.left = TJContactAvatarLeft;
    self.imageView.centerY = self.height * .5f;
//    self.badgeView.right = self.width - BadgeValueRight;
//    self.badgeView.centerY = self.height * .5f;
}

@end
