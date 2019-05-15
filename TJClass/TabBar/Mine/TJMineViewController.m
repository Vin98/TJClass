//
//  TJMineViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/14.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMineViewController.h"
#import "TJMineHeaderView.h"

static const NSUInteger TJMineCellRecordCellIndex = 0;

@interface TJMineViewController ()

@property (nonatomic, strong) TJMineHeaderView *headerView;
//@property (nonatomic, strong) 

@end

@implementation TJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TJMineCell"];
    }
    switch (indexPath.row) {
        case TJMineCellRecordCellIndex:
            cell.imageView.image = [UIImage imageNamed:@"login_password"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"我的签到记录";
            break;
            
        default:
            break;
    }
    return cell;
}

- (TJMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TJMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [TJMineHeaderView typicalHeight])];
    }
    return _headerView;
}

@end
