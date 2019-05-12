//
//  TJLoginView.m
//  TJClass
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJLoginView.h"

@interface TJLoginView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation TJLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.userNameTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_offset(CGRectGetHeight(self.frame) / 4);
    }];
    self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        <#code#>
    }
}

#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont boldSystemFontOfSize:41];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel)  {
        _tipsLabel = UILabel.new;
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor lightTextColor];
    }
    return _tipsLabel;
}

- (UITextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = UITextField.new;
        _userNameTextField.font = [UIFont systemFontOfSize:19];
        _userNameTextField.backgroundColor = [UIColor clearColor];
        _userNameTextField.tintColor = [UIColor lightTextColor];
        _userNameTextField.placeholder = @"请输入学号";
        _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _userNameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = UITextField.new;
        _passwordTextField.font = [UIFont systemFontOfSize:19];
        _passwordTextField.backgroundColor = [UIColor clearColor];
        _passwordTextField.tintColor = [UIColor lightTextColor];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = THEME_COLOR;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark - action
- (void)loginButtonClicked:(id)sender {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

@end
