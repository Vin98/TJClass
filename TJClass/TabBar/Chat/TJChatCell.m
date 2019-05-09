//
//  TJChatCell.m
//  TJClass
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJChatCell.h"

@interface TJChatCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation TJChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarView.image = [UIImage imageNamed:@"placeholderAvatar"];
    self.nameLabel.text = @"宝宝";
    self.messageLabel.text = @"我想你啦";
    self.timeLabel.text = @"now";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
