//
//  CouponListViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponDetailViewController.h"
#import "PayCouponCell.h"
#import "CollectionDropView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CouponListViewController ()<CollectionDropViewDelegate,CollectionDropViewDataSource>{
    CollectionDropView   *  _dropListView;
    NSArray              *  _sortArray;
    NSMutableArray       *  _categoryAarry;
    NSString             *  _categoryType;
}

@end

@implementation CouponListViewController

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
    
    self.urlStr = kApiUserFansList;
//    [self showLoadView];
    [[UserRequest shareManager] userCouponList:kApiUserCouponList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
//        [self hideLoadView];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        if (107 *kPercent *_dataArray.count >(kScreenHeight -64)){
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [self loadMore:self.page];
            }];
            _tableView.mj_footer = footer;
        }
    } failure:^(id object,NSString *msg) {
//        [self hideLoadView];
        [self showJXNoticeMessage:msg];
    }];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"我的优惠特权";
    
    _categoryAarry = [NSMutableArray arrayWithArray:@[@"可使用",@"已使用",@"已过期"]];
    _sortArray = @[@"最近领取",@"离我最近"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh:self.page];
    }];
    
    _dropListView = [[CollectionDropView alloc]initWithFrame:CGRectMake(0, kNavStatusHeight, kScreenWidth, 44) delegate:self buttonTitles:@[@"可使用",@"离我最近"]];
    _dropListView.delegate = self;
    _dropListView.dataSource = self;
    [self.view addSubview:_dropListView];
    
    [self layoutSubView];
}
#pragma mark - subView init

- (void)layoutSubView{
    [_tableView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dropListView.bottom);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}
#pragma mark - JXDropListViewDelegate
-(void)dropListView:(CollectionDropView *)dropListView didSelectTab:(UIButton *)button index:(NSInteger)index{
    if ([button.superview viewWithTag:dropListView.selectTab +kTopBarItemTag] && dropListView.selectTab != -1) {
        UIButton * btn =(UIButton *)[button.superview viewWithTag:dropListView.selectTab +kTopBarItemTag];
        [UIView animateWithDuration:0.3 animations:^{
            btn.imageView.transform = CGAffineTransformRotate(btn.imageView.transform, DEGREES_TO_RADIANS(180));
        }];
    }
    if (dropListView.selectTab != index){
        UIButton * btn =(UIButton *)[button.superview viewWithTag:index +kTopBarItemTag];
        [UIView animateWithDuration:0.3 animations:^{
            btn.imageView.transform = CGAffineTransformRotate(btn.imageView.transform, DEGREES_TO_RADIANS(180));
        }];
    }
}
-(void)dropListView:(CollectionDropView *)dropListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (dropListView.selectTab == 0) {
//        CategoryEntity * entity = _categoryAarry[indexPath.row];
//        _categoryType = entity.DicID;
        NSLog(@"点击：%@",_categoryAarry[indexPath.row]);
    }else if (dropListView.selectTab == 1){
        //_sortType = (SortType)(indexPath.row +1);
        NSLog(@"点击：%@",_sortArray[indexPath.row]);
    }
    //[self refresh:self.page];
    
    for (UIView * view in dropListView.topBarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            [btn setSelected:NO];
            if (btn.tag == kTopBarItemTag && dropListView.selectTab ==0) {
                [btn setTitle:_categoryAarry[indexPath.row] forState:UIControlStateNormal];
            }else if (btn.tag == kTopBarItemTag +1 && dropListView.selectTab ==1){
                [btn setTitle:_sortArray[indexPath.row] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - JXDropListViewDataSource
- (DropListStyle)dropListView:(CollectionDropView *)dropListView styleForItemIndex:(NSInteger)index{
    return DropListTable;
}
- (NSArray<UIView *> *)topItemsForDropListView:(CollectionDropView *)dropListView{
    NSMutableArray * array = [NSMutableArray array];
    CGFloat width = kScreenWidth/dropListView.dataArray.count;
    CGFloat height = 44;
    for (int i = 0; i< dropListView.dataArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = kTopBarItemTag +i;
//        [btn addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
        [btn setTitle:dropListView.dataArray[i] forState:UIControlStateNormal];

        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGFloat titleWidth = btn.currentTitle.length * 15 +2.5;
        CGFloat imageWidth = 15 +2.5;
        [btn setImage:JXImageNamed(@"search_Search_cbb") forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        if (i == 0) {
            btn.frame = CGRectMake(0, 0,15*2 +titleWidth +imageWidth, height);
        }else{
            btn.frame = CGRectMake(kScreenWidth -(20*2 +titleWidth +imageWidth), 0,20*2 +titleWidth +imageWidth, height);
        }
        [array addObject:btn];
    }
    return array;
}
-(NSInteger)dropListView:(CollectionDropView *)dropListView numberOfRowsInFirstView:(UIView *)view inSection:(NSInteger)section{
    if (dropListView.selectTab == 0) {
        return _categoryAarry.count;
    }else if (dropListView.selectTab == 1){
        return _sortArray.count;
    }
    return 0;
}

-(NSString *)dropListView:(CollectionDropView *)dropListView contentForRow:(NSInteger)row section:(NSInteger)section inView:(UIView *)view{
    if (dropListView.selectTab == 0) {
        return _categoryAarry[row];
    }else if (dropListView.selectTab == 1){
        return _sortArray[row];
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107*kPercent;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView FooterForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    PayCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PayCouponCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.type = MyCouponListType;
    }
    CouponEntity * entity = _dataArray[indexPath.row];
    [cell setCouponContent:entity indexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CouponEntity * entity = _dataArray[indexPath.row];
    CouponDetailViewController * dvc = [[CouponDetailViewController alloc ]init ];
    dvc.cid = entity.CouponID;
    [self.navigationController pushViewController:dvc animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;//设置删除风格
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[_dataArray count]) {
            [_dataArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}
#pragma mark - RefreshAndLoadMore
- (void)refresh:(NSInteger)page{
    [super refresh:page];
    [[UserRequest shareManager] userCouponList:kApiUserCouponList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
        [self showJXNoticeMessage:msg];
    }];
    
}
- (void)loadMore:(NSInteger)page{
    [super loadMore:page];
    [[UserRequest shareManager] userCouponList:kApiUserCouponList param:@{@"Cp":@(self.page)} success:^(id object,NSString *msg) {
        [self endRefresh];
        [_dataArray addObjectsFromArray:(NSArray *)object];
        [_tableView reloadData];
        
    } failure:^(id object,NSString *msg) {
        [self endRefresh];
        [self showJXNoticeMessage:msg];
    }];
}
@end
