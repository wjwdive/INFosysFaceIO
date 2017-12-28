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

//弱引用对象
#define WeakObj(obj) __weak typeof(obj) obj##Weak = obj;

//以及各种第三方服务商的appId或者App key


#endif /* Config_h */
