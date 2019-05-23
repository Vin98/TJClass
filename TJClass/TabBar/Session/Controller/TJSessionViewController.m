//
//  TJSessionViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSessionViewController.h"
#import "TJSessionUtil.h"
#import "TJPersonCardViewController.h"
#import "TJSessionConfig.h"
#import "TJCreateSignViewController.h"
#import "TJSignViewController.h"
#import "TJSignRecordViewController.h"
#import <NIMKit/NIMNormalTeamCardViewController.h>

@interface TJSessionViewController () <NIMNormalTeamCardVCProtocol>

@property (nonatomic,strong)    TJSessionConfig       *sessionConfig;

@end

@implementation TJSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigation];
}

- (id<NIMSessionConfig>)sessionConfig {
    if (!_sessionConfig) {
        _sessionConfig = TJSessionConfig.new;
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

- (void)setupNavigation {
    
    UIBarButtonItem *enterUserInfoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_session_info_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(enterPersonInfoCard:)];
    
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_session_info_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(enterTeamCard:)];
    
    UIBarButtonItem *recordHistoryItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_sign_clock"] style:UIBarButtonItemStylePlain target:self action:@selector(onSignRecordHistoryAction:)];
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        if ([team.owner isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            self.navigationItem.rightBarButtonItems = @[enterTeamCardItem, recordHistoryItem];
        } else {
            self.navigationItem.rightBarButtonItem = enterTeamCardItem;
        }
    } else {
        self.navigationItem.rightBarButtonItem = enterUserInfoItem;
    }
}

- (void)onSignRecordHistoryAction:(id)sender {
    TJSignRecordViewController *recordVC = TJSignRecordViewController.new;
    recordVC.session = self.session;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)enterTeamCard:(id)sender {
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:self.session];
    BOOL isTop = [TJSessionUtil recentSessionIsMark:recent type:TJRecentSessionMarkTypeTop ];
    NIMNormalTeamCardViewController *vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team exConfig:@{kNIMNormalTeamCardConfigTopKey:@(isTop)}];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterPersonInfoCard:(id)sender {
    TJPersonCardViewController *vc = [[TJPersonCardViewController alloc] initWithSession:self.session];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NIMNormalTeamCardVCProtocol, NIMAdvancedTeamCardVCProtocol
- (void)NIMNormalTeamCardVCDidSetTop:(BOOL)isTop {
    [self doTopSession:isTop];
}

- (void)NIMAdvancedTeamCardVCDidSetTop:(BOOL)isTop {
    [self doTopSession:isTop];
}

- (void)doTopSession:(BOOL)isTop {
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:self.session];
    if (isTop) {
        if (!recent) {
            [[NIMSDK sharedSDK].conversationManager addEmptyRecentSessionBySession:self.session];
        }
        [TJSessionUtil addRecentSessionMark:self.session type:TJRecentSessionMarkTypeTop];
    } else {
        if (recent) {
            [TJSessionUtil removeRecentSessionMark:self.session type:TJRecentSessionMarkTypeTop];
        } else {}
    }
}

- (void)onTapMediaItemSign:(NIMMediaItem *)item {
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    if ([team.owner isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        TJCreateSignViewController *createSignViewController = [[TJCreateSignViewController alloc] initWithSession:self.session];
        [self.navigationController pushViewController:createSignViewController animated:YES];
    } else {
        TJSignViewController *vc = [[TJSignViewController alloc] init];
        vc.session = self.session;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
