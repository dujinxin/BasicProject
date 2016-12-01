//
//  RecordViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "RecordListViewController.h"
#import "DJXHorizontalView.h"

#import "CommentRecordListViewController.h"
#import "UserRecordListViewController.h"
#import "GuiderRecordListViewController.h"


@interface RecordListViewController ()<DJXHorizontalViewDelegate,DJXHorizontalViewDataSource>{
    UISegmentedControl              *  _segmentControl;
    UserRecordListViewController    *  _vc1;
    CommentRecordListViewController *  _vc2;
    
    DJXHorizontalView               *  _horizontalView;
}

@end

@implementation RecordListViewController

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
    _segmentControl = ({
        UISegmentedControl * segment = [[UISegmentedControl alloc ] initWithItems:@[@"我发布的",@"我评论的"]];
        segment.frame = CGRectMake(0, 0, 160, 30);
        segment.tintColor = [UIColor blackColor];
        NSDictionary * selectedAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14],NSForegroundColorAttributeName:JXFfffffColor,NSBackgroundColorAttributeName:[UIColor blackColor]};
        NSDictionary * unselectedAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14],NSForegroundColorAttributeName:JX333333Color,NSBackgroundColorAttributeName:JXClearColor};
        [segment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        [segment setTitleTextAttributes:unselectedAttributes forState:UIControlStateNormal];
        
        [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        [segment setSelectedSegmentIndex:0];
        segment;
    });
    self.navigationItem.titleView = _segmentControl;
    
    _vc1 = [UserRecordListViewController new];
    _vc1.view.backgroundColor = [UIColor greenColor];
    _vc1.recordType = RecordDistributionType;
    
    _vc2 = [CommentRecordListViewController new];
    _vc2.view.backgroundColor = [UIColor yellowColor];
    
    NSArray * subVCs = @[_vc1,_vc2];
    _horizontalView = [[DJXHorizontalView  alloc ]initWithFrame:CGRectMake(0,kNavStatusHeight, kScreenWidth, kScreenHeight -kNavStatusHeight) style:DJXHorizontalViewDefault containers:subVCs parentViewController:self];
    _horizontalView.delegate = self;
    _horizontalView.dataSource = self;
    [self.view addSubview:_horizontalView];
    
    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"Edit") style:kDefault];
}

- (void)horizontalView:(DJXHorizontalView *)horizontalView didScrollToItemAtIndexPath:(NSIndexPath *)indexPath{
    [_segmentControl setSelectedSegmentIndex:indexPath.item];
    switch (indexPath.item) {
        case 0:
        {
            if (_vc1.dataArray.count) {
                if (_vc1.isEditStyle){
                    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"done") style:kDefault];
                }else{
                    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"Edit") style:kDefault];
                }
            }else{
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
            break;
        case 1:
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
    }
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
- (void)segmentValueChange:(UISegmentedControl *)segment{
//    CGPoint offsetPoint = CGPointMake(segment.selectedSegmentIndex * kScreenWidth, 0);
//    NSLog(@"%zd",offsetPoint);
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:segment.selectedSegmentIndex inSection:0];
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            if (_vc1.dataArray.count) {
                if (_vc1.isEditStyle){
                    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"done") style:kDefault];
                }else{
                    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"Edit") style:kDefault];
                }
            }else{
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
            break;
        case 1:
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
    }
    
    [_horizontalView.containerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

}
- (void)edit:(UIButton *)button{
    
    if (_vc1.recordType == RecordDistributionType) {
        _vc1.isEditStyle = !_vc1.isEditStyle;
        [_vc1 reloadData];
    }
    if (_vc1.isEditStyle){
        self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"done") style:kDefault];
    }else{
        self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(edit:) title:JXLocalizedString(@"Edit") style:kDefault];
    }
}
@end
