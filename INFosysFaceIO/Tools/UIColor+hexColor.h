//
//  hexColor.h
//  ChinaWealth
//
//  Created by  易万军 on 15/4/3.
//  Copyright (c) 2015年 ChuanMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (NSString *)hexFromUIColor:(UIColor*) color;

@end
