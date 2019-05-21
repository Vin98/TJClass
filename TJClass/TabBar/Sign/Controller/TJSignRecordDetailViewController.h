//
//  TJSignRecordDetailViewController.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/21.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJSign.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJSignRecordDetailViewController : UITableViewController

@property (nonatomic, strong) TJSign *sign;

- (instancetype)initWithSession:(NIMSession *)session;

@end

NS_ASSUME_NONNULL_END
