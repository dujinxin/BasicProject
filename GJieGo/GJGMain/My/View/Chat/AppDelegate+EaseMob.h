//
//  AppDelegate+EaseMob.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig;

@end
