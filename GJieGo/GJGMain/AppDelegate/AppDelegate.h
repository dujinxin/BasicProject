//
//  AppDelegate.h
//  GJieGo
//
//  Created by 杨朝霞 on 16/2/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"
#import "UITabBar+Badge.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>


@property (nonatomic, assign) BOOL CXOn;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BaseTabBarController * tabBarController;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSDictionary * notificationDict;

+ (AppDelegate *)appDelegate;
- (void)showBadge:(BOOL)yesOrNo;

@end

