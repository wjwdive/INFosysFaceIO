//
//  AttendanceCell.h
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/28.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttendanceModel;

@interface AttendanceCell : UITableViewCell

@property (nonatomic, strong) AttendanceModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
