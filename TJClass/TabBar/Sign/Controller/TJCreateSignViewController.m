//
//  TJCreateSignViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJCreateSignViewController.h"
#import "TJCreateSignRequest.h"
#import <NIMKit/NIMCommonTableData.h>
#import <NIMKit/NIMCommonTableDelegate.h>
#import <CoreLocation/CoreLocation.h>

@interface TJCreateSignViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NIMCommonTableDelegate *delegator;

@property (nonatomic, copy) NSArray *data;

@property (nonatomic, strong) NIMSession *session;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic,assign) BOOL loadingLocation;

@end

@implementation TJCreateSignViewController

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super init];
    if (self) {
        self.session = session;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起签到";
    weakify(self);
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        strongify(self);
        return self.data;
    }];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self setTableViewFooter];
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self refresh];
}

- (void)refresh {
    [self buildData];
    [self.tableView reloadData];
}

- (void)buildData {
    NSArray *data = @[
                      @{
                          HeaderTitle : @"默认截止时间为30分钟，你也可以自定义签到截止时间\n请打开手机定位以计算签到距离",
                          RowContent : @[
                                  @{
                                      Title : @"设置截止时间",
                                      CellAction : @"onActionSetEndTime:",
                                      ShowAccessory : @(YES),
                                      }
                                  ],
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)setTableViewFooter {
    CGFloat buttonDiameter = SCREEN_WIDTH  / 3;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, buttonDiameter + 100)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:THEME_COLOR] forState:UIControlStateNormal];
    [button setTitle:@"发起\n签到" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 2;
    button.layer.cornerRadius = buttonDiameter / 2;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(onActionCreateSign:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button];
    button.bounds = CGRectMake(0, 0, buttonDiameter, buttonDiameter);
    button.center = footer.center;
    self.tableView.tableFooterView = footer;
}

#pragma mark - action
- (void)onActionSetEndTime:(id)sender {
    
}

- (void)onActionCreateSign:(id)sender {
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

- (void)createSign {
    CLLocationCoordinate2D coordinate = self.location.coordinate;
    TJCreateSignRequest *request = [[TJCreateSignRequest alloc] initWithTeamId:self.session.sessionId
                                                                       creater:[NIMSDK sharedSDK].loginManager.currentAccount
                                                                     startTime:[[NSDate date] timeIntervalSince1970]
                                                                       endTime:[[NSDate date] timeIntervalSince1970] + 1800
                                                                           lat:[NSString stringWithFormat:@"%f", coordinate.latitude]
                                                                           lon:[NSString stringWithFormat:@"%f", coordinate.longitude]];
    weakify(self);
    request.successBlock = ^(id  _Nonnull result) {
        BOOL success = NO;
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            if ([result[@"code"] integerValue] == 200 && [result[@"data"] boolValue] == YES) {
                success = YES;
            }
        }
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"签到已发起"];
            [SVProgressHUD dismissWithDelay:0.5 completion:^{
                strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"发起签到失败\n请稍后重试"];
            [SVProgressHUD dismissWithDelay:1.f];
        }
    };
    request.failureBlock = ^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发起签到失败\n请稍后重试"];
        [SVProgressHUD dismissWithDelay:1.f];
    };
    [request start];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.location = locations.lastObject;
    [self.locationManager stopUpdatingLocation];
    self.loadingLocation = NO;
    [self createSign];
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
