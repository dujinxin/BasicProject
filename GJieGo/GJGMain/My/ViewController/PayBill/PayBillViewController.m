//
//  PayBillViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "PayBillViewController.h"
#import "CouponDetailViewController.h"
#import "PayCouponCell.h"

static CGFloat PayBillViewHeight = 176;

@interface PayBillViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    UIView         * _headView;
    UITableView    * _tableView;
    
    UIButton       * _footView;
    NSInteger        _selectRow;
}

@end

@implementation PayBillViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    _selectRow = -1;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"买单";
    
    [self setHeadView];
    [self layoutSubView];
}
#pragma mark - subView init

- (void)setHeadView{
    _headView = [[UIView alloc ]init ];
    _headView.backgroundColor =JXFfffffColor;
    _headView.frame=CGRectMake(0, -PayBillViewHeight-89 -10, kScreenWidth, PayBillViewHeight +89);
    

    _footView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_footView setTitle:@"确认支付" forState:UIControlStateNormal];
    [_footView setTitleColor:JX999999Color forState:UIControlStateNormal];
    //[_footView setBackgroundColor:JXMainColor];
    [_footView setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
    _footView.titleLabel.font = JXFontForNormal(16);
    _footView.layer.cornerRadius = 5.f;
    [_footView addTarget:self action:@selector(PayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footView];
    
    [_tableView removeFromSuperview];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    [_tableView addSubview:_headView];
    
    _tableView.contentInset = UIEdgeInsetsMake(PayBillViewHeight +89 +10, 0, 0, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIImageView * bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(0, -PayBillViewHeight-89, kScreenWidth, PayBillViewHeight +89);
    [_tableView addSubview:bgImageView];
    
    UIImageView * _userImageView=[[UIImageView alloc]init];
    _userImageView.image=[UIImage imageNamed:@"portrait_default"];
    _userImageView.frame=CGRectMake((kScreenWidth-75)/2, 19, 75, 75);
    _userImageView.layer.cornerRadius = 75.0/2;
    _userImageView.clipsToBounds = YES;
    [_headView addSubview:_userImageView];
    
    
    //
    UILabel * _infoLabel=[[UILabel alloc] init];
    _infoLabel.text =@"应付金额";
    _infoLabel.textColor = JX333333Color;
    _infoLabel.font = JXFontForNormal(12);
    _infoLabel.textAlignment=NSTextAlignmentCenter;
    _infoLabel.frame=CGRectMake(0, CGRectGetMaxY(_userImageView.frame)+7, CGRectGetWidth(_headView.frame), 12);
    [_headView addSubview:_infoLabel];
    
    UILabel * _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"850.5";
    _numLabel.textColor = JXff5252Color;
    _numLabel.font = JXFontForNormal(25);
    _numLabel.textAlignment=NSTextAlignmentCenter;
    _numLabel.frame = CGRectMake(0, CGRectGetMaxY(_infoLabel.frame)+14, CGRectGetWidth(_headView.frame), 25);
    [_headView addSubview:_numLabel];
    
    NSArray * speedEntryData = @[@"    订单金额",@"    节省金额"];
    //[_speedEntryView setFrame:CGRectMake(0, dmHeight, kScreenWidth, speedEntryHeight)];
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_numLabel.frame) +24, kScreenWidth -40, 89)];
    bgView.backgroundColor = JX999999Color;
    [_headView addSubview:bgView];
    for (int i = 0; i < speedEntryData.count ; i ++)
    {
        UILabel * label = [[UILabel alloc ] initWithFrame:CGRectMake(0,0.5+ 44.5 *(i%speedEntryData.count), kScreenWidth-40, 44)];
        label.text = speedEntryData[i];
        label.tag = 10 +i;
        label.textColor = JX999999Color;
        label.font = JXFontForNormal(12);
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:label];
    }
}
- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    [_footView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    headerView.backgroundColor = JXff5252Color;
    
    UILabel * textView = [[UILabel alloc ]initWithFrame:CGRectMake(2, 0, kScreenWidth, 44)];
    textView.text = @"  可用优惠券";
    textView.textColor = JX333333Color;
    textView.font = JXFontForNormal(13);
    textView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:textView];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    PayCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PayCouponCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.type = MyCouponUsableType;
    }
    [cell setCouponContent:nil indexPath:indexPath selectedRow:_selectRow selectedBlock:^(NSInteger selectedRow){
        _selectRow = selectedRow;
        if (selectedRow >=0) {
            NSLog(@"selected :%ld",indexPath.row);
        }else{
            NSLog(@"cancel :%ld",indexPath.row);
        }
        [_tableView reloadData];
    }];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CouponDetailViewController * dvc = [[CouponDetailViewController alloc ]init ];
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userFansList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
    
}
- (void)loadMore:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userFansList:self.urlStr param:@{@"page":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
    }];
}
#pragma mark - click events
- (void)PayButtonClick:(UIButton *)button{
    if (kIOS_VERSION >= 8) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * pictureAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //支付宝
            
        }];
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //微信
            
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:pictureAction];
        [alertVC addAction:cameraAction];
        [alertVC addAction:cancelAction];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        //        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        //        UIFont *font = [UIFont systemFontOfSize:15];
        //        [appearanceLabel setAppearanceFont:font];
        [pictureAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cameraAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"支付宝支付",@"微信支付", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tintColor = JXTextColor;//不起作用
        [actionSheet showInView:self.view];
        //注意整个工程的view 都会被修改
        // [[UIView appearance] setTintColor:JXTextColor];
    }
}

#pragma mark –-------------------------UIActionSheetDelegate
// iOS8.0之前可用
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:JXTextColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //支付宝
        
    }
    if (buttonIndex == 1) {
        //微信
        
    }
    
}

@end
