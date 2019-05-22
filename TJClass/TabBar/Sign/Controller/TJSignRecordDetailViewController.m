//
//  TJSignRecordDetailViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignRecordDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TJSignRecordDetailViewController ()

@property (nonatomic, strong) NIMSession *session;

@property (nonatomic, strong) NSMutableArray <TJSignedUser *> *signedUsers;

@property (nonatomic, strong) NSMutableArray <NIMTeamMember *> *unsignedUsers;

@end

@implementation TJSignRecordDetailViewController

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.session = session;
        self.signedUsers = @[].mutableCopy;
        self.unsignedUsers = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签到信息";
    [self buildData];
}

- (void)buildData {
//    self.signedUsers = self.sign.signedUsers;
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        for (NIMTeamMember *member in members) {
            BOOL memberDidSign = NO;
            for (TJSignedUser *signedUser in self.sign.signedUsers) {
                if ([signedUser.userid isEqualToString:member.userId]) {
                    memberDidSign = YES;
                    signedUser.userName = member.nickname;
                    [self.signedUsers addObject:signedUser];
                    break;
                }
            }
            if (!memberDidSign && ![member.userId isEqualToString:team.owner]) {
                [self.unsignedUsers addObject:member];
            }
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.signedUsers > 0) + (self.unsignedUsers > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.unsignedUsers.count;
    } else if (section == 1) {
        return self.signedUsers.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    if (indexPath.section == 0) {
        NIMTeamMember *member = self.unsignedUsers[indexPath.row];
        if (member.nickname) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", member.nickname, member.userId];
        } else {
            cell.textLabel.text = member.userId;
        }
    } else {
        TJSignedUser *signedUser = self.signedUsers[indexPath.row];
        if (signedUser.userName) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", signedUser.userName, signedUser.userid];
        } else {
            cell.textLabel.text = signedUser.userid;
        }
    
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:signedUser.lat.doubleValue longitude:signedUser.lon.doubleValue];
        CLLocation *signLocation = [[CLLocation alloc] initWithLatitude:self.sign.lat.doubleValue longitude:self.sign.lon.doubleValue];
        CLLocationDistance meters = [userLocation distanceFromLocation:signLocation];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"距离发起签到点%.2fm", meters];
        if (meters > 50) {
            cell.detailTextLabel.textColor = [UIColor redColor];
        } else {
            cell.detailTextLabel.textColor = THEME_COLOR;
        }
    }
 
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.unsignedUsers.count) {
        return @"未签到同学";
    } else if (section == 1 && self.signedUsers.count) {
        return @"已签到同学";
    }
    return @"";
}

@end
