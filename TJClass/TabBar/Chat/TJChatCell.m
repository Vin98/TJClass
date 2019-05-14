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
        self.avatarView.image = [UIImage imageNamed:@"placeholderAvatar"];
        self.nameLabel.text = @"宝宝";
        self.messageLabel.text = @"我想你啦";
        self.timeLabel.text = @"now";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
