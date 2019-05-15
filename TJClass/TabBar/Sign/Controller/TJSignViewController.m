//
//  TJSignViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignViewController.h"
#import "TJSignClassCell.h"

@interface TJSignViewController ()

@end

@implementation TJSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    self.tableView.estimatedRowHeight = 80.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TJSignClassCell class] forCellReuseIdentifier:NSStringFromClass([TJSignClassCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJSignClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJSignClassCell class]) forIndexPath:indexPath];
    TJClass *class = TJClass.new;
    class.className = @"计算机一班";
    cell.cls = class;
    return cell;
}

@end
