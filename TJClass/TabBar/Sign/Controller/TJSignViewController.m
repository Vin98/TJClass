//
//  TJSignViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignViewController.h"
#import "TJSignClassCell.h"
#import "TJJoinedClassesRequest.h"
#import "TJRefreshHeader.h"

@interface TJSignViewController ()

@property (nonatomic, strong) NSMutableArray<TJGroup *> *groups;
@property (nonatomic, strong) TJJoinedClassesRequest *joinedClassesRequest;

@end

@implementation TJSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    self.tableView.estimatedRowHeight = 80.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    weakify(self);
    self.tableView.mj_header = [TJRefreshHeader headerWithRefreshingBlock:^{
        strongify(self);
        [self refreshData];
    }];
    
    [self.tableView registerClass:[TJSignClassCell class] forCellReuseIdentifier:NSStringFromClass([TJSignClassCell class])];
    self.groups = @[].mutableCopy;
    [self.tableView.mj_header beginRefreshing];
    [self refreshData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJSignClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJSignClassCell class]) forIndexPath:indexPath];
    TJGroup *group = TJGroup.new;
    group.groupName = self.groups[indexPath.row].groupName;
    cell.cls = group;
    return cell;
}

#pragma mark - api

- (void)refreshData {
    if (self.joinedClassesRequest) {
        [self.joinedClassesRequest cancel];
        self.joinedClassesRequest = nil;
    }
    [self.groups removeAllObjects];
    self.joinedClassesRequest = TJJoinedClassesRequest.new;
    weakify(self);
    self.joinedClassesRequest.successBlock = ^(id  _Nonnull result) {
        strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSArray *data = result[@"data"];
        if (data.count > 0) {
            for (NSDictionary *dic in data) {
                TJGroup *group = [TJGroup yy_modelWithDictionary:dic];
                [self.groups addObject:group];
            }
            [self.tableView reloadData];
        }
    };
    self.joinedClassesRequest.failureBlock = ^(NSError * _Nonnull error) {
        strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@", error);
    };
    [self.joinedClassesRequest start];
}

@end
