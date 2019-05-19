//
//  TJSessionListViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/18.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSessionListViewController.h"
#import "TJAddFriendViewController.h"
#import "TJSessionViewController.h"
#import <NIMKit/NIMContactSelectConfig.h>
#import <NIMKit/NIMContactSelectViewController.h>

@interface TJSessionListViewController ()

@end

@implementation TJSessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"聊天";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onOpera:)];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath {
//    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:recent.session];
    TJSessionViewController *vc = [[TJSessionViewController alloc] initWithSession:recent.session];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}

#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step{
    [super onLogin:step];
    switch (step) {
        case NIMLoginStepLinkFailed:
            self.navigationItem.title = @"(未连接)";
            break;
        case NIMLoginStepLinking:
            self.navigationItem.title = @"(连接中)";
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
            self.navigationItem.title = @"聊天";
            break;
        case NIMLoginStepLoginFailed:
            self.navigationItem.title = @"登录失败";
        case NIMLoginStepSyncing:
            self.navigationItem.title = @"(同步数据)";
            break;
        default:
            break;
    }
}

- (void)onOpera:(id)sender {
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加好友",@"创建高级群",@"创建讨论组",@"搜索高级群", nil];
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"选择操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addFriend = [UIAlertAction actionWithTitle:@"添加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJAddFriendViewController *addFriendViewController = TJAddFriendViewController.new;
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }];
    UIAlertAction *createGroup = [UIAlertAction actionWithTitle:@"创建群聊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentMemberSelector:^(NSArray *uids) {
            if (!uids.count) {
                return; //讨论组必须除自己外必须要有一个群成员
            }
            NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
            NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
            NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
            option.name       = @"讨论组";
            option.type       = NIMTeamTypeNormal;
            [SVProgressHUD show];
            [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId, NSArray<NSString *> * _Nullable failedUserIds) {
                [SVProgressHUD dismiss];
                if (!error) {
                    NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:session];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"创建失败"];
                    [SVProgressHUD dismissWithDelay:2.f];
                }
            }];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [sheet addAction:addFriend];
    [sheet addAction:createGroup];
    [sheet addAction:cancelAction];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)addFriend:(id)sender {
    TJAddFriendViewController *addVC = TJAddFriendViewController.new;
    [addVC hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:addVC animated:YES];
}


- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}

@end
