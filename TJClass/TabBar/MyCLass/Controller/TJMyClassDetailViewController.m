//
//  TJMyClassDetailViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMyClassDetailViewController.h"
#import "TJMyClassDetailView.h"

@interface TJMyClassDetailViewController ()

@property (nonatomic, strong) TJMyClassDetailView *detailView;
@property (nonatomic, strong) TJGroup *group;

@end

@implementation TJMyClassDetailViewController

- (instancetype)initWithClass:(TJGroup *)group {
    self = [super init];
    if (self) {
        self.group = group;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.title = self.group.groupName ?: @"班级";
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailView = [[TJMyClassDetailView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.detailView];
}

@end
