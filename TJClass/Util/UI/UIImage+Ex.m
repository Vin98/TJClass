//
//  UIImage+Ex.m
//  TJClass
//
//  Created by Vin Lee on 2019/5/17.
//  Copyright © 2019 Jiale Li. All rights reserved.
//

#import "UIImage+Ex.h"

static NSCache *imageCache;

@implementation UIImage (Ex)

+ (UIImage *)imageWithColor:(UIColor *)color {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });
    
    UIImage *image = [imageCache objectForKey:color];
    if (image) {
        return image;
    }
    image = [self imageWithColor:color size:CGSizeMake(1, 1)];
    [imageCache setObject:image forKey:color];
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
