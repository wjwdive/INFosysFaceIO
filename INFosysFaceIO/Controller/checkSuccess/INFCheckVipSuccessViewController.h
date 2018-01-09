//
//  INFCheckVipSuccessViewController.h
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2018/1/8.
//  Copyright © 2018年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INFCheckVipSuccessViewController : UIViewController
@property (nonatomic, strong) NSString *usrName;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *time;
//Y 代表是 N代表不是
@property (nonatomic, strong) NSString *isVip;
@end
