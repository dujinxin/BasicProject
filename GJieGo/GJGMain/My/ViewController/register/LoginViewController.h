//
//  LoginViewController.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "BasicViewController.h"
#import "LoginUtil.h"

@interface LoginViewController : BasicViewController

@property (nonatomic, copy) CallBackBlock loginSuccessBlock;//登录成功
@property (nonatomic, copy) CallBackBlock loginCancelBlock;//取消与随便看看

@property (nonatomic, assign, getter=isLoginInfomationUnavailble)BOOL         loginInfomationUnavailble;                             //是否是因为非正常退出登录导致的登录弹出
@property (nonatomic, assign) UserLogoutType logoutType;

@end
