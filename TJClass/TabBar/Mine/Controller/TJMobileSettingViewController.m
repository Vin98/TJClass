//
//  TJMobileSettingViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMobileSettingViewController.h"
#import "NIMCommonTableDelegate.h"
#import "NIMCommonTableData.h"

@interface TJMobileSettingViewController ()

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NSInteger               inputLimit;

@property (nonatomic,copy)   NSString                *mobile;

@end

@implementation TJMobileSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inputLimit = 13;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav];
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.mobile = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.mobile;
    self.mobile = self.mobile?self.mobile : @"";
    __weak typeof(self) wself = self;
    [self buildData];
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self.tableView reloadData];
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView becomeFirstResponder];
                break;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setUpNav{
    self.navigationItem.title = @"手机号码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender{
    [self.view endEditing:YES];
    if (self.mobile.length > self.inputLimit) {
        [SVProgressHUD showInfoWithStatus:@"手机号码过长"];
        [SVProgressHUD dismissWithDelay:2.f];
        return;
    }
    [SVProgressHUD show];
    weakify(self);
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagMobile) : self.mobile} completion:^(NSError *error) {
        strongify(self);
        if (!error) {
            UINavigationController *nav = self.navigationController;
            [SVProgressHUD showSuccessWithStatus:@"手机号设置成功"];
            [SVProgressHUD dismissWithDelay:1.f completion:^{
                [nav popViewControllerAnimated:YES];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"手机号设置失败，请重试"];
            [SVProgressHUD dismissWithDelay:1.f];
        }
    }];
}

- (void)buildData{
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : self.mobile,
                                      CellClass     : @"TJTextSettingCell",
                                      RowHeight     : @(50),
                                      },
                                  ],
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 如果是删除键
    if ([string length] == 0 && range.length > 0)
    {
        return YES;
    }
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.inputLimit && genString.length > self.inputLimit) {
        return NO;
    }
    return YES;
}


- (void)onTextFieldChanged:(NSNotification *)notification{
    UITextField *textField = notification.object;
    self.mobile = textField.text;
}

@end
