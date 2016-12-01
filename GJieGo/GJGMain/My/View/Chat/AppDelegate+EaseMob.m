//
//  Appdelegate+EaseMob.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "AppDelegate+EaseMob.h"

#import "LoginViewController.h"
#import "ChatUtil.h"
#import "MBProgressHUD.h"

#import <CloudPushSDK/CloudPushSDK.h>
#import "FansViewController.h"


/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    NSNumber * log;
#ifdef kShowLog
    log = [NSNumber numberWithBool:YES];
#else
    log = [NSNumber numberWithBool:NO];
#endif
    [[EaseSDKHelper shareHelper] easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:appkey
                                       apnsCertName:apnsCertName
                                     otherConfig:@{kSDKConfigEnableConsoleLogger:log,@"easeSandBox":[NSNumber numberWithBool:@(NO)]}];
    
    [ChatUtil shareHelper];
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    else
    {
        //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] bindDeviceToken:deviceToken];
        if (error) {
            NSLog(@"EMError = %@",error.errorDescription);
        }
        [CloudPushSDK registerDevice:deviceToken];
    });
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken = %@",deviceToken);
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError = %@",error.localizedDescription);
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
//    UINavigationController *navigationController = nil;
    if (loginSuccess) {//登陆成功加载主窗口控制器
//        //加载申请通知的数据
//        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
//        if (self.mainController == nil) {
//            self.mainController = [[MainViewController alloc] init];
//            navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
//        }else{
//            navigationController  = self.mainController.navigationController;
//        }
//        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处
//        [self initParse];
//        
//        [ChatUtil shareHelper].mainVC = self.mainController;
        
//        [[ChatUtil shareHelper] asyncGroupFromServer];
        
        [[ChatUtil shareHelper] asyncConversationFromDB];
        [[ChatUtil shareHelper] asyncPushOptions];
        
        EMError * error = [[EMClient sharedClient] setApnsNickname:[UserDBManager shareManager].UserName];
        if (!error) {
            NSLog(@"设置环信推送昵称成功");
        }else{
            NSLog(@"设置环信推送昵称失败：%@",error.errorDescription);
        }
        
    }
    else{//登陆失败加载登陆页面控制器
//        self.mainController = nil;
//        [ChatDemoHelper shareHelper].mainVC = nil;
//        
//        LoginViewController *loginController = [[LoginViewController alloc] init];
//        navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
//        [self clearParse];
        
        NSLog(@"loginStateChange：退出登录");
        [self loginInfomationUnavailble:kUserLogoutForOtherDevice];
//        [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
//            if (res.success){
//                NSLog(@"阿里推送解绑账号成功");
//            }else{
//                NSLog(@"阿里推送解绑账号失败：%@",res.error);
//            }
//        }];
    }
} 

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}
// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0){
        UIView *frontView = [viewsArray objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]]){
            activityViewController = nextResponder;
        }else{
            activityViewController = window.rootViewController;
        }
    }
    return activityViewController;
}
#pragma mark - custom private
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    
    if (alertView.tag == 1002) {//通知
        if (buttonIndex == 0) {
            return;
        }
        if (!self.notificationDict) {
            return;
        }
        NotificationType type = [self.notificationDict[@"NoteType"] integerValue];
        AppDelegate * appDelegate = [AppDelegate appDelegate];
        BaseNavigationController * baseVc = appDelegate.tabBarController.selectedViewController;
        switch (type) {
            case NotificationFansType:
            {
                FansViewController * svc = [[FansViewController alloc ]init ];
                [baseVc pushViewController:svc animated:YES];
            }
                break;
            case NotificationPriseType:
            case NotificationCommentType:
            case NotificationShareType:
            case NotificationReturnType:
            {
                if ([self.notificationDict[@"UserType"] integerValue] == Guider) {
//                    ShopGuideDetailViewController *svc = [[ShopGuideDetailViewController alloc] init];
//                    svc.infoid = [self.notificationDict[@"InfoId"] integerValue];
//                    [baseVc pushViewController:svc animated:YES];
                }else if([self.notificationDict[@"UserType"] integerValue] == User){
//                    SharedOrderDetailViewController *svc = [[SharedOrderDetailViewController alloc] init];
//                    svc.infoId = [self.notificationDict[@"InfoId"] integerValue];
//                    [baseVc pushViewController:svc animated:YES];
                }else{
                    [[JXViewManager sharedInstance] showJXNoticeMessage:@"用户类型出错！"];
                }
                
            }
                break;
                
        }

    }else if(alertView.tag == 2000){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
    }else if(alertView.tag == 2001){
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
        }
    }else if(alertView.tag == 3001){//token
        [self loginInfomationUnavailble:kUserLogoutTokenDisabled];
    }else if(alertView.tag == 3002){
        [self loginInfomationUnavailble:kUserLogoutForOtherDevice];
    }else{
        
    }
}

