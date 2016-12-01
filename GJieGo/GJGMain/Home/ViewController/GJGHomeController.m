//
//  GJGHomeController.m
//  GJieGo
//
//  Created by 杨朝霞 on 16/2/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define HalfScreenW [UIScreen mainScreen].bounds.size.width * 0.5
#define HalfScreenH [UIScreen mainScreen].bounds.size.height * 0.5
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#import "GJGHomeController.h"
#import "RadarViewController.h"
#import "ShopGuideViewController.h"
#import "SharedOrderViewController.h"
#import "LocationViewController.h"
#import "SearchOfMainViewController.h"
#import "GJGLocationManager.h"

@interface GJGHomeController () <UIScrollViewDelegate, LocationViewControllerDelegate, RadarViewControllerDelegate> {
    
    UIImageView *bgImgView;
    UIImageView *coverImgView;
    
    UIView *navigationView;
    UIView *modulesViewHolder;
    UIView *sliderView;
    NSMutableArray *modulBtns;
    UIButton *locationButtom;
    
    UIScrollView *mainScrollView;
    NSArray *modules;
    CGFloat halfModuleButtonWidth;
    
    RadarViewController *radarVC;
    ShopGuideViewController *shopGuideVC;
    SharedOrderViewController *sharedOrderVC;
}
@end

@implementation GJGHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self createUI];
    [self updateLocationName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [radarVC hiddenCollectionView];
}


#pragma mark - Init

- (void)initAttributes {
    
    modules = @[@"雷达", @"导购", @"晒单"];
    halfModuleButtonWidth = ScreenW / (modules.count * 2);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    modulBtns = [NSMutableArray array];
}

- (void)createUI {

    [self createBgImg];
    [self createNavigationView];
    [self createMainView];
    
}

- (void)createBgImg {
    
    bgImgView = [[UIImageView alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"back_BG" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [bgImgView setImage:image];
    [bgImgView setContentMode:UIViewContentModeScaleAspectFit];
    bgImgView.clipsToBounds = YES;
    [self.view addSubview:bgImgView];
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    coverImgView = [[UIImageView alloc] init];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"cover_BG" ofType:@"jpg"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path2];
    [coverImgView setImage:image2];
    [coverImgView setContentMode:UIViewContentModeScaleAspectFit];
    coverImgView.clipsToBounds = YES;
    [self.view addSubview:coverImgView];
    [coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
//    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    visualEffectView.alpha = 0.92;
//    [bgImgView addSubview:visualEffectView];
//    [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.left.bottom.and.right.equalTo(bgImgView).with.offset(0);
//    }];
    
}

- (void)createNavigationView {

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.75, 44)];
    [navigationView setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    locationButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButtom addTarget:self action:@selector(locationViewClick:) forControlEvents:UIControlEventTouchUpInside];
    locationButtom.frame = CGRectMake(0, 0, ScreenWidth * 0.75, 44);
    [locationButtom setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [locationButtom setImage:[UIImage imageNamed:@"titile_positioning_white_default"] forState:UIControlStateNormal];
    [locationButtom setTitle:[GJGLocationManager sharedManager].locationName forState:UIControlStateNormal];
    [locationButtom.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [navigationView addSubview:locationButtom];
    self.navigationItem.titleView = navigationView;
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [searchButton setImage:[UIImage imageNamed:@"titile_search_white"]forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem= searchItem;
}

- (void)createMainView {
    
    [self createModulesView];
    [self createScrollView];
}

- (void)createModulesView {
    
    CGFloat holderY = 64;
    CGFloat holderH = 40;
    
    modulesViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, holderY, ScreenW, holderH)];
    modulesViewHolder.backgroundColor = [UIColor clearColor];
    
    CGFloat lineHeight = 0.5;
    CGFloat lineMargin = 24;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [modulesViewHolder addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(modulesViewHolder.mas_left).with.offset(lineMargin);
        make.right.equalTo(modulesViewHolder.mas_right).with.offset(-lineMargin);
        make.top.equalTo(modulesViewHolder.mas_top).with.offset(0);
        make.height.mas_equalTo([NSNumber numberWithDouble:lineHeight]);
    }];
    
    CGFloat btnWidth = ScreenW / modules.count;
    CGFloat btnHeight = modulesViewHolder.frame.size.height - lineHeight * 3;
    
    sliderView = [[UIView alloc] init];
    sliderView.backgroundColor = COLOR(254, 227, 48, 1);
    [modulesViewHolder addSubview:sliderView];
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.mas_bottom).with.offset(0);
        make.left.equalTo(modulesViewHolder.mas_left).with.offset((btnWidth - 60) * 0.5);
        make.width.equalTo(60);
        make.height.equalTo(3);
    }];
    
    for (int i = 0; i < modules.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [modulBtns addObject:btn];
        [btn setTag:(10 + i)];
        [btn setTitle:modules[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:COLOR(254, 227, 48, 1) forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn addTarget:self action:@selector(moduleClick:) forControlEvents:UIControlEventTouchUpInside];
        [modulesViewHolder addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(modulesViewHolder).with.equalTo(1.5);
            make.left.equalTo(modulesViewHolder.mas_left).with.equalTo(btnWidth * i);
            make.width.mas_equalTo([NSNumber numberWithDouble:btnWidth]);
            make.height.mas_equalTo([NSNumber numberWithDouble:btnHeight]);
        }];
    }
    
    [self.view addSubview:modulesViewHolder];
    [modulesViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(holderY);
        make.height.mas_equalTo([NSNumber numberWithDouble:holderH]);
    }];
}

