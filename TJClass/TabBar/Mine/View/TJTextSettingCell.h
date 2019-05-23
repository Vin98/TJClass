//
//  TJTextSettingCell.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/23.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMKit/NIMCommonTableViewCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJTextSettingCell : UITableViewCell <NIMCommonTableViewCell>

@property (nonatomic ,strong) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
