//
//  AttendanceCell.m
//  INFosysFaceIO
//
//  Created by Infosys Ltd. on 2017/12/28.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "AttendanceCell.h"
#import "AttendanceModel.h"

@interface AttendanceCell () {
    UILabel     *_timeLabel;
    UILabel     *_stateLabel;
    UIImageView *_imageView;
}
@end
@implementation AttendanceCell

+ (CGFloat)cellHeight {
    return 55;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"AttendanceCell";
    AttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell configUI];
    }
    return cell;
}

- (void)configUI {
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#010101"];
    _timeLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.height.equalTo(self);
    }];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.textColor = [UIColor colorWithHexString:@"#7e7e7e"];
    _stateLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.height.equalTo(self);
    }];
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(16);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel);
        make.top.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setModel:(AttendanceModel *)model {
    _model = model;
    
    _timeLabel.text = model.time;
    _stateLabel.text = model.state;
    
    if ([model.state isEqualToString:@"进入"]) {
        _imageView.image = [UIImage imageNamed:@"ic_door_access"];
    }else {
        _imageView.image = [UIImage imageNamed:@"ic_door_leave"];
    }
}

@end
