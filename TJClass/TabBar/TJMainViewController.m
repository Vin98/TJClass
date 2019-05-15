//
//  TJMainViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMainViewController.h"
#import "TJChatViewController.h"
#import "TJSignViewController.h"
#import "TJMineViewController.h"

@interface TJMainViewController ()

@end

@implementation TJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = THEME_COLOR;
    [self _addViewControllers];
}

- (void)_addViewControllers {
    NSMutableArray <__kindof UIViewController *> *viewControlers = NSMutableArray.new;
    
    //聊天
    TJChatViewController *chatViewController = TJChatViewController.new;
    UITabBarItem *chatBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"tabbar_chat"] selectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    chatViewController.tabBarItem = chatBarItem;
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [viewControlers addObject:chatNav];
    
    //签到
    TJSignViewController *signViewController = TJSignViewController.new;
    UITabBarItem *signBarItem = [[UITabBarItem alloc] initWithTitle:@"签到" image:[UIImage imageNamed:@"tabbar_chat"] selectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    signViewController.tabBarItem = signBarItem;
    UINavigationController *signNav = [[UINavigationController alloc] initWithRootViewController:signViewController];
    [viewControlers addObject:signNav];
    
    //我
    TJMineViewController *mineViewController = TJMineViewController.new;
    UITabBarItem *mineBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"login_user"] selectedImage:[UIImage imageNamed:@"login_user"]];
    mineViewController.tabBarItem = mineBarItem;
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    [viewControlers addObject:mineNav];
    
    self.viewControllers = viewControlers;
}

@end
