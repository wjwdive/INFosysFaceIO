//
//  Config.h
//  AccessControlSystem
//
//  Created by Infosys Ltd. on 2017/11/3.
//  Copyright © 2017年 infosys. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define kPushPhotoBrowserNotifitationName @"PushPhotoBrowser"
#define kPresentVideoPlayerNotifitationName @"playCallBackVideo"

#define APPICONIMAGE [UIImage imageNamed:[[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]]

#define kMargin 10

/**
 配色相关的宏定义
 */
#define ColorWithRGB(r,g,b)             [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ColorWithRGBA(r,g,b,a)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ColorFromRGB(rgbValue)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorFromRGBA(rgbValue, a)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define Main_Color [UIColor colorWithRed:(3)/255.0 green:(160)/255.0 blue:(235)/255.0 alpha:1.0]
#define Main2_Color [UIColor colorWithRed:(135)/255.0 green:(202)/255.0 blue:(231)/255.0 alpha:1.0]
#define VTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define Text_Color [UIColor colorWithRed:(51)/255.0 green:(71)/255.0 blue:(113)/255.0 alpha:1.0]
#define BackGround_Color [UIColor colorWithRed:(235)/255.0 green:(235)/255.0 blue:(241)/255.0 alpha:1.0]

#define Default_Person_Image [UIImage imageNamed:@"default_parents"]
#define Default_General_Image [UIImage imageNamed:@"default_general"]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define NotificationCenter [NSNotificationCenter defaultCenter]
#define UserDefault [NSUserDefaults standardUserDefaults]

#define EnglishFontWithSize(s)          FontWithNameSize(@"MicrosoftYaHei Regular", s)

#define FontWithNameSize(name, s)       [UIFont fontWithName:name size:s]

//设备型号
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )




//弱引用对象
#define WeakObj(obj) __weak typeof(obj) obj##Weak = obj;

//以及各种第三方服务商的appId或者App key
//nslog 详细宏
#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

//这两个log 解决log太长无法打印的问题
#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#define SLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#endif /* Config_h */
