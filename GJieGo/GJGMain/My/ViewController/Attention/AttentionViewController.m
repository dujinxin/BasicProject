//
//  AttentionViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//
//  系统名称：AttentionViewController
//  功能描述：关注列表
//  修改记录：(仅记录功能修改)

#import "AttentionViewController.h"
#import "GUListViewController.h"
#import "OrderGuiderView.h"
#import "ChatViewController.h"
#import "TopbarView.h"
#import "DJXHorizontalView.h"

@interface AttentionViewController ()<TopBarViewDelegate,DJXHorizontalViewDelegate,DJXHorizontalViewDataSource>{
    TopbarView  *   _topBarView;
    DJXHorizontalView * _horizontalView;
}

@end

@implementation AttentionViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
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
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"关注";
    
    [self addTopTabView];
    
    GUListViewController * _vc1 = [GUListViewController new];
    _vc1.type = Guider;
    _vc1.view.backgroundColor = [UIColor greenColor];
    
    
    GUListViewController * _vc2 = [GUListViewController new];
    _vc2.type = User;
    _vc2.view.backgroundColor = [UIColor yellowColor];
    
    NSArray * subVCs = @[_vc1,_vc2];
    _horizontalView = [[DJXHorizontalView  alloc ]initWithFrame:CGRectMake(0,kNavStatusHeight+44, kScreenWidth, kScreenHeight -kNavStatusHeight -44) style:DJXHorizontalViewDefault containers:subVCs parentViewController:self];
    _horizontalView.delegate = self;
    _horizontalView.dataSource = self;
    [self.view addSubview:_horizontalView];
}
-(void)addTopTabView{
    
    TopBarAttribute * attribute = [[TopBarAttribute alloc ]init ];
    attribute.normalColor = JX999999Color;
    attribute.highlightedColor = JX333333Color;
    attribute.separatorColor = JXSeparatorColor;
    
    _topBarView = [[TopbarView alloc ]initWithFrame:CGRectMake(0, kNavStatusHeight, kScreenWidth, 44) titles:@[@"导购",@"用户"] attribute:attribute];
    _topBarView.delegate = self;
    _topBarView.backgroundColor = JXFfffffColor;
    [_topBarView setBottomLineEnabled:YES];
    [_topBarView setBottomLineColor:JXMainColor];
    [_topBarView setBottomLineSize:CGSizeMake(50, 1)];
    [self.view addSubview:_topBarView];
    
}

#pragma mark - TopBarViewDelegate
- (void)topBarView:(TopbarView *)topView clickItemIndex:(NSInteger)index{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
    }
    
    [_horizontalView.containerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
- (void)horizontalView:(DJXHorizontalView *)horizontalView didScrollToItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_topBarView.bottomLine) {
        [_topBarView.bottomLine removeFromSuperview];
    }
    _topBarView.selectIndex = indexPath.item;
    [_topBarView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)obj;
            if (button.tag == _topBarView.selectIndex) {
                button.selected = !button.selected;
                [button addSubview:_topBarView.bottomLine];
            }else{
                button.selected = NO;
            }
        }
    }];
}

@end
