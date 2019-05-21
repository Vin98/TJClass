//
//  TJMineViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMineViewController.h"
#import "TJMineHeaderView.h"
#import <NIMKit/NIMCommonTableData.h>
#import <NIMKit/NIMCommonTableDelegate.h>
#import <UserNotifications/UserNotifications.h>

@interface TJMineViewController () <NIMUserManagerDelegate>

@property (nonatomic, strong) TJMineHeaderView *headerView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NIMCommonTableDelegate *delegator;

@end

@implementation TJMineViewController

- (void)viewDidLayoutSubviews {
    if (@available(iOS 11.0, *)) {
        CGFloat height = self.view.safeAreaInsets.bottom;
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildData];
    weakify(self);
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        strongify(self);
        return self.data;
    }];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)buildData{
//    BOOL disableRemoteNotification = [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone;
    
    __block BOOL disableRemoteNotification = YES;
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusNotDetermined) {
            disableRemoteNotification = settings.alertSetting == UNAlertStyleNone;
        }
    }];
    NIMPushNotificationSetting *setting = [[NIMSDK sharedSDK].apnsManager currentSetting];
    
    NSArray *data = @[
                      @{
                          HeaderTitle : @"",
                          RowContent : @[
                                  @{
                                      Title : @"我的签到记录",
                                      CellAction : @"onActionMySignRecord:",
                                      ShowAccessory : @(YES)
                                      }
                                  ]
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      :@"消息提醒",
                                      DetailTitle:disableRemoteNotification ? @"未开启" : @"已开启",
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@"在iPhone的“设置- 通知中心”功能，找到应用程序“同课堂”，可以更改同课堂新消息提醒设置"
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title        : @"通知显示详情",
                                      CellClass    : @"TJSettingSwitcherCell",
                                      ExtraInfo    : @(setting.type == NIMPushNotificationDisplayTypeDetail? YES : NO),
                                      CellAction   : @"onActionShowPushDetailSetting:",
                                      ForbidSelect : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)refreshData{
    [self buildData];
    [self.tableView reloadData];
}

- (TJMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TJMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [TJMineHeaderView typicalHeight])];
    }
    return _headerView;
}

#pragma mark - Action

- (void)onActionMySignRecord:(id)sender {
    
}

- (void)onActionShowPushDetailSetting:(UISwitch *)switcher
{
    NIMPushNotificationSetting *setting = [NIMSDK sharedSDK].apnsManager.currentSetting;
    setting.type = switcher.on? NIMPushNotificationDisplayTypeDetail : NIMPushNotificationDisplayTypeNoDetail;
    [[NIMSDK sharedSDK].apnsManager updateApnsSetting:setting completion:^(NSError * _Nullable error) {
        if (error)
        {
            [SVProgressHUD showErrorWithStatus:@"更新失败"];
            [SVProgressHUD dismissWithDelay:2.f];
            switcher.on = !switcher.on;
        }
    }];
}

@end