- (void)loginInfomationUnavailble:(UserLogoutType)type{
    NSLog(@"loginInfomationUnavailble：退出登录");
    if ([[LoginManager shareManager]isHadLogin]) {
        [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
            if (res.success){
                NSLog(@"阿里推送解绑账号成功");
            }else{
                NSLog(@"阿里推送解绑账号失败：%@",res.error);
            }
        }];
        [[LoginManager shareManager] logOut];
        [[UserDBManager shareManager] deleteToken];
    }
    if (type != kUserLogoutForOtherDevice) {
        [kUserDefaults removeObjectForKey:UDKEY_MobileNumber];
        [kUserDefaults removeObjectForKey:UDKEY_Password];
        [kUserDefaults synchronize];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    
    NSString * parameterStr = [DJXNetworkConfig commonParameter:nil longitude:@0 latitude:@0];
    [[UserRequest shareManager] userShortToken:kGJGRequestUrl_v_cp(kApiVersion,kApiUserShortToken,parameterStr) param:@{@"Uc":[DJXNetworkConfig tokenStr:nil]} success:^(id object,NSString *msg) {} failure:^(id object,NSString *msg) {
        
        [appDelegate.tabBarController setSelectedIndex:0];
        NSLog(@"服务器已挂，游客token获取失败！");
    }];
    
    [[LoginManager shareManager] presentLoginViewController:YES logoutType:type loginSuccess:^(id object){
        NSLog(@"登录 %@",object);
        BOOL isSameUser = [(NSNumber *)object boolValue];
        NSLog(@"登录 %d",isSameUser);
        if (isSameUser) {
            [[DJXRequestManager sharedInstance] addRequests];
        }else{
            [[DJXRequestManager sharedInstance] cancelRequests];
            NSLog(@"用户已改变");
        }
        [self popOrDismissViewController:isSameUser];
        
    } cancel:^(id object){
        NSLog(@"取消");
        [[DJXRequestManager sharedInstance] cancelRequests];
        [self popOrDismissViewController:NO];
        [appDelegate.tabBarController setSelectedIndex:appDelegate.selectedIndex];
    }];
}
- (void)popOrDismissViewController:(BOOL)yesOrNo{
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    UINavigationController * nvc = appDelegate.tabBarController.selectedViewController;
    UIViewController * vc = nvc.topViewController;
    if (nvc.viewControllers.count >1) {
        if (![vc.navigationController.visibleViewController isEqual:vc]) {
            [vc.navigationController.visibleViewController dismissViewControllerAnimated:YES completion:nil];
        }
        if (!yesOrNo) {
            [vc.navigationController popToRootViewControllerAnimated:NO];
        }
        NSLog(@"topViewController = %@",vc);
    }else{
        if (vc.navigationController.visibleViewController) {
            [vc.navigationController.visibleViewController dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"visibleViewController = %@",vc.navigationController.visibleViewController);
        }
    }
}

@end
