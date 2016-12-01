//
//  LoginManager.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "LoginUtil.h"
#import "UserDBManager.h"

@interface LoginManager : NSObject<LoginUtilDelegate>

+ (LoginManager *)shareManager;

@end
