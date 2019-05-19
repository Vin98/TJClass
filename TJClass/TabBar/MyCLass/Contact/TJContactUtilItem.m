//
//  TJContactUtilItem.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJContactUtilItem.h"

@implementation TJContactUtilItem

- (NSString*)reuseId{
    return @"TJContactUtilItem";
}

- (NSString*)cellName{
    return @"TJContactUtilCell";
}

- (NSString*)title{
    return nil;
}

@end

@implementation TJContactUtilMember

- (NSString *)avatarUrl{
    return nil;
}

- (CGFloat)uiHeight{
    return TJContactUtilRowHeight;
}

- (NSString*)reuseId{
    return @"TJContactUtilItem";
}

- (NSString*)cellName{
    return @"TJContactUtilCell";
}

- (NSString *)groupTitle {
    return nil;
}

- (NSString *)memberId{
    return self.userId;
}

- (BOOL)showAccessoryView{
    return YES;
}

- (id)sortKey {
    return nil;
}

@end
