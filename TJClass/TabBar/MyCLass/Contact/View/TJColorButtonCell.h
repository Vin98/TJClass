//
//  TJColorButtonCell.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/20.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIMCommonTableViewCell.h"

typedef NS_ENUM(NSInteger, TJColorButtonCellStyle){
    TJColorButtonCellStyleRed,
    TJColorButtonCellStyleBlue,
};

@class TJColorButton;

@interface TJColorButtonCell : UITableViewCell<NIMCommonTableViewCell>

@property (nonatomic,strong) TJColorButton *button;

@end



@interface TJColorButton : UIButton

@property (nonatomic,assign) TJColorButtonCellStyle style;

@end
