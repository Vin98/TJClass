//
//  TJPersonCardViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJPersonCardViewController.h"
#import <NIMKit/NIMCommonTableDelegate.h>
#import <NIMKit/NIMMemberGroupView.h>
#import <NIMKit/NIMContactSelectViewController.h>
#import <NIMKit/NIMCommonTableData.h>
#import "TJSessionUtil.h"
#import "TJSessionViewController.h"

@interface TJPersonCardViewController () <NIMMemberGroupViewDelegate, NIMContactSelectDelegate>

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,strong) NIMSession *session;

@property (nonatomic,strong) NIMMemberGroupView *headerView;

@end

@implementation TJPersonCardViewController

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super init];
    if (self) {
        self.session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"聊天信息";
    weakify(self);
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        strongify(self);
        return self.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:245.0/255.0 alpha:1];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self.view addSubview:self.tableView];
    
    [self refresh];
    
}

- (void)refresh {
    [self buildData];
    [self bulidTableHeader:self.view.width];
    [self.tableView reloadData];
}

- (void)buildData{
    BOOL needNotify    = [[NIMSDK sharedSDK].userManager notifyForNewMsg:self.session.sessionId];
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:self.session];
    BOOL isTop = [TJSessionUtil recentSessionIsMark:recent type:TJRecentSessionMarkTypeTop];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title         : @"消息提醒",
                                      CellClass     : @"TJSettingSwitcherCell",
                                      RowHeight     : @(50),
                                      CellAction    : @"onActionNeedNotifyValueChange:",
                                      ExtraInfo     : @(needNotify),
                                      ForbidSelect  : @(YES)
                                      },
                                  @{
                                      Title         : @"聊天置顶",
                                      CellClass     : @"TJSettingSwitcherCell",
                                      RowHeight     : @(50),
                                      CellAction    : @"onActionNeedTopValueChange:",
                                      ExtraInfo     : @(isTop),
                                      ForbidSelect  : @(YES)
                                      }
                                  ],
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}


- (void)bulidTableHeader:(CGFloat)width{
    self.headerView = [[NIMMemberGroupView alloc] initWithFrame:CGRectZero];
    self.headerView.delegate = self;
    [self.headerView refreshUids:@[self.session.sessionId] operators:CardHeaderOpeatorAdd];
    [self.headerView setTitle:@"创建讨论组" forOperator:CardHeaderOpeatorAdd];
    CGSize size = [self.headerView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    self.headerView.size = size;
    self.tableView.tableHeaderView = self.headerView;
}


- (void)onActionNeedNotifyValueChange:(id)sender{
    UISwitch *switcher = sender;
    [SVProgressHUD show];
    weakify(self);
    [[NIMSDK sharedSDK].userManager updateNotifyState:switcher.on forUser:self.session.sessionId completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            strongify(self);
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
            [SVProgressHUD dismissWithDelay:2.f];
            [self refresh];
        }
    }];
}

- (void)onActionNeedTopValueChange:(id)sender {
    UISwitch *switcher = sender;
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:_session];
    if (switcher.isOn) {
        if (!recent) {
            [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:_session];
        }
        [TJSessionUtil addRecentSessionMark:_session type:TJRecentSessionMarkTypeTop];
    } else {
        if (recent) {
            [TJSessionUtil removeRecentSessionMark:_session type:TJRecentSessionMarkTypeTop];
        } else {}
    }
}

- (void)didSelectOperator:(NIMKitCardHeaderOpeator )opera{
    if (opera == CardHeaderOpeatorAdd) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        [users addObject:currentUserID];
        NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
        config.filterIds = users;
        config.needMutiSelected = YES;
        config.alreadySelectedMemberId = @[self.session.sessionId];
        NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
        vc.delegate = self;
        [vc show];
        
    }
}


#pragma mark - ContactSelectDelegate

- (void)didFinishedSelect:(NSArray *)selectedContacts{
    if (!selectedContacts.count) {
        return;
    }
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSArray *users = [@[uid] arrayByAddingObjectsFromArray:selectedContacts];
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name = @"讨论组";
    option.type = NIMTeamTypeNormal;
    weakify(self);
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].teamManager createTeam:option
                                         users:users
                                    completion:^(NSError * _Nullable error, NSString * _Nullable teamId, NSArray<NSString *> * _Nullable failedUserIds){
                                        
                                        strongify(self);
                                        [SVProgressHUD dismiss];
                                        if (!error) {
                                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                                            UINavigationController *nav = self.navigationController;
                                            [nav popToRootViewControllerAnimated:NO];
                                            TJSessionViewController *vc = [[TJSessionViewController alloc] initWithSession:session];
                                            vc.hidesBottomBarWhenPushed = YES;
                                            [nav pushViewController:vc animated:YES];
                                        }else{
                                            [SVProgressHUD showErrorWithStatus:@"创建群聊失败"];
                                            [SVProgressHUD dismissWithDelay:2.f];
                                        }
                                    }];
}


@end
