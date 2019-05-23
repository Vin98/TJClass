//
//  TJMySignRecordViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMySignRecordViewController.h"
#import "TJUserSignRecordRequest.h"
#import "TJUserSignRecord.h"
#import "TJRefreshHeader.h"
#import <CoreLocation/CoreLocation.h>

@interface TJMySignRecordViewController ()

@property (nonatomic, strong) NSMutableArray <TJUserSignRecord *> *records;

@end

@implementation TJMySignRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的签到记录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.allowsSelection = NO;
    
    weakify(self);
    self.tableView.mj_header = [TJRefreshHeader headerWithRefreshingBlock:^{
        strongify(self);
        [self loadData];
    }];
    
    self.records = @[].mutableCopy;
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"TJMySignRecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    TJUserSignRecord *record = self.records[indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:record.startTime.doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-d HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    cell.textLabel.text = dateString;
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:record.userLat.doubleValue longitude:record.userLon.doubleValue];
    CLLocation *signLocation = [[CLLocation alloc] initWithLatitude:record.signLat.doubleValue longitude:record.signLon.doubleValue];
    CLLocationDistance meters = [userLocation distanceFromLocation:signLocation];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"距离发起签到点%.2fm", meters];
    if (meters > 50) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    } else {
        cell.detailTextLabel.textColor = THEME_COLOR;
    }
    return cell;
}

- (void)loadData {
    TJUserSignRecordRequest *request = TJUserSignRecordRequest.new;
    weakify(self);
    request.successBlock = ^(id  _Nonnull result) {
        strongify(self);
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            NSArray *data = result[@"data"];
            if (data && [data isKindOfClass:[NSArray class]]) {
                [self.records removeAllObjects];
                for (NSDictionary *dic in data) {
                    TJUserSignRecord *record = [TJUserSignRecord yy_modelWithDictionary:dic];
                    [self.records addObject:record];
                }
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }
        }
    };
    request.failureBlock = ^(NSError * _Nonnull error) {
        strongify(self);
        [self.tableView.mj_header endRefreshing];
    };
    
    [request start];
}


@end
