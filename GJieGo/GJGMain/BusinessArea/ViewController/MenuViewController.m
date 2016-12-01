//
//  MenuViewController.m
//  GJieGo
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 菜单 ---

#import "MenuViewController.h"
#import "BusinessClassMoreCell.h"
#import "AvatarBrowser.h"
#import "MenuModel.h"

@interface MenuViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    UIView *statusBackView;
    NSMutableArray *sourceArray;
    UIView *backAlphaView;
    
    MenuItem *_item;
    
    NSInteger page;
    NSInteger once;
}
@property (nonatomic, strong)UICollectionView *menuCollectionView;

@end

@implementation MenuViewController
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

- (void)viewDidAppear:(BOOL)animated{
    if(once == 0)  [self.menuCollectionView.mj_header beginRefreshing];
    once ++;
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"ShopId":self.shopId, @"cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(self.url) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                sourceArray == nil ? (sourceArray = [NSMutableArray array]) : ([sourceArray removeAllObjects]);
                [_menuCollectionView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 20) {
                        [_menuCollectionView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_menuCollectionView.mj_footer endRefreshing];
                    }
                }else{
                    [_menuCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }

            if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                MenuModel *model = [[MenuModel alloc] initWithDic:responseobject];
                if (model.Data.count > 0) {
                    for (int i = 0; i < model.Data.count; i++) {
                        [sourceArray addObject:model.Data[i]];
                    }
                }else{
                }
                
            }
            [_menuCollectionView reloadData];
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - Update data

- (void)updateData {
        page = 1;
    
        [self loadData];
//        [_menuCollectionView.mj_header endRefreshing];
}

- (void)updateMoreData {
        page++;
        [self loadData];
//        [_menuCollectionView.mj_footer endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    
    once = 0;
    page = 1;
    sourceArray = [NSMutableArray array];
    
    backAlphaView = [[UIView alloc] initWithFrame:self.view.frame];
    backAlphaView.backgroundColor = [UIColor redColor];
    backAlphaView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHiddenBackAlphaView)];
    [backAlphaView addGestureRecognizer:tap];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.menuCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.menuCollectionView.backgroundColor = [UIColor whiteColor];
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.delegate = self;
    [self.view addSubview:self.menuCollectionView];
    
    [self.menuCollectionView registerClass:[BusinessClassMoreCell class] forCellWithReuseIdentifier:@"menuCollectionViewCell"];
    self.menuCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    self.menuCollectionView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
    
}

- (void)didClickHiddenBackAlphaView{
    [UIView animateWithDuration:0.1 animations:^{
        backAlphaView.alpha = 0;
    }];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"menuCollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *mImageView=[[UIImageView alloc] init];
//    mImageView.layer.cornerRadius = 3;
//    mImageView.layer.masksToBounds = YES;
    if (sourceArray.count > 0) {
        MenuItem *item = [[MenuItem alloc] initWithDic:sourceArray[indexPath.row]];
        if ([self.type isEqualToString:@"menu"]) {
            [mImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.MenuImage, (int)(168*ScreenWidth/375)]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
        }else{
            [mImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.ShowImage, (int)(168*ScreenWidth/375)]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
        }
        
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapThisImageView:)];
    [mImageView setUserInteractionEnabled:YES];
    [mImageView setContentMode:UIViewContentModeScaleAspectFill];
    [mImageView setClipsToBounds:YES];
    [mImageView addGestureRecognizer:tap];
    mImageView.contentMode = UIViewContentModeScaleAspectFill;
    mImageView.contentScaleFactor=0;
    mImageView.frame=cell.bounds;
    [cell addSubview:mImageView];
    [cell sizeToFit];
    return cell;
}
//点击图片全屏方法
- (void)tapThisImageView:(UITapGestureRecognizer *)tap {
    
    [AvatarBrowser showImage:(UIImageView *)tap.view];
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((168*ScreenWidth/375), (180*ScreenWidth/375));
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake((10*ScreenWidth/375) , (15*ScreenWidth/375), (10*ScreenWidth/375), (15*ScreenWidth/375));
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (5*ScreenWidth/375);
}

#pragma mark --UICollectionViewDelegate
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *alphaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alphaImageView.image = [UIImage imageNamed:@"default_portrait_less"];//sourceArray[indexPath.row]
    alphaImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.2f;
    [backAlphaView addSubview:alphaView];
    [backAlphaView addSubview:alphaImageView];
    [UIView animateWithDuration:0.1 animations:^{
        backAlphaView.alpha = 1;
    }];
}
@end
