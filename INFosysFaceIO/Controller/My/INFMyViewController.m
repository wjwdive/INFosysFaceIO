//
//  INFMyViewController.m
//  INFosysFaceIO
//
//  Created by jiangwei.wang on 2017/12/25.
//  Copyright © 2017年 jiangwei.wang. All rights reserved.
//

#import "INFMyViewController.h"
#import "AttendanceViewController.h"
#import "MyViewLitsCell.h"
#import "INFRegisterViewController.h"
#import "INFFaceLoginViewController.h"
#import "INFFaceLoginVC.h"

@interface INFMyViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *_lists;
    UITableView *_tableView;
    UILabel *_count1;
    UILabel *_count2;
}

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, strong) UIImageView *userPhotoIMG;
@property (nonatomic, strong) UILabel *acountLab;
@property (nonatomic, strong) UIImageView *vipIcon;
@end

@implementation INFMyViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    [self configTopView];
    [self configBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserAction:) name:@"changeUserNotification" object:nil];
    
}

- (void)changeUserAction:(NSNotification *)notification {
    NSLog(@"接受消息：%@",notification);
    SLog(@"消息内容：userInfo: %@, name :%@,object : %@, ",notification.userInfo,notification.name, notification.object )
    _userNameLab.text  = [notification.userInfo objectForKey:@"loginUserName"];
    NSString *userPhotoStr = [notification.userInfo objectForKey:@"loginUserPhoto"];
    NSData *imgData = [[NSData alloc] initWithBase64EncodedString:userPhotoStr options:0];
    UIImage *userPhotoImg = [UIImage imageWithData:imgData];
    _userPhotoIMG.image = userPhotoImg;
    NSString *isVipStr = [notification.userInfo objectForKey:@"isVip"];
    if (![isVipStr isEqualToString:@"Y"]) {
        _vipIcon.hidden = YES;
    }else {
        _vipIcon.hidden = NO;
    }
    NSString *empidStr = [notification.userInfo objectForKey:@"loginEmpid"];
    _acountLab.text = empidStr;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:@"changeUserNotification"];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeUserNotification" object:nil];
}
- (void)configTopView {
    NSUserDefaults *def  = [NSUserDefaults standardUserDefaults];
    NSString *loginUserImgStr = [def objectForKey:@"loginUserPhoto"];
    NSString *loginUserName = [def objectForKey:@"loginUserName"];
    NSString *loginEmpid = [def objectForKey:@"loginEmpid"];
    NSString *isVip = [def objectForKey:@"isVip"];
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    self.bgImageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [self.view addSubview:self.bgImageView];
    _userPhotoIMG = [[UIImageView alloc] init];
    _userPhotoIMG.layer.masksToBounds = YES;
    _userPhotoIMG.layer.cornerRadius = 35.0;
    if (loginUserImgStr.length != 0) {
        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:loginUserImgStr options:0];
        UIImage *userPhotImg = [UIImage imageWithData:imgData];
        _userPhotoIMG.image = userPhotImg;
    }else {
        _userPhotoIMG.image = [UIImage imageNamed:@"photo"];
    }
    
    [self.view addSubview:_userPhotoIMG];
    [_userPhotoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.top.mas_equalTo(50);
        make.height.width.mas_equalTo(70);
    }];
    
    _userNameLab = [[UILabel alloc] init];
    if (loginUserName.length != 0) {
        _userNameLab.text = loginUserName;
    }else{
        _userNameLab.text = @"lvy_wang06";
    }
    _userNameLab.textColor = [UIColor whiteColor];
    [self.view addSubview:_userNameLab];
    [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(130);
        make.top.mas_equalTo(55);
    }];
    
    
    
    _vipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip"]];
    [self.view addSubview:_vipIcon];
    [_vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLab.mas_right).offset(5);
        make.centerY.equalTo(_userNameLab);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(20);
    }];
    if ([isVip isEqualToString:@"N"]) {
        _vipIcon.hidden = YES;
    }else {
        _vipIcon.hidden = YES;
    }
    
    _acountLab = [[UILabel alloc] init];
    if (loginEmpid.length != 0) {
        _acountLab.text = loginEmpid;
    }else{
        _acountLab.text = @"429536";
    }
    _acountLab.textColor = [UIColor whiteColor];
    _acountLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_acountLab];
    [_acountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLab.mas_bottom).offset(15);
        make.left.equalTo(_userNameLab);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(54);
        make.right.mas_equalTo(-15);
        make.height.width.mas_equalTo(28);
    }];
}

- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backToHomeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"跳会Home");
    }];
}

- (void)configBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kScreenW, kScreenH - 140)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.bgImageView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(140);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = [UIColor colorWithHexString:@"#717171"];
    [bottomView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(76);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(bottomView);
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithHexString:@"#717171"];
    [bottomView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(17);
        make.width.mas_equalTo(0.5);
        make.bottom.equalTo(hLine.mas_top).offset(-17);
        make.centerX.equalTo(bottomView);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"attendence/month";
    label1.textColor = [UIColor colorWithHexString:@"#717171"];
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.equalTo(vLine.mas_left).offset(-50);
    }];
    
    UILabel *count1 = [[UILabel alloc] init];
    count1.text = @"20";
    count1.textColor = [UIColor colorWithHexString:@"#1d84d1"];
    count1.font = [UIFont boldSystemFontOfSize:20];
    [bottomView addSubview:count1];
    _count1 = count1;
    [count1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom);
        make.bottom.equalTo(hLine.mas_top);
        make.centerX.equalTo(label1);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"absence/month ";
    label2.textColor = [UIColor colorWithHexString:@"#717171"];
    label2.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.equalTo(vLine.mas_right).offset(50);
    }];
    
    UILabel *count2 = [[UILabel alloc] init];
    count2.text = @"2";
    count2.textColor = [UIColor colorWithHexString:@"#1d84d1"];
    count2.font = [UIFont boldSystemFontOfSize:20];
    [bottomView addSubview:count2];
    _count2 = count2;
    [count2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom);
        make.bottom.equalTo(hLine.mas_top);
        make.centerX.equalTo(label2);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 86, kScreenW, kScreenH - 250) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [bottomView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    self.bgImageView.userInteractionEnabled = YES;
    bottomView.userInteractionEnabled = YES;
    _tableView.userInteractionEnabled = YES;
}

- (void)loadData {
    _lists = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *titles = @[ @"Face Register", @"Face Login", @"Face Check",@"Attendence Records"];
    NSArray *images = @[  @"identity", @"index", @"identity", @"AttendanceRecord"];
    [_lists setObject:titles forKey:@"titles"];
    [_lists setObject:images forKey:@"images"];
}

#pragma mark TableViewDelegate, TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lists[@"titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyViewLitsCell *cell = [MyViewLitsCell cellWithTableView:tableView];
    cell.image = [_lists[@"images"] objectAtIndex:indexPath.row];
    cell.title = [_lists[@"titles"] objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MyViewLitsCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[INFRegisterViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[INFFaceLoginVC alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        case 3:
            [self.navigationController pushViewController:[[AttendanceViewController alloc] init] animated:YES];
//            [self presentViewController:[[AttendanceViewController alloc] init] animated:YES completion:nil];
            break;
        default:
            break;
    }
}

@end
