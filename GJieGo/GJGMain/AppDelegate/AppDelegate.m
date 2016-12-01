//
//  AppDelegate.m
//  GJieGo
//
//  Created by 杨朝霞 on 16/2/29.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "GJGGuideViewController.h"
#import "GJGADView.h"
#import "ADViewEntity.h"

#import "ChatUtil.h"
#import "AppDelegate+EaseMob.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import <CloudPushSDK/CloudPushSDK.h>
#import "FansViewController.h"

#import "CustomURLCache.h"

@interface AppDelegate (){
    
}
@property (nonatomic, strong) GJGGuideViewController * guide;
@end

@implementation AppDelegate

+ (AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //third part init
    [self initThirdPart:application didFinishLaunchingWithOptions:launchOptions];
    [self initAliPush:application didFinishLaunchingWithOptions:launchOptions];
    
    // webView 缓存
    [self setUpWebViewCache];
    
    [self.window makeKeyAndVisible];
    // 选择控制器
    [self chooseViewController];
    //APP未启动，点击推送消息，iOS10下还是跟以前一样在此获取
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"RemoteUserInfo:%@",userInfo);
        //[[JXViewManager sharedInstance] showAlertMessage:[NSString stringWithFormat:@"%@",userInfo]];
        if (userInfo[@"e"]) {
            NSDictionary * info = userInfo[@"e"];
            [[NotificationManager shareManager] handleReceiveRemoteNotification:info];
        }
        
    }
    return YES;
}

#pragma mark - 第一次登陆
- (void)setUpTabBarController{
    if (![kUserDefaults stringForKey:UDKEY_IsFirstLoginRegister]){
        [kUserDefaults setValue:@"1" forKey:UDKEY_IsFirstLoginRegister];
        [kUserDefaults synchronize];
    } 
    //刷新用户token
    if([[UserDBManager shareManager] getRefreshToken].length && ![[UserDBManager shareManager] isVisitor]){
        [[UserRequest shareManager] userLongToken:kApiUserLongToken param:@{@"RToken":[[UserDBManager shareManager] getRefreshToken]} success:^(id object,NSString *msg) {} failure:^(id object,NSString *msg) {}];
    }else{
        //获取游客token
        NSString * parameterStr = [DJXNetworkConfig commonParameter:nil longitude:@0 latitude:@0];
        [[UserRequest shareManager] userShortToken:kGJGRequestUrl_v_cp(kApiVersion,kApiUserShortToken,parameterStr) param:@{@"Uc":[DJXNetworkConfig tokenStr:nil]} success:^(id object,NSString *msg) {} failure:^(id object,NSString *msg) {}];
    }

    _tabBarController = [[BaseTabBarController alloc] init];
    _tabBarController.delegate = self;
    self.window.rootViewController = _tabBarController;
}

#pragma mark - 非1
- (void)setUpGuideController{
    
    _guide  = [[GJGGuideViewController alloc] init];
    self.window.rootViewController = _guide;
}

#pragma mark - 选择将要启动的控制器
- (void)chooseViewController{
    
    /*通过判断版本号来判断是否是第一次执行 */
    NSString *current_ver = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ver = [user objectForKey:@"key_ver"];
    
    if ([current_ver isEqualToString:ver]) {
        [self setUpTabBarController];
        [self showBadge:[[NotificationManager shareManager] isHasNews]];
    }else {
        [self setUpGuideController];
    }
    
    [user setObject:current_ver forKey:@"key_ver"];
    [user synchronize];
    NSFileManager *fileMananger = [NSFileManager defaultManager];
    GJGADView *adView = [[GJGADView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSLog(@"广告图片存放地址-------%@",GJGADImageFile);
    if ([fileMananger fileExistsAtPath:GJGADImageFile]) {
        [adView show];
    }
    [adView sendRequest];
}


- (void)initThirdPart:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //友盟分享
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUmengAppKey];
#ifdef kShowLog
    //打开调试log的开关
    [UMSocialData openLog:YES];
#endif
    //设置微信,QQ AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWeiXinAppId appSecret:kWeiXinAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:kTencentAppId appKey:kTencentAppSecret url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:kHXAppKey
                apnsCertName:kHXApnsName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    //    dispatch_after(0.2, dispatch_get_main_queue(), ^{
    //
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[body_content objectForKey:@"extras"] objectForKey:@"action_url"]]];
    //
    //    });

}
#pragma mark - UITabBarConntrollerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
//    if (index == 3){
//        //判断登录状态
//        return [[LoginManager shareManager] checkUserLoginState:^{
//                    [_tabBarController setSelectedIndex:index];
//                }];
//    }else{
//        [_tabBarController setSelectedIndex:index];
//    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    _selectedIndex = index;
}
- (void)showBadge:(BOOL)yesOrNo{
    if (yesOrNo) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
}


#pragma mark - Ali push

- (void)initAliPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
#ifdef kShowLog
    [CloudPushSDK turnOnDebug];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
