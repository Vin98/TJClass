//
//  TJMineViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMineViewController.h"
#import "TJMineHeaderView.h"

@interface TJMineViewController ()

@property (nonatomic, strong) TJMineHeaderView *headerView;

@end

@implementation TJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = @"我的资料";
    return cell;
}

- (TJMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TJMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [TJMineHeaderView typicalHeight])];
    }
    return _headerView;
}

@end
