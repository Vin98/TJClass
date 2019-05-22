//
//  TJSignViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/15.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJSignViewController.h"
#import "TJSignClassCell.h"
#import "TJGetCurrentSignRequest.h"
#import "TJDoSignRequest.h"
#import "TJRefreshHeader.h"
#import <CoreLocation/CoreLocation.h>

@interface TJSignViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray<TJSign *> *signs;
@property (nonatomic, strong) TJGetCurrentSignRequest *getSignsRequest;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) TJSign *needUploadSign;
@property (nonatomic, assign, getter=isLoadingLocation) BOOL loadingLocation;

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
    
//    [self.tableView registerClass:[TJSignClassCell class] forCellReuseIdentifier:NSStringFromClass([TJSignClassCell class])];
    self.signs = @[].mutableCopy;
    [self.tableView.mj_header beginRefreshing];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.signs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TJSignClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJSignClassCell class]) forIndexPath:indexPath];
//    cell.sign = self.signs[indexPath.row];
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
    self.needUploadSign = sign;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [SVProgressHUD showErrorWithStatus:@"无地理位置访问权限"];
            [SVProgressHUD dismissWithDelay:1.f];
            return;
        } else {
            [self.locationManager stopUpdatingLocation];
            [self.locationManager startUpdatingLocation];
            self.loadingLocation = YES;
        }
    }
    [SVProgressHUD showWithStatus:@"获取位置信息..."];
}

#pragma mark - api

- (void)refreshData {
    if (self.getSignsRequest) {
        [self.getSignsRequest cancel];
        self.getSignsRequest = nil;
    }
    [self.signs removeAllObjects];
    self.getSignsRequest = [[TJGetCurrentSignRequest alloc] initWithTeamId:self.session.sessionId];
    weakify(self);
    self.getSignsRequest.successBlock = ^(id  _Nonnull result) {
        strongify(self);
        [self.tableView.mj_header endRefreshing];
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
        strongify(self);
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@", error);
    };
    [self.getSignsRequest start];
}

- (void)doSign {
    if (!self.location) {
        [SVProgressHUD showErrorWithStatus:@"获取位置信息失败"];
        return;
    }
    if (![self.needUploadSign.creater isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        CLLocationCoordinate2D coordinate = self.location.coordinate;
        TJDoSignRequest *doSignRequest = [[TJDoSignRequest alloc] initWithSignId:self.needUploadSign.id
                                                                             lat:[NSString stringWithFormat:@"%f", coordinate.latitude] lon:[NSString stringWithFormat:@"%f", coordinate.longitude]];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.location = locations.lastObject;
    [self.locationManager stopUpdatingLocation];
    self.loadingLocation = NO;
    [self doSign];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.location = nil;
    [self.locationManager stopUpdatingLocation];
    self.loadingLocation = NO;
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD showErrorWithStatus:@"获取位置信息失败"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.loadingLocation) {
        [self.locationManager startUpdatingLocation];
    }
}

@end
