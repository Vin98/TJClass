//
//  TJAliasSettingViewController.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJAliasSettingViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
