//
//  TJAddFriendViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/18.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJAddFriendViewController.h"
#import <NIMKit/NIMCommonTableDelegate.h>
#import <NIMKit/NIMCommonTableData.h>

@interface TJAddFriendViewController ()

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NSInteger               inputLimit;

@end

@implementation TJAddFriendViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    __weak typeof(self) wself = self;
    [self buildData];
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
}


- (void)buildData{
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title         : @"请输入帐号",
                                      CellClass     : @"TJAddFriendCell",
                                      RowHeight     : @(50),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *userId = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (userId.length) {
        userId = [userId lowercaseString];
        [self addFriend:userId];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


#pragma mark - Private
- (void)addFriend:(NSString *)userId{
    __weak typeof(self) wself = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
        [SVProgressHUD dismiss];
        if (users.count) {
            
            NIMUserRequest *request = [[NIMUserRequest alloc] init];
            request.userId = userId;
            request.operation = NIMUserOperationAdd;
//            request.operation = NIMUserOperationRequest;
//            request.message = @"跪求通过";
            NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
            NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败" : @"请求失败";
            
            [SVProgressHUD show];
            [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
                [SVProgressHUD dismiss];
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:successText];
                    [SVProgressHUD dismissWithDelay:1];
                    
                    UINavigationController *nav = self.navigationController;
                    NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
                    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:session];
                    [nav pushViewController:vc animated:YES];
                    UIViewController *root = nav.viewControllers[0];
                    nav.viewControllers = @[root,vc];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:failedText];
                    [SVProgressHUD dismissWithDelay:2];
                }
            }];
            
        }else{
            if (wself) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户不存在" message:@"请检查你输入的帐号是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

@end
