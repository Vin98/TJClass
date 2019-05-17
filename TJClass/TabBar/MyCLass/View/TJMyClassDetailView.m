//
//  TJMyClassDetailView.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMyClassDetailView.h"

@interface TJMyClassDetailCell : UIButton

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowView;

+ (CGFloat)cellHeight;

@end

@implementation TJMyClassDetailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = ({
            UILabel *label = UILabel.new;
            label.textColor = [UIColor blackColor];
            label;
        });
        
        self.arrowView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
            imageView.tintColor = THEME_COLOR;
            imageView;
        });
        
        self.userInteractionEnabled = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.textLabel];
    [self addSubview:self.arrowView];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_offset(-20);
        make.left.mas_greaterThanOrEqualTo(self.textLabel.mas_right).offset(20);
    }];
    UIView *bottomLine = UIView.new;
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.bottom.offset(0);
        make.height.mas_equalTo(ONEPIXEL);
    }];
}

+ (CGFloat)cellHeight {
    return 50.f;
}

@end

@interface TJMyClassDetailView()

@property (nonatomic, strong) TJMyClassDetailCell *detailMessageCell;
@property (nonatomic, strong) TJMyClassDetailCell *signRecordCell;
@property (nonatomic, strong) UIButton *signButton;

@end

@implementation TJMyClassDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.detailMessageCell = ({
            TJMyClassDetailCell *cell = TJMyClassDetailCell.new;
            [cell setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:UIControlStateHighlighted | UIControlStateHighlighted];
            cell.textLabel.text = @"详细群资料";
            [cell addTarget:self action:@selector(gotoDetailPage:) forControlEvents:UIControlEventTouchUpInside];
            cell;
        });
        self.signRecordCell = ({
            TJMyClassDetailCell *cell = TJMyClassDetailCell.new;
            [cell setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:UIControlStateHighlighted | UIControlStateHighlighted];
            cell.textLabel.text = @"签到记录";
            [cell addTarget:self action:@selector(gotoRecordPage:) forControlEvents:UIControlEventTouchUpInside];
            cell;
        });
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGFloat spacing = 0.f;
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2 * [TJMyClassDetailCell cellHeight] + spacing)];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = spacing;
    
    [stackView addArrangedSubview:self.detailMessageCell];
    [stackView addArrangedSubview:self.signRecordCell];
    
    [self addSubview:stackView];
}

#pragma mark - action
- (void)gotoDetailPage:(id)sender {
    
}

- (void)gotoRecordPage:(id)sender {
    
}


@end