#endif
    
    // 监听推送消息到来
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    [CloudPushSDK handleLaunching:launchOptions];
    
    // [2-EXT]: 获取启动时收到的本地 APN 数据
//    NSDictionary * userInfo= [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        NSLog(@"Receive one notification.3 = %@",userInfo);
//        //    [[GJGPushManager sharedManager] handlerUserInfo:userInfo];
//        if (userInfo[@"note"]){
//            NSDictionary * extraDict = userInfo[@"note"];
//            [[NotificationManager shareManager] createTable:NotificationDBName keys:extraDict.allKeys];
//            [[NotificationManager shareManager] insertData:NotificationDBName keyValues:extraDict];
//            [self showBadge:[[NotificationManager shareManager] isHasUnReadMessages]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@YES];
//        }
//    }
}

- (void)registerAPNS:(UIApplication *)application {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        // iOS 8 Notifications
//        [application registerUserNotificationSettings:
//         [UIUserNotificationSettings settingsForTypes:
//          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                           categories:nil]];
//        [application registerForRemoteNotifications];
//    }
//    else {
//        // iOS < 8 Notifications
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//    }
}

- (void)initCloudPush {
    // SDK初始化
    NSString *apk = @"23386358";
    NSString *aps = @"606ea078fd4a3e657291df6657aee331";
    
    [CloudPushSDK asyncInit:apk appSecret:aps callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}
/**
 *	@brief	注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *	@brief	推送通道打开回调
 *
 *	@param 	notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"消息通道建立成功");
}
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

- (void)onMessageReceived:(NSNotification *)notification {
    // 当前仅支持获取消息内容

    
    //{"UserId":21,"UserType":1,"NoteType":3,"InfoId":118,"Infotype":1,"Message":"ddd评论了你的爱晒“我的就到家...”","AddTime":1467926075852}
    NSData * data = [notification object];
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message is: %@", dataStr);
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if ([jsonObject isKindOfClass:[NSDictionary class]]){
//        NSDictionary * extraDict = [[NSMutableDictionary alloc] initWithDictionary:jsonObject];
//        [[NotificationManager shareManager] createTable:NotificationDBName keys:extraDict.allKeys];
//        [[NotificationManager shareManager] insertData:NotificationDBName keyValues:extraDict];
//        [self showBadge:[[NotificationManager shareManager] isHasUnReadMessages]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:nil];
        
    }else{
        NSLog(@"param error = %@ !" , error);
    }
}

/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"local notification");
    [[NotificationManager shareManager] handleReceiveRemoteNotification:notification.userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [[NotificationManager shareManager] handleReceiveRemoteNotification:userInfo];
//    // iOS badge 清0
//    application.applicationIconBadgeNumber = 0;
//    // 通知打开回执上报
    [CloudPushSDK handleReceiveRemoteNotification:userInfo];
}
#pragma mark - AppDelegate
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}


#pragma mark - 设置缓存
- (void)setUpWebViewCache{
    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                 diskCapacity:200 * 1024 * 1024
                                                                     diskPath:nil
                                                                    cacheTime:600];
    [CustomURLCache setSharedURLCache:urlCache];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {  
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[LoginManager shareManager] isHadLogin]) {
        [[UserRequest shareManager] userNotificationNews:kApiNotificationNews param:nil success:^(id object,NSString *msg) {
            BOOL yesOrNo = [object[@"hasNotice"] boolValue];
            [NotificationManager shareManager].isHasNews = [object[@"hasNotice"] intValue];
            [self showBadge:yesOrNo];
            [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadSystemMessagesNotification object:@(yesOrNo)];
            //[UIApplication sharedApplication].applicationIconBadgeNumber = [object[@"hasNotice"] intValue];
        } failure:^(id object,NSString *msg) {}];
        
        //分享提示
        if ([kUserDefaults stringForKey:UDKEY_ShareNotice]){
            [[JXViewManager sharedInstance] showJXNoticeMessage:[kUserDefaults stringForKey:UDKEY_ShareNotice]];
            [kUserDefaults removeObjectForKey:UDKEY_ShareNotice];
            [kUserDefaults synchronize];
        }
        //更新通知数量
        [[NSNotificationCenter defaultCenter] postNotificationName:HasUnreadChatMessagesNotification object:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    JXDispatch_async_global((^(){
        [DJXRequest requestWithBlock:kApiCheckVersion param:@{@"platform":@2} success:^(id object,NSString *msg) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                if ([dict[@"IsForce"] boolValue]) {
                    if (![dict[@"Version"] isEqualToString:kAppVersion]) {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:dict[@"Msg"] message:dict[@"Details"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
                        alert.tag = 2000;
                        [alert show];
                    }
                    
                }else{
                    if (![dict[@"Version"] isEqualToString:kAppVersion]) {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:dict[@"Msg"] message:dict[@"Details"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                        alert.tag = 2001;
                        [alert show];
                    }
                }
            }
        } failure:^(id object,NSString *msg) {
            //
        }];
    }));
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
