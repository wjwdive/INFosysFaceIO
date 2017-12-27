//
//  MyViewLitsCell.h
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/27.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewLitsCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
