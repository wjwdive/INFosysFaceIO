//
//  NSString+Utils.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/26.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

//字符串为空返回 “”
+ (NSString *)isNullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return @"";
        
        
    }else
    {
        
        return (NSString *)string;
    }
}

//正则匹配电话号码
-(BOOL)isVAlidPhoneNumber
{
    NSString *regex = @"^(13|15|17|18|14)\\d{9}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch =[pred evaluateWithObject:self];
    return isMatch;
}

//正则匹配邮箱
-(BOOL)isValidEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

//正则匹配URL地址
-(BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

//判断字符串是否以某个字符串开头
-(BOOL)isBeginsWith:(NSString *)string
{
    return ([self hasPrefix:string]) ? YES : NO;
}

//判断字符串是否以某个字符串结尾
-(BOOL)isEndssWith:(NSString *)string
{
    return ([self hasSuffix:string]) ? YES : NO;
}
//判断字符串是否包含某个字符串
-(BOOL)containsString:(NSString *)subString
{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

//新字符串替换老字符串
-(NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar
{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

//截取字符串（字符串都是从第0个字符开始数的哦~）
-(NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end
{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

//添加字符串
-(NSString *)addString:(NSString *)string
{
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

//从主字符串中移除某个字符串
-(NSString *)removeSubString:(NSString *)subString
{
    if ([self containsString:subString])
    {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

//去掉字符串中的空格
-(NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

//判断字符串是否只包含字母-1
-(BOOL)containsOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

//判断字符串是否只包含字母-2（正则）
-(BOOL)isLetter {
    NSString *regEx = @"^[A-Za-z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [pred evaluateWithObject:self];
}

//判断字符串是否只包含数字-1
-(BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

//判断字符串是否只包含数字-2（正则）
-(BOOL)isNumbers {
    NSString *regEx = @"^-?\\d+.?\\d?";
    NSPredicate *pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [pred evaluateWithObject:self];
}

//判断字符串是否只包含数字和字母
-(BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

//由字母或数字组成 6-18位密码字符串（正则）
-(BOOL)isPassword {
    NSString * regex = @"^[A-Za-z0-9_]{6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

//判断数组中是否包含某个字符串
-(BOOL)isInThisarray:(NSArray*)array
{
    for(NSString *string in array) {
        if([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

//字符串转Data
-(NSData *)convertToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

//Data转字符转
+(NSString *)getStringFromData:(NSData *)data
{  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//获取系统版本号
+(NSString *)getMyApplicationVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    NSString *shortVersion = [info objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@", shortVersion];
    
    // NSString *bundleVersion = [info objectForKey:@"CFBundleVersion"];  测试字段号
    // NSString *name = [info  objectForKey:@"CFBundleDisplayName"];  app 名字
}
//字符串编码
-(NSString*)EncodingWithUTF8
{
    NSString *urlStrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlStrl;
}


//获取当前时间
+(NSString*)getCurrentTimeString
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    return currentDateString;
}


//通知字符串长度 （文字 2个字节 字母：1个字节）
// 统计ASCII和Unicode混合文本长度
-(NSUInteger) unicodeLengthOfString {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}


//计算属性字符文本占用的宽高
/**
 *  计算属性字符文本占用的宽高
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *  @param lineSpacing 行间距
 *  @return 占用的宽高
 */
-(CGSize)attrStrSizeWithFont:(UIFont *)font andmaxSize:(CGSize)maxSize lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *dict = @{NSFontAttributeName: font,
                           NSParagraphStyleAttributeName: paragraphStyle};
    CGSize sizeToFit = [self boundingRectWithSize:maxSize // 用于计算文本绘制时占据的矩形块
                                          options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:dict        // 文字的属性
                                          context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit;
}
//时间戳转时间
-(NSDate *)dateValueWithMillisecondsSince1970 {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleValue] / 1000];
}

/**
 * 获取时间 返回一个字典 第一个 time： 是12钟时时间 ，第二个是 ampm : AM代表上午 PM代表下午
 */
+ (NSDictionary *)getCurrentTime {
    NSCalendar *greCalender = [NSCalendar currentCalendar];
    //获取一个dateComponents并设置时间段
    NSDateComponents * dateComponentsAsTimeSet = [[NSDateComponents alloc] init];
    [dateComponentsAsTimeSet setDay:0];
    //获取当前历法下的当天的时间点
    /*
     这里还可以自己设年、月、日、时、分、秒，根据个人需求
     */
    NSDate * currentDate = [greCalender dateByAddingComponents:dateComponentsAsTimeSet
                                                        toDate:[NSDate date] options:0];
    NSLog(@"%@",currentDate);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [dateFormat setTimeZone:timeZone];
    dateFormat.AMSymbol = @"AM";
    dateFormat.PMSymbol = @"PM";
    [dateFormat setDateFormat:@"hh:ss aaa"];
    NSString *timeStr = [dateFormat stringFromDate:currentDate];
    NSLog(@"time : %@",[timeStr substringToIndex:5]);
    NSLog(@"am/pm :%@",[timeStr substringFromIndex:6]);
    
    //    self.checkTimeLab.text = [timeStr substringToIndex:5];
    //    self.ampmSymble.text = [timeStr substringFromIndex:6];
    return @{@"time":[timeStr substringToIndex:5],
             @"ampm":[timeStr substringFromIndex:6]
             };
}

@end
