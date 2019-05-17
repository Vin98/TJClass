//
//  TJMyClassesViewController.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJMyClassesViewController.h"
#import "TJCreateClassRequest.h"
#import "TJGroup.h"
#import "TJSignClassCell.h"
#import "TJMyCreatedClassesRequest.h"
#import "TJRefreshHeader.h"
#import "TJMyClassDetailViewController.h"

@interface TJMyClassesViewController ()

@property (nonatomic, weak) UITextField *createClassTextField;
@property (nonatomic, strong) NSMutableArray <TJGroup *> *groups;
@property (nonatomic, strong) TJMyCreatedClassesRequest *myClassesRequest;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;

@end

@implementation TJMyClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的班级";
    self.groups = @[].mutableCopy;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createClass:)];
    self.navigationItem.rightBarButtonItem.tintColor = THEME_COLOR;
    [self.tableView registerClass:[TJSignClassCell class] forCellReuseIdentifier:NSStringFromClass([TJSignClassCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    weakify(self);
    self.tableView.mj_header = [TJRefreshHeader headerWithRefreshingBlock:^{
        strongify(self);
        self.refreshing = YES;
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJSignClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJSignClassCell class])];
    cell.cls = self.groups[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TJGroup *group = self.groups[indexPath.row];
    TJMyClassDetailViewController *detailViewController = [[TJMyClassDetailViewController alloc] initWithClass:group];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - api
- (void)loadData {
    if (self.myClassesRequest) {
        [self.myClassesRequest cancel];
        self.myClassesRequest = nil;
    }
    self.myClassesRequest = TJMyCreatedClassesRequest.new;
    weakify(self);
    self.myClassesRequest.successBlock = ^(id  _Nonnull result) {
        strongify(self);
        if (self.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            [self.groups removeAllObjects];
            self.refreshing = NO;
        }
        NSArray *data = result[@"data"];
        if (data.count > 0) {
            for (NSDictionary *dic in data) {
                TJGroup *group = [TJGroup yy_modelWithDictionary:dic];
                [self.groups addObject:group];
            }
            [self.tableView reloadData];
        }
    };
    self.myClassesRequest.failureBlock = ^(NSError * _Nonnull error) {
        strongify(self);
        [self.tableView.mj_header endRefreshing];
    };
    [self.myClassesRequest start];
}

- (void)createClass:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建新班级" message:@"请输入班级名称" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJCreateClassRequest *request = [[TJCreateClassRequest alloc] initWithName:self.createClassTextField.text];
        request.successBlock = ^(id  _Nonnull result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                TJGroup *group = [TJGroup yy_modelWithDictionary:result[@"data"]];
                if (group) {
                    [self.groups addObject:group];
                    [self.tableView reloadData];
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@(%@)\n创建成功", group.groupName, group.groupId]];
                    [SVProgressHUD dismissWithDelay:1];
                } else {
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n创建失败", self.createClassTextField.text]];
                    [SVProgressHUD dismissWithDelay:1];
                }
            });
        };
        request.failureBlock = ^(NSError * _Nonnull error) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n创建失败", self.createClassTextField.text]];
            [SVProgressHUD dismissWithDelay:1];
        };
        [request start];
    }];
    confirmAction.enabled = NO;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = THEME_COLOR;
        [textField addTarget:self action:@selector(alertTextFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.createClassTextField = textField;
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldTextDidChange:(id)sender {
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        NSString *name = alertController.textFields.firstObject.text;
        UIAlertAction *confirmAction = alertController.actions.firstObject;
        if (name.length > 0) {
            confirmAction.enabled = YES;
        } else {
            confirmAction.enabled = NO;
        }
    }
}

@end
