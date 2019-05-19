//
//  TJContactUtilCell.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJContactDefines.h"

@protocol TJContactUtilCellDelegate <NSObject>

- (void)onPressUtilImage:(NSString *)content;

@end

@interface TJContactUtilCell : UITableViewCell

@property (nonatomic,weak) id<TJContactUtilCellDelegate> delegate;

- (void)refreshWithContactItem:(id<TJContactItem>)item;

@end
