//
//  TJMyClassDetailViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMyClassDetailViewController.h"
#import "TJMyClassDetailView.h"
#import "TJCreateSignRequest.h"

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
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeTop;
    self.title = self.group.groupName ?: @"班级";
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailView = ({
        TJMyClassDetailView *detailView = [[TJMyClassDetailView alloc] initWithFrame:self.view.bounds];
        detailView.gotoDetailPageBlock = ^{
            
        };
        detailView.gotoRecoedPageBlock = ^{
            
        };
        detailView.createSignBlock = ^{
            TJCreateSignRequest *createSignRequest = [[TJCreateSignRequest alloc] initWithGroupId:self.group.groupId groupName:self.group.groupName];
            createSignRequest.successBlock = ^(id  _Nonnull result) {
                if (result) {
                    BOOL success = [result[@"data"] boolValue];
                    if (success) {
                        [SVProgressHUD showSuccessWithStatus:@"已发起签到"];
                        [SVProgressHUD dismissWithDelay:1.f];
                    } else {
                        [SVProgressHUD showSuccessWithStatus:@"发起签到失败\n请稍后再试"];
                        [SVProgressHUD dismissWithDelay:1.f];
                    }
                }
            };
            createSignRequest.failureBlock = ^(NSError * _Nonnull error) {
                [SVProgressHUD showSuccessWithStatus:@"发起签到失败\n请稍后再试"];
                [SVProgressHUD dismissWithDelay:1.f];
            };
            [createSignRequest start];
        };
        detailView;
    });
    [self.view addSubview:self.detailView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.detailView.frame = self.view.bounds;
}

@end
