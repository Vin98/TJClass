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
    UIButton *enterTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterTeamCard addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterTeamCard sizeToFit];
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterTeamCard];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(enterPersonInfoCard:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
//
//    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [historyBtn addTarget:self action:@selector(enterHistory:) forControlEvents:UIControlEventTouchUpInside];
//    [historyBtn setImage:[UIImage imageNamed:@"icon_history_normal"] forState:UIControlStateNormal];
//    [historyBtn setImage:[UIImage imageNamed:@"icon_history_pressed"] forState:UIControlStateHighlighted];
//    [historyBtn sizeToFit];
//    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    UIBarButtonItem *recordHistoryItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_sign_clock"] style:UIBarButtonItemStylePlain target:self action:@selector(onSignRecordHistoryAction:)];
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        self.navigationItem.rightBarButtonItems = @[enterTeamCardItem, recordHistoryItem];
    } else {
        self.navigationItem.rightBarButtonItem = enterUInfoItem;
    }
}

- (void)onSignRecordHistoryAction:(id)sender {
    
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