- (void)createScrollView {
    
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = CGRectGetMaxY(modulesViewHolder.frame) + 10.f;
    CGFloat scrollViewW = ScreenW;
    CGFloat scrollViewH = ScreenH - scrollViewY;
    CGFloat scrollViewContentW = ScreenW * modules.count;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    mainScrollView.contentSize = CGSizeMake(scrollViewContentW, scrollViewH);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    
    
    radarVC = [[RadarViewController alloc] init];
    radarVC.delegate = self;
    [self addChildViewController:radarVC];
    [mainScrollView addSubview:radarVC.view];
    [radarVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.top.equalTo(mainScrollView).with.equalTo(0);
        make.width.mas_equalTo([NSNumber numberWithDouble:scrollViewW]);
        make.height.mas_equalTo([NSNumber numberWithDouble:scrollViewH]);
    }];
    
    shopGuideVC = [[ShopGuideViewController alloc] init];
    [self addChildViewController:shopGuideVC];
    [mainScrollView addSubview:shopGuideVC.view];
    [shopGuideVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(mainScrollView).with.equalTo(0);
        make.left.equalTo(mainScrollView).with.equalTo(scrollViewW);
        make.width.mas_equalTo([NSNumber numberWithDouble:scrollViewW]);
        make.height.mas_equalTo([NSNumber numberWithDouble:scrollViewH]);
    }];
    
    sharedOrderVC = [[SharedOrderViewController alloc] init];
    [self addChildViewController:sharedOrderVC];
    [mainScrollView addSubview:sharedOrderVC.view];
    [sharedOrderVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(mainScrollView).with.equalTo(0);
        make.left.equalTo(mainScrollView).with.equalTo(scrollViewW * 2);
        make.width.mas_equalTo([NSNumber numberWithDouble:scrollViewW]);
        make.height.mas_equalTo([NSNumber numberWithDouble:scrollViewH]);
    }];
    
    [self.view addSubview:mainScrollView];
}


#pragma mark - Update locationName

- (void)updateLocationName {
    [self getNewLocation];
//    NSTimer *refreshLocation = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(getNewLocation) userInfo:nil repeats:CGFLOAT_MAX];
//    [refreshLocation fire];
}
- (void)getNewLocation {
    [locationButtom setTitle:[GJGLocationManager sharedManager].locationName forState:UIControlStateNormal];
}


#pragma mark - Scorll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scale = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.contentSize.width;
    CGFloat currentX = modulesViewHolder.frame.size.width * scale;
    CGFloat currentY = sliderView.center.y;
    sliderView.center = CGPointMake(currentX, currentY);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustBtnColor];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self adjustBtnColor];
}

- (void)adjustBtnColor {
    for (UIButton *modul in modulBtns) {
        [modul setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [modulBtns[(int)(mainScrollView.contentOffset.x / kScreenWidth)] setTitleColor:COLOR(254, 227, 48, 1) forState:UIControlStateNormal];
}


#pragma mark - Radar view controller delegate

- (void)radarView:(RadarViewController *)radarViewController DidDragging:(CGFloat)value {
    coverImgView.alpha = value;
}

- (void)radarView:(RadarViewController *)radarViewController RefreshSuccess:(BOOL)success {
    if (success) {
//        NSLog(@"homeVC代理方法被调用时的地区字段: %@", [GJGLocationManager sharedManager].locationName);
        [locationButtom setTitle:[GJGLocationManager sharedManager].locationName forState:UIControlStateNormal];
    }
}


#pragma mark - Button click event

- (void)locationViewClick:(UIButton *)button {
//    [locationButtom setTitle:[GJGLocationManager sharedManager].locationName forState:UIControlStateNormal];
    
//    LocationViewController *locationVC = [[LocationViewController alloc] init];
//    locationVC.delegate = self;
//    [locationVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)searchItemClick:(id)sender {
    
    SearchOfMainViewController *searchVC = [[SearchOfMainViewController alloc] init];
    [searchVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)moduleClick:(UIButton *)button {
    [mainScrollView setContentOffset:CGPointMake((button.tag - 10) * mainScrollView.frame.size.width, 0) animated:YES];
}


#pragma mark - Location vc has selectedLocation

- (void)locationViewControllerSelectedLocation:(NSString *)locationName {
    
//    [locationButtom setTitle:locationName forState:UIControlStateNormal];
}


#pragma mark - System func

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
