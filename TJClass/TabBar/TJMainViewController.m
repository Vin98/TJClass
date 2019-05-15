//
//  TJMainViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMainViewController.h"
#import "TJChatViewController.h"
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
    
    TJChatViewController *chatViewController = TJChatViewController.new;
    UITabBarItem *chatBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"tabbar_chat"] selectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    chatViewController.tabBarItem = chatBarItem;
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [viewControlers addObject:chatNav];
    
    TJMineViewController *mineViewController = TJMineViewController.new;
    UITabBarItem *mineBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"login_user"] selectedImage:[UIImage imageNamed:@"login_user"]];
    mineViewController.tabBarItem = mineBarItem;
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    [viewControlers addObject:mineNav];
    
    self.viewControllers = viewControlers;
}

@end
