//
//  TJSignReecordViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignRecordViewController.h"
#import "TJSignViewController.h"
#import "TJSignRecordCell.h"
#import "TJGetCurrentSignRequest.h"
#import "TJRefreshHeader.h"
#import "TJSignRecordDetailViewController.h"

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
    [SVProgressHUD show];
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.signs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJSignRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJSignRecordCell class])];
    if (!cell) {
        cell = [[TJSignRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TJSignRecordCell class])];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TJSign *sign = self.signs[indexPath.row];
    [cell updateCellWithSign:sign];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TJSign *sign = self.signs[indexPath.row];
    TJSignRecordDetailViewController *detailVC = [[TJSignRecordDetailViewController alloc] initWithSession:self.session];
    detailVC.sign = sign;
    [self.navigationController pushViewController:detailVC animated:YES];
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
        [SVProgressHUD dismiss];
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
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        NSLog(@"%@", error);
    };
    [self.getSignsRequest start];
}

@end
