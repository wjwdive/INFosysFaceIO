//
//  NSString+Utils.h
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/26.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
//字符串为类型错误  或者null NULL 返回 “”
+ (NSString *)isNullToString:(id)string;
-(BOOL)isVAlidPhoneNumber;
//正则匹配邮箱
-(BOOL)isValidEmail;
//正则匹配URL地址
-(BOOL)isValidUrl;
//判断字符串是否以某个字符串开头
-(BOOL)isBeginsWith:(NSString *)string;
//判断字符串是否以某个字符串结尾
-(BOOL)isEndssWith:(NSString *)string;
//判断字符串是否包含某个字符串
-(BOOL)containsString:(NSString *)subString;
//新字符串替换老字符串
-(NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
//截取字符串（字符串都是从第0个字符开始数的哦~）
-(NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
//添加字符串
-(NSString *)addString:(NSString *)string;
//从主字符串中移除某个字符串
-(NSString *)removeSubString:(NSString *)subString;
//去掉字符串中的空格
-(NSString *)removeWhiteSpacesFromString;
//判断字符串是否只包含字母-1
-(BOOL)containsOnlyLetters;
//判断字符串是否只包含字母-2（正则）
-(BOOL)isLetter;
//判断字符串是否只包含数字-1
-(BOOL)containsOnlyNumbers;
//判断字符串是否只包含数字-2（正则）
-(BOOL)isNumbers;
//判断字符串是否只包含数字和字母
-(BOOL)containsOnlyNumbersAndLetters;
//由字母或数字组成 6-18位密码字符串（正则）
-(BOOL)isPassword;
//判断数组中是否包含某个字符串
-(BOOL)isInThisarray:(NSArray*)array;
//字符串转Data
-(NSData *)convertToData;
//Data转字符转
+(NSString *)getStringFromData:(NSData *)data;

//获取系统版本号
+(NSString *)getMyApplicationVersion;
//字符串编码
-(NSString*)EncodingWithUTF8;
//获取当前时间
+(NSString*)getCurrentTimeString;
//通知字符串长度 （文字 2个字节 字母：1个字节）
// 统计ASCII和Unicode混合文本长度
-(NSUInteger) unicodeLengthOfString;
//计算属性字符文本占用的宽高
/**
 *  计算属性字符文本占用的宽高
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *  @param lineSpacing 行间距
 *  @return 占用的宽高
 */
-(CGSize)attrStrSizeWithFont:(UIFont *)font andmaxSize:(CGSize)maxSize lineSpacing:(CGFloat)lineSpacing;
//时间戳转时间
-(NSDate *)dateValueWithMillisecondsSince1970;
+ (NSDictionary *)getCurrentTime;
@end
