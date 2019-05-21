//
//  AppDelegate.m
//  TJGroup
//
//  Created by 李佳乐 on 2019/5/3.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "AppDelegate.h"
#import "TJLoginViewController.h"
#import "TJMainViewController.h"
#import <NIMSDK/NIMSDK.h>

@interface AppDelegate () <NIMLoginManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupNIMSDK];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([TJUserManager manager].logedIn) {
        self.window.rootViewController = TJMainViewController.new;
//        [self loginToNIM];
        [self mockLogin];
    } else {
        self.window.rootViewController = TJLoginViewController.new;
    }
    
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    [[UINavigationBar appearance] setTintColor:THEME_COLOR];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupNIMSDK {
    NSString *appKey        = @"14b1a6ebed8d8cb2262d150cebe15b15";
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:appKey];
//    option.apnsCername      = @"your APNs cer name";
//    option.pkCername        = @"your pushkit cer name";
    [[NIMSDK sharedSDK] registerWithOption:option];
}

- (void)loginToNIM {
    TJUser *user = [TJUserManager manager].currentUser;
    if (user.accid && user.token) {
        NIMAutoLoginData *data = NIMAutoLoginData.new;
        data.account = user.accid;
        data.token = user.token;
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        [[[NIMSDK sharedSDK] loginManager] autoLogin:data];
        
//        [[[NIMSDK sharedSDK] loginManager] login:user.accid token:user.token completion:^(NSError * _Nullable error) {
//            NSLog(@"%@", error);
//        }];
    }
}

- (void)mockLogin {
    TJUser *user = TJUser.new;
    user.userId = @"1550000";
    user.accid = @"1550000";
    user.token = @"d5bfe3dfb5fd25ebd260a3482a875318";
//    [[[NIMSDK sharedSDK] loginManager] login:user.accid token:user.token completion:^(NSError * _Nullable error) {
//        NSLog(@"mock login success");
//        [TJUserManager manager].logedIn = YES;
//    }];
    [TJUserManager manager].currentUser = user;
    NIMAutoLoginData *data = NIMAutoLoginData.new;
    data.account = user.accid;
    data.token = user.token;
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[[NIMSDK sharedSDK] loginManager] autoLogin:data];
}

- (void)onLogin:(NIMLoginStep)step {
    if (step == NIMLoginStepLoginOK) {
        NSLog(@"登录 NIM 成功");
    }
}

- (void)onAutoLoginFailed:(NSError *)error {
    NSLog(@"自动登录 NIM 失败");
}

@end
