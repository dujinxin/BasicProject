//
//  GJGADViewController.m
//  开机引导页 scrollView
//
//  Created by gjg on 16/6/17.
//  Copyright © 2016年 gjg. All rights reserved.
//  广告页面

#import "GJGADViewController.h"
#import "GJGNoHighlightedButton.h"
#import "Masonry.h"
#import "ADViewEntity.h"
#import "JXViewManager.h"
#import "BaseTabBarController.h"
#import "GJGADTool.h"
#import "GeneralMarketController.h"
#import "RestaurantClassController.h"
#import "FilmClassController.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "ShopCenterController.h"
#import "GJGStatisticManager.h"

@interface GJGADViewController (){
    
    int _time;
    
    UIImageView *bgImageView;
    
}

@property (nonatomic,weak) UIButton *timeButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) ADViewEntity *entity;


@end

@implementation GJGADViewController
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[GJGStatisticManager sharedManager] statisticByEventID:@"0101010010001" andBCID:@"00003" andMallID:@"00001" andShopID:@"00004" andBusinessType:@"supermarket" andItemID:@"00004" andItemText:nil andOpUserID:nil];
    
    _time = 3;
    [self setUpSubViews];
    
    [self sendRequest];

}
#pragma mark - subView

- (void)setUpSubViews{

    bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = self.view.bounds;
    bgImageView.contentMode =  UIViewContentModeScaleToFill;
    bgImageView.userInteractionEnabled = NO;
    bgImageView.image = [UIImage imageNamed:@"start"];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgImage)];
    [bgImageView addGestureRecognizer:singleTap];

    [self.view addSubview:bgImageView];
    
    UIButton *timeButton = [[UIButton alloc] init];
    [timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    timeButton.backgroundColor = [UIColor whiteColor];
    [timeButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.view addSubview:timeButton];
    [timeButton.layer setMasksToBounds:YES];
    [timeButton.layer setBorderWidth:1.5];
    timeButton.layer.cornerRadius = 15;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.5, 0.5, 0.5, 1 });
    [timeButton.layer setBorderColor:colorref];
    [timeButton addTarget:self action:@selector(didClickTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    timeButton.titleLabel.font = [UIFont systemFontOfSize:13];

    [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.top.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-6);
        
    }];
    
    self.timeButton = timeButton;
    
}

#pragma mark - 跳过
- (void)didClickTimeBtn{
    
    [self.timer invalidate];
    self.timer = nil;
    [[JXViewManager sharedInstance] dismissViewController:YES];
}


#pragma mark -  倒计时文字
- (void)titleWithButton{
    
    _time --;
    NSString *timeStr = [NSString stringWithFormat:@"跳过 %d秒",_time];
    
    [self.timeButton setTitle:timeStr forState:UIControlStateNormal];
    
    if (_time == 0) {
        
        [self.timer invalidate];
        self.timer = nil;
        
        [self didClickTimeBtn];
    }
}
#pragma mark - 调到详情界面
- (void)didClickBgImage{
    int type = [self.entity.LinkType intValue];
    
    switch (type) {
        case 0:// 无跳转
            
            break;
        case 1:// 跳转链接
            
            break;
        case 2:// 跳转商场
            [self pushToShopCenter];
            break;
        case 3:// 跳转店铺
            [self pushToShop];
            
            break;
        default:
            
            break;
    }
    
}

#pragma mark - 发送网络请求
- (void)sendRequest{
    [[UserRequest shareManager] getADView:kAD success:^(ADViewEntity * object) {
        
        if (object) { // 有数据
            [_timeButton setTitle:@"跳过 3秒" forState:UIControlStateNormal];
            [[GJGADTool sharedManager] preserveADEntity:object];
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:object.Image]];
            // 开启定时器
            self.entity = object;
            [self startTimer];
        }else{ // 没有数据
            [[GJGADTool sharedManager] anyAD];
            [self didClickTimeBtn];
        }
        
    } failure:^(id object) { // 判断有无缓存
        
        [[GJGADTool sharedManager] isHaveADEntity];
        
        ADViewEntity *entity = [GJGADTool sharedManager].entity;
        
        if (entity) { // 有缓存
            
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:entity.Image]];
            [_timeButton setTitle:@"跳过 3秒" forState:UIControlStateNormal];
            
            self.entity = entity;
            // 开启定时器
            [self startTimer];
        }else{ // 无缓存
            [self didClickTimeBtn];
        }
    }];
}

#pragma mark - 跳转到店铺
- (void)pushToShop{
    
    BaseTabBarController *baseVC = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    BaseNavigationController *Vc = [baseVC.viewControllers firstObject];
    
//    self.entity.LinkId = @(87);
    
    if ([self.entity.BusinessFormat isEqualToString:@"supermarket"]) {//超市    ②③
        GeneralMarketController *controller = [[GeneralMarketController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%@", self.entity.LinkId];
        [Vc pushViewController:controller animated:YES];
        [self adViewMoveLeft:controller];
    }else if ([self.entity.BusinessFormat isEqualToString:@"cafe"] || [self.entity.BusinessFormat isEqualToString:@"hotel"] || [self.entity.BusinessFormat isEqualToString:@"ktv"] || [self.entity.BusinessFormat isEqualToString:@"restaurant"]){//咖啡店、酒店、KTV、美食  ①②
        RestaurantClassController *controller = [[RestaurantClassController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%@", self.entity.LinkId];
//        [Vc.navigationController  pushViewController:controller animated:YES];
       
        [Vc pushViewController:controller animated:YES];
        [self adViewMoveLeft:controller];
        [self adViewMoveLeft:controller];
        
    }else{//影院、亲子、甜点饮品、美业、酒吧、健身、培训、足疗按摩、宠物店 ②
        
        FilmClassController *controller = [[FilmClassController alloc] init];
        controller.shopId = [NSString stringWithFormat:@"%@", self.entity.LinkId];
        [Vc pushViewController:controller animated:YES];
        [self adViewMoveLeft:controller];
        [self adViewMoveLeft:controller];
    }

}

#pragma mark - 跳转到商场
- (void)pushToShopCenter{
    
    BaseTabBarController *baseVC = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    BaseNavigationController *Vc = [baseVC.viewControllers firstObject];
    ShopCenterController *controller = [[ShopCenterController alloc] init];
    if ([self.entity.BusinessFormat isEqualToString:@"shoppingcenter"] || [self.entity.BusinessFormat  isEqualToString:@"departmentstore"]) {
        //购物中心
        controller.type = 1;
    }else{
        //电器卖场
        controller.type = 2;
        
    }
    controller.mId = [NSString stringWithFormat:@"%@", self.entity.LinkId];
    [Vc pushViewController:controller animated:YES];
}

#pragma mark - 跳转到H5
- (void)pushToHtml{
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


#pragma mark - 广告页向左移动
- (void)adViewMoveLeft:(UIViewController *)viewController{

    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0;
//       self.view.x = - ScreenWidth;
    }completion:^(BOOL finished) {
        
        
        [[JXViewManager sharedInstance] dismissViewController:YES];
    }];
    

    
}


#pragma mark - 开起定时器
- (void)startTimer{
    
    bgImageView.userInteractionEnabled = YES;
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(titleWithButton) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}


@end
