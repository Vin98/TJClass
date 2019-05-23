//
//  TJPinyinConverter.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/19.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "TJPinyinConverter.h"

@implementation TJPinyinConverter
+ (TJPinyinConverter *)sharedInstance
{
    static TJPinyinConverter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TJPinyinConverter alloc] init];
    });
    return instance;
}


- (NSString *)toPinyin: (NSString *)source
{
    if ([source length] == 0)
    {
        return nil;
    }
    NSMutableString *piyin = [NSMutableString stringWithString:source];
    CFStringTransform((__bridge CFMutableStringRef)piyin, NULL, kCFStringTransformToLatin, false);
    
    NSString *py = [piyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [py stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

@end
