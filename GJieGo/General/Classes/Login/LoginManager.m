//
//  LoginManager.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "LoginManager.h"

@interface LoginManager (){
    UIWindow * _bgWindow;
}

@property (nonatomic, strong)UIWindow * bgWindow;

@end

@implementation LoginManager

static LoginManager * manager = nil;
+(LoginManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoginManager alloc]init ];
    });
    return manager;
}
- (BOOL)checkUserLoginState:(void(^)())completion{
    BOOL isLogin = [[LoginManager shareManager] isHadLogin];
    if (isLogin) {
        if (completion) {
            completion();
        }
    }else{
        [[LoginManager shareManager] login];
    }
    return isLogin;
}
- (void)presentLoginViewController:(BOOL)animated loginSuccess:(void (^)(id object))loginCompletion cancel:(void (^)(id object))cancelCompletion{
    [self presentLoginViewController:animated logoutType:kUserLogoutDefault loginSuccess:loginCompletion cancel:cancelCompletion];
}
- (void)presentLoginViewController:(BOOL)animated logoutType:(UserLogoutType)type loginSuccess:(void (^)(id object))loginCompletion cancel:(void (^)(id object))cancelCompletion{
    LoginViewController * login = [[LoginViewController alloc] init];
    UINavigationController * loginNVC = [[UINavigationController alloc] initWithRootViewController:login];
    login.loginInfomationUnavailble = YES;
    login.logoutType = type;
    login.loginCancelBlock = [cancelCompletion copy];
    login.loginSuccessBlock = [loginCompletion copy];
    
    
    AppDelegate * appDelegate = [AppDelegate appDelegate];
    UINavigationController * nvc = appDelegate.tabBarController.selectedViewController;
    if (nvc.viewControllers.count >0) {
        UIViewController * vc = nvc.topViewController;
        [vc presentViewController:loginNVC animated:YES completion:nil];
    }
}
- (BOOL)isHadLogin{
    BOOL isHadLogin = YES;
    if ([UserDBManager shareManager].PhoneNumber && [UserDBManager shareManager].PhoneNumber.length) {
        isHadLogin = YES;
    }else{
        isHadLogin = NO;
    }
    return isHadLogin;
}
- (void)login{
    
    LoginViewController * login = [[LoginViewController alloc] init];
    UINavigationController * loginNVC = [[UINavigationController alloc] initWithRootViewController:login];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNVC animated:YES completion:nil];
    
}
- (void)logOut{
    [[UserDBManager shareManager] clearUserInfo];
}
@end
