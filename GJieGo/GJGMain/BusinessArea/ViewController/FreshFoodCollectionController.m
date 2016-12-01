
//
//  FreshFoodCollectionController.m
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 熟食生鲜 ---

#import "FreshFoodCollectionController.h"
#import "FreshFoodCollectionCell.h"
#import "GJGBusinessView.h"
#import "MarketByShopModel.h"

@interface FreshFoodCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    UIView *statusBackView;
    NSMutableArray *collectionArray;
    UIView *alphaBusinessView;
    NSInteger h;
    NSInteger btnT;
    UIButton *titleButton;
    
    NSInteger page;
    NSInteger once;
}
@property (nonatomic, strong)UICollectionView *freshFoodCollectionView;
@property (nonatomic, strong)GJGBusinessView *businessView;
@end

@implementation FreshFoodCollectionController
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
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    btnT = 0;
    once = 0;
    page = 1;
    
    [self creatCollectionViewUI];
    
}

- (void)viewDidAppear:(BOOL)animated{
    if (once == 0) {
        once ++;
        [self.freshFoodCollectionView.mj_header beginRefreshing];
    }

}

- (void)gainData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"ShopId":_shopId, @"Type":_type, @"Cp":[NSString stringWithFormat:@"%ld", page]}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_PPByShop) parameters:param requestblock:^(id responseobject, NSError *error) {
        NSLog(@"--- %@", responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            if (page == 1) {
                collectionArray == nil ? (collectionArray = [NSMutableArray array]) : ([collectionArray removeAllObjects]);
                [_freshFoodCollectionView.mj_header endRefreshing];
            }else{
                if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *array = [NSMutableArray arrayWithArray:responseobject[@"data"]];
                    if (array.count < 20) {
                        [_freshFoodCollectionView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [_freshFoodCollectionView.mj_footer endRefreshing];
                    }
                }else{
                    [_freshFoodCollectionView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
            MarketByShopModel *model = [[MarketByShopModel alloc] initWithDic:responseobject];
            if (model.Data.count > 0) {
                for (int i = 0; i < model.Data.count; i++) {
                    [collectionArray addObject:model.Data[i]];
                }
                [self.freshFoodCollectionView reloadData];
            }else{
            }
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - Update data

- (void)updateData {
    
    page = 1;
    
    [self gainData];
//    [self.freshFoodCollectionView.mj_header endRefreshing];
}

- (void)updateMoreData {
    
    page++;
    [self gainData];
//    [self.freshFoodCollectionView.mj_footer endRefreshing];
}

- (void)creatCollectionViewUI{
    self.freshFoodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.freshFoodCollectionView.dataSource = self;
    self.freshFoodCollectionView.delegate = self;
    self.freshFoodCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.freshFoodCollectionView];
    [self.freshFoodCollectionView registerClass:[FreshFoodCollectionCell class] forCellWithReuseIdentifier:@"FreshFoodCollectionCell"];
    self.freshFoodCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self updateData];
    }];
    self.freshFoodCollectionView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        [self updateMoreData];
    }];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return collectionArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MarketByShopItem *item = [[MarketByShopItem alloc] initWithDic:collectionArray[indexPath.item]];
    
    FreshFoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FreshFoodCollectionCell" forIndexPath:indexPath];
    [cell sizeToFit];
    [cell.tradeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.PPImage, (int)(ScreenWidth * 0.45)]] placeholderImage:[UIImage imageNamed:@"default_portrait_normal"]];
    cell.titleLabel.text = item.PPName;
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元", item.OPrice]
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                                                                              NSForegroundColorAttributeName:GJGRGB16Color(0x999999),
                                                                              NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                              NSStrikethroughColorAttributeName:GJGRGB16Color(0x999999)}];
    cell.originalPriceLabel.attributedText = attrStr;
    cell.timeLabel.text = [NSString stringWithFormat:@"有效日期：%@",item.AvailableDate];
    cell.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f元", item.DPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:GJGRGB16Color(0xff5252) range:NSMakeRange(0, str.length - 1)];
    cell.currentPriceLabel.attributedText = str;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth * 0.45, ScreenWidth * 0.7);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5 , (ScreenWidth - ScreenWidth*2*0.45)/3, 5, (ScreenWidth - ScreenWidth*2*0.45)/3);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (ScreenWidth - ScreenWidth*2*0.45)/3;
}
@end
