//
//  ShopEnviromentController.m
//  GJieGo
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 店铺环境 ---

#import "ShopEnviromentController.h"
#import "BusinessClassMoreCell.h"
#import "AvatarBrowser.h"

@interface ShopEnviromentController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    UIView *statusBackView;
    NSArray *sourceArray;
    UIView *backAlphaView;
}
@property (nonatomic, strong)UICollectionView *menuCollectionView;

@end

@implementation ShopEnviromentController
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
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    sourceArray = [[NSArray alloc] initWithObjects:@"login_bg",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage",@"placeholderImage", nil];
    
    backAlphaView = [[UIView alloc] initWithFrame:self.view.frame];
    backAlphaView.backgroundColor = [UIColor redColor];
    backAlphaView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHiddenBackAlphaView)];
    [backAlphaView addGestureRecognizer:tap];
    self.menuCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.menuCollectionView.backgroundColor = [UIColor whiteColor];
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.delegate = self;
    [self.view addSubview:self.menuCollectionView];
//    [self.view addSubview:backAlphaView];
    
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [self.menuCollectionView registerClass:[BusinessClassMoreCell class] forCellWithReuseIdentifier:@"ShopEnviromentCell"];
}
- (void)didClickHiddenBackAlphaView{
    backAlphaView.hidden = YES;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ShopEnviromentCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *mImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@@%dW_1o", sourceArray[indexPath.row], (int)(110*ScreenWidth/375)]]];
//    mImageView.layer.cornerRadius = 3;
//    mImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapThisImageView:)];
    [mImageView setUserInteractionEnabled:YES];
    [mImageView setContentMode:UIViewContentModeScaleAspectFill];
    [mImageView setClipsToBounds:YES];
    [mImageView addGestureRecognizer:tap];
    mImageView.contentMode = UIViewContentModeScaleAspectFill;
    mImageView.contentScaleFactor = 0;
    mImageView.frame = cell.bounds;
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
    return CGSizeMake((110*ScreenWidth/375),(110*ScreenWidth/375));
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

#pragma mark -- UICollectionViewDelegate
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImageView *alphaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alphaImageView.image = [UIImage imageNamed:sourceArray[indexPath.row]];
    alphaImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.2f;
    [backAlphaView addSubview:alphaView];
    [backAlphaView addSubview:alphaImageView];
    backAlphaView.hidden = NO;
}
@end
