//
//  TJGenderSettingViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJGenderSettingViewController.h"
#import "NIMCommonTableDelegate.h"
#import "NIMCommonTableData.h"

@interface TJGenderSettingViewController ()

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NIMUserGender           selectedGender;

@end

@implementation TJGenderSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav];
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.selectedGender = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.gender;
    [self buildData];
    weakify(self);
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        strongify(self);
        return self.data;
    }];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self.tableView reloadData];
}

- (void)setUpNav{
    self.navigationItem.title = @"性别";
}


- (void)buildData{
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title         : @"男",
                                      CellClass     : @"TJSettingCheckCell",
                                      RowHeight     : @(50),
                                      CellAction    : @"onTouchMaleCell:",
                                      ExtraInfo     : @(self.selectedGender == NIMUserGenderMale),
                                      ForbidSelect  : @(YES),
                                      },
                                  @{
                                      Title         : @"女",
                                      CellClass     : @"TJSettingCheckCell",
                                      RowHeight     : @(50),
                                      CellAction    : @"onTouchFemaleCell:",
                                      ExtraInfo     : @(self.selectedGender == NIMUserGenderFemale),
                                      ForbidSelect  : @(YES),
                                      },
                                  @{
                                      Title         : @"其他",
                                      CellClass     : @"TJSettingCheckCell",
                                      CellAction    : @"onTouchUnkownGenderCell:",
                                      RowHeight     : @(50),
                                      ExtraInfo     : @(self.selectedGender == NIMUserGenderUnknown),
                                      ForbidSelect  : @(YES),
                                      },
                                  ],
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)refresh{
    [self buildData];
    [self.tableView reloadData];
}

- (void)onTouchMaleCell:(id)sender{
    self.selectedGender = NIMUserGenderMale;
    [self remoteUpdateGender];
    [self refresh];
}

- (void)onTouchFemaleCell:(id)sender{
    self.selectedGender = NIMUserGenderFemale;
    [self remoteUpdateGender];
    [self refresh];
}

- (void)onTouchUnkownGenderCell:(id)sender{
    self.selectedGender = NIMUserGenderUnknown;
    [self remoteUpdateGender];
    [self refresh];
}

- (void)remoteUpdateGender{
    [SVProgressHUD show];
    weakify(self);
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagGender) : @(self.selectedGender)} completion:^(NSError *error) {
        strongify(self);
        if (!error) {
            UINavigationController *nav = self.navigationController;
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [SVProgressHUD dismissWithDelay:1.f completion:^{
                [nav popViewControllerAnimated:YES];
            }];
            
        }else{
            NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
            self.selectedGender = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.gender;
            [SVProgressHUD showErrorWithStatus:@"设置失败"];
            [SVProgressHUD dismissWithDelay:1.f];
            [self refresh];
        }
    }];
}

@end
