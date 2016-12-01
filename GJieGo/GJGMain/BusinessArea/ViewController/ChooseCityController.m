//
//  ChooseCityController.m
//  GJieGo
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ChooseCityController.h"
#import "OpenedCityModel.h"

@interface ChooseCityController ()<UITableViewDataSource, UITableViewDelegate>{
    UIView *statusBackView;
}
@property (nonatomic, strong)BaseTableView *chooseCityTableView;
@end

@implementation ChooseCityController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    [self cancleChooseCityView];
}

- (void)ClickLeftButtonAction:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancleChooseCityView{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"popover_btn_close"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(ClickLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(15, 25, 30, 30);
    [self.view addSubview:leftBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = GJGGRAYCOLOR;
    [self.view addSubview:lineView];
    
    UILabel *naviNameLabel = [UILabel labelWithFrame:CGRectZero text:@"选择城市" tinkColor:GJGBLACKCOLOR fontSize:17.0f];
    [self.view addSubview:naviNameLabel];
    [naviNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(lineView).offset(-12);
    }];
    
    self.chooseCityTableView = [[BaseTableView alloc] init];
    self.chooseCityTableView.dataSource = self;
    self.chooseCityTableView.delegate = self;
    self.chooseCityTableView.tableFooterView = [[UIView alloc] init];
    [self.chooseCityTableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"ChooseTableViewCell"];
    [self.chooseCityTableView setSeparatorColor:GJGGRAYCOLOR];
    [self.view addSubview:self.chooseCityTableView];
    [self.chooseCityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(lineView.bottom);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.openedCityArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTableViewCell"];
    GJGOpenedCity *city = self.openedCityArray[indexPath.row];
    cell.textLabel.text = city.CityName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GJGOpenedCity *city = self.openedCityArray[indexPath.row];
    [self.delegate chooseCityName:city.CityName cityId:[NSString stringWithFormat:@"%ld", city.CityID]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
