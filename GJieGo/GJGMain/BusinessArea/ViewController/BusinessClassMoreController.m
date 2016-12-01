//
//  BusinessClassMoreController.m
//  GJieGo
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 商品分类 更多模块 ---

#import "BusinessClassMoreController.h"
#import "BusinessClassMoreCell.h"
#import "BusinessClassDetailListController.h"

@interface BusinessClassMoreController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    UIView *statusBackView;
//    NSArray *sourceArray;
}
@property (nonatomic, strong)UICollectionView *businessCollectionView;
@end

@implementation BusinessClassMoreController
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
    
    self.businessCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.businessCollectionView.backgroundColor = [UIColor whiteColor];
    self.businessCollectionView.dataSource = self;
    self.businessCollectionView.delegate = self;
    [self.view addSubview:self.businessCollectionView];
    [self.businessCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [self.businessCollectionView registerClass:[BusinessClassMoreCell class] forCellWithReuseIdentifier:@"businessClassCell"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.sourceArray[indexPath.row];
    BusinessTypeItem *item = [[BusinessTypeItem alloc] initWithDic:dic];
    static NSString *identifier = @"businessClassCell";
    BusinessClassMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell sizeToFit];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.DicExt] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];//.image = [UIImage imageNamed:item.DicExt];//dic[@"DicExt"]
    cell.textLabel.text = item.DicName;//dic[@"DicName"]
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.sourceArray[indexPath.row];
    BusinessTypeItem *item = [[BusinessTypeItem alloc] initWithDic:dic];
    
    BusinessClassDetailListController *controller = [[BusinessClassDetailListController alloc] init];
    controller.title = item.DicName;
    controller.bcId = _bcId;
    controller.Type = item.DicID;
    controller.businessName = item.DicName;
    controller.eventID = ID_0201010010001;
    [self.navigationController pushViewController:controller animated:YES];
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(ScreenWidth / 4 - 4 , ScreenWidth / 4 - 4);//((ScreenWidth-20)/2, (ScreenWidth-20)/2+50);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1 , 1, 1, 1);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark --UICollectionViewDelegate
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
