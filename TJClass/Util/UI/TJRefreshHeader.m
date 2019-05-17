//
//  TJRefreshHeader.m
//  TJGroup
//
//  Created by Vin Lee on 2019/5/16.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJRefreshHeader.h"

@implementation TJRefreshHeader

- (void)prepare {
    [super prepare];
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
}

@end
