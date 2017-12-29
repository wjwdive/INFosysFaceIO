//
//  BaseNavigationController.m
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/29.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+ (void)initialize{
    [self setupNavTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

/**
 设置NavigationBar标题颜色，字体大小
 */
+ (void)setupNavTheme {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor = [UIColor colorWithHexString:@"#017ec5"];
    navBar.tintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    [[UIView appearance] setExclusiveTouch:YES];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    [UIFont systemFontOfSize:17], NSFontAttributeName,
                                    nil]];
    [navBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIImage * backImage = [UIImage imageNamed:@"backIcon"];
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:backImage forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    viewController.navigationItem.leftBarButtonItem = item;
    
    [self setNavigationBarHidden:NO animated:YES];
    
    [super pushViewController:viewController animated:animated];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
