//
//  AppDelegate.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//
//

#import "AppDelegate.h"
#import "INFHomeViewController.h"

/** 定义一个全局外部变量，标注当前用户的状态，此外，每次状态变化把该变量持久化到本地
 *  1,用户未登录
 *  2,用登录成功，但是未注册人脸
 *  3,用户登陆成功，且注册过人脸，可以刷脸登录了
 */
NSInteger userStatus;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    INFHomeViewController *HomeVC = [storyboard instantiateViewControllerWithIdentifier:@"INFHomeViewController"];
    
    self.window.rootViewController = HomeVC;
    [self checkUserStatus];
    return YES;
}


- (void)checkUserStatus {
    NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
    NSInteger tempStatus = [defaults integerForKey:@"userStatus"];
    if (tempStatus) {
        NSLog(@"if当前用户状态为：%ld",tempStatus);
        userStatus = [defaults integerForKey:@"userStatus"];
    }else{
        [defaults setInteger:1 forKey:@"userStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize]; 
        userStatus = [defaults integerForKey:@"userStatus"];
         NSLog(@"else当前用户状态为：%ld",userStatus);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
