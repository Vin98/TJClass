//
//  TJMainViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMainViewController.h"
#import "TJChatViewController.h"

@interface TJMainViewController ()

@end

@implementation TJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _addViewControllers];
}

- (void)_addViewControllers {
    NSMutableArray <__kindof UIViewController *> *viewControlers = NSMutableArray.new;
    
    TJChatViewController *chatViewController = TJChatViewController.new;
    chatViewController.title = @"聊天";
    UITabBarItem *chatBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"tabbar_chat"] selectedImage:[UIImage imageNamed:@"tabbar_chat"]];
    chatViewController.tabBarItem = chatBarItem;
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [viewControlers addObject:chatNav];
    
    self.viewControllers = viewControlers;
}

@end
