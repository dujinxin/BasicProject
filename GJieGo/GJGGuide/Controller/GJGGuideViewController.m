//
//  GJGGuideViewController.m
//  开机引导页 scrollView
//
//  Created by gjg on 16/6/16.
//  Copyright © 2016年 gjg. All rights reserved.
//

#import "GJGGuideViewController.h"
#import "BaseTabBarController.h"
#import "Masonry.h"
#import "AppDelegate.h"

#define GJGIMAGECOUNT 4
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@interface GJGGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak)  UIScrollView *scrollView;

@property (nonatomic,weak)  UIPageControl *pageControl;

@end

@implementation GJGGuideViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
    [self setUpPageControl];
    //刷新token
    //1.覆盖安装，如果用户是登录状态，那么刷新用户token；如果未登录刷新游客token
    //2.首次安装或者卸载安装，那么直接获取游客token
    if([[UserDBManager shareManager] getRefreshToken].length){//刷新token，用户或者游客
        [[UserRequest shareManager] userLongToken:kApiUserLongToken param:@{@"RToken":[[UserDBManager shareManager] getRefreshToken]} success:^(id object,NSString *msg) {} failure:^(id object,NSString *msg) {}];
    }else{//获取游客token
        NSString * parameterStr = [DJXNetworkConfig commonParameter:nil longitude:@0 latitude:@0];
        [[UserRequest shareManager] userShortToken:kGJGRequestUrl_v_cp(kApiVersion,kApiUserShortToken,parameterStr) param:@{@"Uc":[DJXNetworkConfig tokenStr:nil]} success:^(id object,NSString *msg) {} failure:^(id object,NSString *msg) {}];
    }
}

#pragma mark - 创建一个scrollView
- (void)setUpScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = self.view.bounds;
    
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * GJGIMAGECOUNT, 0);
    
    scrollView.pagingEnabled = YES;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.bounces = NO;
    
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [self setUpImageView];
}

#pragma mark - 给scroll添加3个imageView
- (void)setUpImageView{
    
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < GJGIMAGECOUNT; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * w, 0, w, h)];
        NSString *imageName = [NSString stringWithFormat:@"guide_%d",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [self.scrollView addSubview:imageView];
        
        // 如果是最后一个图片框就添加按钮
        if (i == GJGIMAGECOUNT - 1) {
            [self setLastImageView:imageView];
        }
    }
}

#pragma mark - 设置最后一个图片框的内容
- (void)setLastImageView:(UIImageView *)imageView{
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton.layer setMasksToBounds:YES];
    [startButton.layer setBorderWidth:1.5];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
    [startButton.layer setBorderColor:colorref];
    [startButton addTarget:self action:@selector(didClickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:startButton];
    
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.bottom.equalTo(imageView).offset(-60);
        make.width.mas_equalTo(127);
        make.height.mas_equalTo(43);
    }];
}



- (void)didClickStartBtn:(UIButton *)startBtn{
    
    if (![kUserDefaults stringForKey:UDKEY_IsFirstLaunch]){
        //用户首次安装进入app
        LoginViewController * login = [[LoginViewController alloc] init];
        UINavigationController * loginNVC = [[UINavigationController alloc] initWithRootViewController:login];
        
        [[JXViewManager sharedInstance] showWindowRootViewController:loginNVC completion:^(id object) {
            NSLog(@"用户首次安装进入app");
        }];
    }else{
        [[JXViewManager sharedInstance] dismissViewController:YES resetRootViewController:YES];
    }
}


#pragma mark - 创建pageControl
- (void)setUpPageControl{
    
    UIPageControl *pageControl = [UIPageControl new];
    
    pageControl.numberOfPages = GJGIMAGECOUNT;
    
    pageControl.currentPage = 0;
    
    [pageControl sizeToFit];
    
    [self.view addSubview:pageControl];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-67);
    }];
    
    self.pageControl = pageControl;

    [pageControl setValue:[UIImage imageNamed:@"point"] forKeyPath:@"pageImage"];
    [pageControl setValue:[UIImage imageNamed:@"big_point"] forKeyPath:@"currentPageImage"];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    double page = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.pageControl.currentPage = (int)(page + 0.5);
    
    if (self.pageControl.currentPage == GJGIMAGECOUNT - 1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    
    for (UIImageView *imageView in self.pageControl.subviews) {
        [imageView sizeToFit];
    }
}

@end
