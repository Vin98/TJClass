//
//  TJPersonalCardViewController.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJPersonalCardViewController : UIViewController

- (instancetype)initWithUserId:(NSString *)userId;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
