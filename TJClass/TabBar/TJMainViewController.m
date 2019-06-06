//
//  TJMainViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMainViewController.h"
//#import "TJChatViewController.h"
#import "TJSessionListViewController.h"
#import "TJSignViewController.h"
#import "TJMineViewController.h"
//#import "TJMyClassesViewController.h"
//#import "TJGroupListViewController.h"
#import "TJContactViewController.h"

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
    
    TJSessionListViewController *sessionListViewController = TJSessionListViewController.new;
    UITabBarItem *chatBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"tabbar_chat"] selectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    sessionListViewController.tabBarItem = chatBarItem;
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:sessionListViewController];
    [viewControlers addObject:chatNav];

    //通讯录
    TJContactViewController *contactViewController = TJContactViewController.new;
    UITabBarItem *contactBarItem = [[UITabBarItem alloc] initWithTitle:@"班级" image:[UIImage imageNamed:@"tabbar_chat"] selectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    contactViewController.tabBarItem = contactBarItem;
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    [viewControlers addObject:contactNav];
    
    //我
    TJMineViewController *mineViewController = TJMineViewController.new;
    UITabBarItem *mineBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"login_user"] selectedImage:[UIImage imageNamed:@"login_user"]];
    mineViewController.tabBarItem = mineBarItem;
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    [viewControlers addObject:mineNav];
    
    self.viewControllers = viewControlers;
}

@end
