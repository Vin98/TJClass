//
//  TJContactUtilItem.h
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJContactDefines.h"
#import "TJGroupedContacts.h"

@interface TJContactUtilItem : NSObject<TJContactItemCollection>

@property (nonatomic,copy) NSArray *members;

@end

@interface TJContactUtilMember : NSObject<TJContactItem, TJGroupMemberProtocol>

@property (nonatomic,copy) NSString *nick;

@property (nonatomic,copy) NSString *badge;

@property (nonatomic,copy) UIImage *icon;

@property (nonatomic,copy) NSString *vcName;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *selName;

@end
