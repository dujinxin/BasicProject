//
//  BaseTabBarController.m
//  GJieGo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTabBarController.h"
#import "GJGHomeController.h"
#import "GJGBusinessAreaController.h"
#import "GJGFindController.h"
#import "GJGMyController.h"


@implementation BaseTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpChildVC];
    [self setUpTabBar];
}

#pragma mark - childVC
- (void)setUpChildVC{

    //首页
    GJGHomeController *homeController = [[GJGHomeController alloc] init];
    BaseNavigationController *homeNavi = [[BaseNavigationController alloc] initWithRootViewController:homeController];
    homeNavi.title = @"首页";
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"Home_default"];
    //商圈
    GJGBusinessAreaController *bussinessAreaController = [[GJGBusinessAreaController alloc] init];
    BaseNavigationController *bussinessAreaNavi = [[BaseNavigationController alloc] initWithRootViewController:bussinessAreaController];
    bussinessAreaNavi.title = @"商圈";
    bussinessAreaNavi.tabBarItem.image = [UIImage imageNamed:@"Business circle_default"];
    //发现
    GJGFindController *findController = [[GJGFindController alloc] init];
    BaseNavigationController *findNavi = [[BaseNavigationController alloc] initWithRootViewController:findController];
    findNavi.title = @"发现";
    findNavi.tabBarItem.image = [UIImage imageNamed:@"found_default"];
    //我的
    GJGMyController *myController = [[GJGMyController alloc] init];
    BaseNavigationController *myNavi = [[BaseNavigationController alloc] initWithRootViewController:myController];
    myNavi.title = @"我的";
    myNavi.tabBarItem.image = [UIImage imageNamed:@"My_default"];

    self.viewControllers = @[homeNavi, bussinessAreaNavi, findNavi, myNavi];
    
}

#pragma mark - setUpTabBar
- (void)setUpTabBar{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    backView.backgroundColor = [UIColor blackColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    self.tabBar.tintColor=[UIColor whiteColor];
}

@end
