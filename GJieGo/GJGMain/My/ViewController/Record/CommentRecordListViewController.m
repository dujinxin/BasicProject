//
//  CommentRecordListViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/5/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "CommentRecordListViewController.h"
#import "DJXHorizontalView.h"
#import "TopbarView.h"
#import "UserRecordListViewController.h"
#import "GuiderRecordListViewController.h"


@interface CommentRecordListViewController ()<DJXHorizontalViewDelegate,DJXHorizontalViewDataSource,TopBarViewDelegate>{
    TopbarView                     *  _topBarView;
    UserRecordListViewController   *  _vc1;
    GuiderRecordListViewController *  _vc2;
    
    DJXHorizontalView              *  _horizontalView;
}

@end

@implementation CommentRecordListViewController

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
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;
    
    TopBarAttribute * attribute = [[TopBarAttribute alloc ]init ];
    attribute.normalColor = JX999999Color;
    attribute.highlightedColor = JX333333Color;
    attribute.separatorColor = JXSeparatorColor;
    
    _topBarView = [[TopbarView alloc ]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) titles:@[@"导购",@"爱晒"] attribute:attribute];
    _topBarView.delegate = self;
    _topBarView.backgroundColor = JXFfffffColor;
    [_topBarView setBottomLineEnabled:YES];
    [_topBarView setBottomLineColor:JXMainColor];
    [_topBarView setBottomLineSize:CGSizeMake(50, 1)];
    [self.view addSubview:_topBarView];

    
    _vc1 = [UserRecordListViewController new];
    _vc1.recordType = RecordCommentionType;
    _vc1.view.backgroundColor = [UIColor greenColor];
    
    
    _vc2 = [GuiderRecordListViewController new];
    _vc2.view.backgroundColor = [UIColor yellowColor];
    
    NSArray * subVCs = @[_vc2,_vc1];
    _horizontalView = [[DJXHorizontalView  alloc ]initWithFrame:CGRectMake(0,44, kScreenWidth, kScreenHeight -kNavStatusHeight -44) style:DJXHorizontalViewDefault containers:subVCs parentViewController:self];
    _horizontalView.delegate = self;
    _horizontalView.dataSource = self;
    [self.view addSubview:_horizontalView];
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
//- (void)setSubViewControllerType:(SystemMsgCellType)type{
//    switch (self.topBarView.selectIndex) {
//        case 0:
//        {
//            vc1.type = type;
//            [vc1 reloadData];
//        }
//            break;
//        case 1:
//        {
//            vc2.type = type;
//            [vc2 reloadData];
//        }
//            break;
//        case 2:
//        {
//            vc3.type = type;
//            [vc3 reloadData];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

#pragma mark - Click events
- (void)back:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
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


@end
