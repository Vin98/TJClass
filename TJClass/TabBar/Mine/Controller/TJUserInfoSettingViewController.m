//
//  TJUserInfoSettingViewController.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJUserInfoSettingViewController.h"
#import "TJSettingPortraitCell.h"
#import "TJNickNameSettingViewController.h"
#import "TJGenderSettingViewController.h"
#import "TJMobileSettingViewController.h"
#import <NIMKit/NIMCommonTableData.h>
#import <NIMKit/NIMCommonTableDelegate.h>
#import <NIMKit/NIMKitFileLocationHelper.h>
#import <NIMKit/UIImage+NIMKit.h>
#import <SDWebImage/SDWebImageManager.h>

@interface TJUserInfoSettingViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, NIMUserManagerDelegate>

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy)   NSArray *data;

@end

@implementation TJUserInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    [self buildData];
    weakify(self);
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        strongify(self);
        return self.data;
    }];
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)buildData {
    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : me.userId ? me.userId : [NSNull null],
                                      CellClass     : @"TJSettingPortraitCell",
                                      RowHeight     : @(100),
                                      CellAction    : @"onTouchPortrait:",
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      Title      : @"昵称",
                                      DetailTitle: me.userInfo.nickName.length ? me.userInfo.nickName : @"未设置",
                                      CellAction : @"onTouchNickSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES),
                                      },
                                  @{
                                      Title      : @"性别",
                                      DetailTitle: [TJUserManager genderString:me.userInfo.gender],
                                      CellAction : @"onTouchGenderSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  @{
                                      Title      :@"手机",
                                      DetailTitle:me.userInfo.mobile.length ? me.userInfo.mobile : @"未设置",
                                      CellAction :@"onTouchTelSetting:",
                                      RowHeight     : @(50),
                                      ShowAccessory : @(YES)
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)refresh{
    [self buildData];
    [self.tableView reloadData];
}

- (void)onTouchPortrait:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:takeAction];
    }
    [alert addAction:libraryAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate      = self;
    picker.sourceType    = type;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)onTouchNickSetting:(id)sender{
    TJNickNameSettingViewController *vc = [[TJNickNameSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchGenderSetting:(id)sender{
    TJGenderSettingViewController *vc = [[TJGenderSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchTelSetting:(id)sender{
    TJMobileSettingViewController *vc = [[TJMobileSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NIMUserManagerDelagate
- (void)onUserInfoChanged:(NIMUser *)user
{
    if ([user.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        [self refresh];
    }
}


#pragma mark - Private
- (void)uploadImage:(UIImage *)image{
    UIImage *imageForAvatarUpload = [image nim_imageForAvatarUpload];
    NSString *fileName = [NIMKitFileLocationHelper genFilenameWithExt:@"jpg"];
    NSString *filePath = [[NIMKitFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
    NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
    BOOL success = data && [data writeToFile:filePath atomically:YES];
    weakify(self);
    if (success) {
        [SVProgressHUD show];
        [[NIMSDK sharedSDK].resourceManager upload:filePath scene:NIMNOSSceneTypeAvatar progress:nil completion:^(NSString *urlString, NSError *error) {
            strongify(self);
            [SVProgressHUD dismiss];
            if (!error) {
                [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                    if (!error) {
                        [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                        [self refresh];
                    } else{
                        [SVProgressHUD showErrorWithStatus:@"设置头像失败，请重试"];
                        [SVProgressHUD dismissWithDelay:2.f];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重试"];
                [SVProgressHUD dismissWithDelay:2.f];
            }
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"图片保存失败，请重试"];
        [SVProgressHUD dismissWithDelay:2.f];
    }
}


@end
