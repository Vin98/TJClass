//
//  TJSignReecordViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignRecordViewController.h"
#import "TJSignViewController.h"
#import "TJSignClassCell.h"
#import "TJGetCurrentSignRequest.h"
#import "TJDoSignRequest.h"
#import "TJRefreshHeader.h"

@interface TJSignRecordViewController ()

@property (nonatomic, strong) NSMutableArray<TJSign *> *signs;
@property (nonatomic, strong) TJGetCurrentSignRequest *getSignsRequest;

@end

@implementation TJSignRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签到记录";
    self.tableView.estimatedRowHeight = 80.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    [self.tableView registerClass:[TJSignClassCell class] forCellReuseIdentifier:NSStringFromClass([TJSignClassCell class])];
    self.signs = @[].mutableCopy;
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.signs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJSignClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJSignClassCell class])];
    if (!cell) {
        cell = [[TJSignClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TJSignClassCell class])];
    }
    TJSign *sign = self.signs[indexPath.row];
    cell.sign = sign;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TJSign *sign = self.signs[indexPath.row];
    if (![sign.creater isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        TJDoSignRequest *doSignRequest = [[TJDoSignRequest alloc] initWithSignId:sign.id];
        doSignRequest.successBlock = ^(id  _Nonnull result) {
            BOOL success = NO;
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                success = [result[@"data"] boolValue];
            }
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"签到成功"];
                [SVProgressHUD dismissWithDelay:1.f];
            } else {
                [SVProgressHUD showErrorWithStatus:@"签到失败"];
                [SVProgressHUD dismissWithDelay:1.f];
            }
        };
        doSignRequest.failureBlock = ^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"签到失败"];
            [SVProgressHUD dismissWithDelay:1.f];
        };
        [doSignRequest start];
    }
}

#pragma mark - api

- (void)loadData {
    if (self.getSignsRequest) {
        [self.getSignsRequest cancel];
        self.getSignsRequest = nil;
    }
    [self.signs removeAllObjects];
    self.getSignsRequest = [[TJGetCurrentSignRequest alloc] initWithTeamId:self.session.sessionId];
    weakify(self);
    self.getSignsRequest.successBlock = ^(id  _Nonnull result) {
        strongify(self);
        NSArray *data = result[@"data"];
        if (data && [data isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in data) {
                TJSign *sign = [TJSign yy_modelWithDictionary:dic];
                [self.signs addObject:sign];
            }
            [self.tableView reloadData];
        }
    };
    self.getSignsRequest.failureBlock = ^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    };
    [self.getSignsRequest start];
}

@end
