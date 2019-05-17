//
//  TJLoginView.m
//  TJGroup
//
//  Created by 李佳乐 on 2019/5/4.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJLoginView.h"

static const CGFloat TJLoginViewLoginButtonHeight = 50.f;

@interface TJLoginView() <UITextFieldDelegate>

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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor colorWithRed:33.f / 255 green:47.f / 255 blue:66.f / 255 alpha:1];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.userNameTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    
    CGFloat horizontalMargin = CGRectGetWidth(self.frame) / 4;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_offset(CGRectGetHeight(self.frame) / 4);
    }];
    
    UIView *line1 = UIView.new;
    line1.backgroundColor = [UIColor lightTextColor];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_centerY);
        make.left.mas_offset(horizontalMargin);
        make.right.mas_offset(-horizontalMargin);
        make.height.mas_equalTo(ONEPIXEL);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(horizontalMargin);
        make.bottom.mas_equalTo(line1.mas_top).offset(-10);
    }];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    [self addSubview:avatarView];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line1.mas_left).offset(5);
        make.top.mas_equalTo(line1.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avatarView.mas_right).offset(10);
        make.centerY.mas_equalTo(avatarView.mas_centerY);
        make.right.mas_equalTo(line1.mas_right);
    }];
    
    UIView *line2 = UIView.new;
    line2.backgroundColor = [UIColor lightTextColor];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(line1);
        make.height.mas_equalTo(ONEPIXEL);
    }];
    UIImageView *passwordView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    [self addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line2.mas_left).offset(5);
        make.top.mas_equalTo(line2.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordView.mas_right).offset(10);
        make.centerY.mas_equalTo(passwordView.mas_centerY);
        make.right.mas_equalTo(line2.mas_right);
    }];
    UIView *line3 = UIView.new;
    line3.backgroundColor = [UIColor lightTextColor];
    [self addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(line2);
        make.height.mas_equalTo(ONEPIXEL);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line3.mas_bottom).offset(100);
        make.left.right.mas_equalTo(line3);
        make.height.mas_equalTo(TJLoginViewLoginButtonHeight);
    }];
}

#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont boldSystemFontOfSize:41];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"Welcome";
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel)  {
        _tipsLabel = UILabel.new;
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = [UIColor lightTextColor];
        _tipsLabel.text = @"使用同济大学统一身份认证账号登录";
    }
    return _tipsLabel;
}

- (UITextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = UITextField.new;
        _userNameTextField.font = [UIFont systemFontOfSize:19];
        _userNameTextField.backgroundColor = [UIColor clearColor];
        _userNameTextField.textColor = [UIColor lightTextColor];
        _userNameTextField.tintColor = [UIColor lightTextColor];
        _userNameTextField.placeholder = @"请输入学号";
        _userNameTextField.clearButtonMode = UITextFieldViewModeAlways;
        _userNameTextField.returnKeyType = UIReturnKeyNext;
        _userNameTextField.delegate = self;
    }
    return _userNameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = UITextField.new;
        _passwordTextField.font = [UIFont systemFontOfSize:19];
        _passwordTextField.backgroundColor = [UIColor clearColor];
        _passwordTextField.textColor = [UIColor lightTextColor];
        _passwordTextField.tintColor = [UIColor lightTextColor];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIColor *color = THEME_COLOR;
        [_loginButton setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = TJLoginViewLoginButtonHeight / 2;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (NSString *)userName {
    return self.userNameTextField.text;
}

- (NSString *)password {
    return self.passwordTextField.text;
}

#pragma mark - action
- (void)loginButtonClicked:(id)sender {
//    if (self.userNameTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"账号或密码不能为空"];
//        [SVProgressHUD dismissWithDelay:1.f];
//        return;
//    }
    if (self.loginBlock) {
        self.loginBlock();
    }
}

- (void)backgroundTapped:(id)sender {
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self endEditing:YES];
        [self loginButtonClicked:nil];
    }
    return YES;
}

@end
