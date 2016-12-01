//
//  AppDelegate+EaseMobDebug.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (EaseMobDebug)

/*!
 *  @brief 判断是否开启了测试模式，本类以及本方法开发者不需要集成使用，直接调用registerSDKWithAppKey:apnsCertName:otherConfig即可
 *  @return 返回结果
 *  @remark 本类以及本方法开发者不需要集成使用
 */
-(BOOL)isSpecifyServer;

@end
