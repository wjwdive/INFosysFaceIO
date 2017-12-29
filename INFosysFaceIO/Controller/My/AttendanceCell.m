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
    _stateLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_right).offset(15);
        make.height.equalTo(self);
    }];
}

- (void)setModel:(AttendanceModel *)model {
    _model = model;
    
    _timeLabel.text = model.time;
    _stateLabel.text = model.state;
}

@end
