//
//  TJSignRecordDetailViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignRecordDetailViewController.h"

@interface TJSignRecordDetailViewController ()

@property (nonatomic, strong) NIMSession *session;

@property (nonatomic, strong) NSArray *signedUsers;

@property (nonatomic, strong) NSMutableArray *unsignedUsers;

@end

@implementation TJSignRecordDetailViewController

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.session = session;
        self.signedUsers = @[];
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
    self.signedUsers = self.sign.signedUsers;
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
        for (NIMTeamMember *member in members) {
            if (![self.signedUsers containsObject:member.userId] && ![team.owner isEqualToString:member.userId] ) {
                [self.unsignedUsers addObject:member.userId];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.unsignedUsers[indexPath.row];
    } else {
        cell.textLabel.text = self.signedUsers[indexPath.row];
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
