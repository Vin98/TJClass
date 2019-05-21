//
//  TJLoginViewController.m
//  TJGroup
//
//  Created by 李佳乐 on 2019/5/3.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJLoginViewController.h"
#import "TJMainViewController.h"
#import "TJLoginView.h"
#import "TJLoginViewPresentAnimation.h"
#import <AFNetworking/AFNetworking.h>
#import "TJGetNIMTokenRequest.h"

@interface TJLoginViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) TJLoginView *loginView;

@end

@implementation TJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.loginView];
}

- (void)doLogin {
    [SVProgressHUD showWithStatus:@"正在登录"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"https://ids.tongji.edu.cn:8443/nidp/saml2/sso?sid=0&sid=0";
    NSDictionary *params = @{
                             @"option" : @"credential",
                             @"Ecom_User_ID" : self.loginView.userName,
                             @"Ecom_Password" : self.loginView.password,
                             };
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        if ([errorString containsString:@"登录失败"] || [errorString containsString:@"Login failed"]) {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
            [SVProgressHUD dismissWithDelay:2.f];
        } else {

            //保存用户信息
            TJUser *user = TJUser.new;
            user.userId = self.loginView.userName;
            [TJUserManager manager].currentUser = user;
            [TJUserManager manager].logedIn = YES;

            //拿 token
            TJGetNIMTokenRequest *getTokenRequest = [[TJGetNIMTokenRequest alloc] initWithUserid:user.userId];
            getTokenRequest.successBlock = ^(id  _Nonnull result) {
                NSDictionary *info =result[@"data"];
                if (info) {
                    NSString *accid = info[@"accid"];
                    NSString *token = info[@"token"];
                    if (accid && accid.length > 0 && token && token.length > 0) {
                        [[[NIMSDK sharedSDK] loginManager] login:accid token:token completion:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"[%@] 手动登录 NIM 失败", NSStringFromClass([self class]));
                            } else {
                                NSLog(@"[%@] 手动登录 NIM 成功", NSStringFromClass([self class]));
                                user.accid = accid;
                                user.token = token;
                                [TJUserManager manager].currentUser = user;
                            }
                        }];
                    }
                }
            };
            getTokenRequest.failureBlock = ^(NSError * _Nonnull error) {
                NSLog(@"获取 NIM token 失败");
            };
            [getTokenRequest start];


            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SVProgressHUD dismissWithDelay:0.5 completion:^{
                TJMainViewController *mainViewController = TJMainViewController.new;
                mainViewController.transitioningDelegate = self;
                [self presentViewController:mainViewController animated:YES completion:^{
                    [UIApplication sharedApplication].delegate.window.rootViewController = mainViewController;
                }];
            }];
        }
    }];
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return TJLoginViewPresentAnimation.new;
}

#pragma mark - getter & setter
- (TJLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[TJLoginView alloc] initWithFrame:self.view.bounds];
        weakify(self);
        _loginView.loginBlock = ^{
            strongify(self);
            [self doLogin];
        };
    }
    return _loginView;
}

@end
