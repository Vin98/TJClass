//
//  TJMyClassDetailView.h
//  TJGroup
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJMyClassDetailView : UIView

@property (nonatomic, copy) dispatch_block_t gotoDetailPageBlock;
@property (nonatomic, copy) dispatch_block_t gotoRecoedPageBlock;
@property (nonatomic, copy) dispatch_block_t createSignBlock;

@end

NS_ASSUME_NONNULL_END
