//
//  TJNickNameSettingViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJNickNameSettingViewController.h"
#import "NIMCommonTableDelegate.h"
#import "NIMCommonTableData.h"

@interface TJNickNameSettingViewController ()

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NSInteger               inputLimit;

@property (nonatomic,copy  ) NSString                *nick;

@end

@implementation TJNickNameSettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inputLimit = 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    NSString *uid  = [[NIMSDK sharedSDK].loginManager currentAccount];
    NIMUser *me    = [[NIMSDK sharedSDK].userManager userInfo:uid];
    self.nick      = me.userInfo.nickName? me.userInfo.nickName : @"";
    [self buildData];
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
    self.navigationItem.title = @"昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender{
    [self.view endEditing:YES];
    if (!self.nick.length) {
        [SVProgressHUD showInfoWithStatus:@"昵称不能为空"];
        [SVProgressHUD dismissWithDelay:2.f];
        return;
    }
    if (self.nick.length > self.inputLimit) {
        [SVProgressHUD showInfoWithStatus:@"昵称过长"];
        [SVProgressHUD dismissWithDelay:2.f];
        return;
    }
    [SVProgressHUD show];
    weakify(self);
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagNick) : self.nick} completion:^(NSError *error) {
        strongify(self);
        [SVProgressHUD dismiss];
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"昵称设置成功"];
            [SVProgressHUD dismissWithDelay:1.f];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"昵称设置失败，请重试"];
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
                                      ExtraInfo     : self.nick,
                                      CellClass     : @"TJTextSettingCell",
                                      RowHeight     : @(50),
                                      },
                                  ],
                          FooterTitle:@"请使用真实姓名以便同学可以更快找到你哦"
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
    self.nick = textField.text;
}

@end
