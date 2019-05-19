//
//  TJContactDefines.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#ifndef NIM_TJContactDefines_h
#define NIM_TJContactDefines_h

@protocol TJContactItemCollection <NSObject>
@required
//显示的title名
- (NSString*)title;

//返回集合里的成员
- (NSArray*)members;

//重用id
- (NSString*)reuseId;

//需要构造的cell类名
- (NSString*)cellName;

@end

@protocol TJContactItem<NSObject>
@required
//userId和Vcname必有一个有值，根据有值的状态push进不同的页面
- (NSString*)vcName;

//userId和Vcname必有一个有值，根据有值的状态push进不同的页面
- (NSString*)userId;

//返回行高
- (CGFloat)uiHeight;

//重用id
- (NSString*)reuseId;

//需要构造的cell类名
- (NSString*)cellName;

//badge
- (NSString *)badge;

//显示名
- (NSString *)nick;

//占位图
- (UIImage *)icon;

//头像url
- (NSString *)avatarUrl;

//accessoryView
- (BOOL)showAccessoryView;

@optional
- (NSString *)selName;


@end

@protocol TJContactCell <NSObject>

- (void)refreshWithContactItem:(id<TJContactItem>)item;

- (void)addDelegate:(id)delegate;

@end

#endif


#ifndef NIM_TJContactCellLayoutConstant_h
#define NIM_TJContactCellLayoutConstant_h

static const CGFloat   TJContactUtilRowHeight             = 57;//util类Cell行高
static const CGFloat   TJContactDataRowHeight             = 50;//data类Cell行高
static const NSInteger TJContactAvatarLeft                = 10;//没有选择框的时候，头像到左边的距离
static const NSInteger TJContactAvatarAndAccessorySpacing = 10;//头像和选择框之间的距离

#endif
