//
//  NotificationUtil.h
//  GJieGo
//
//  Created by dujinxin on 16/11/1.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotificationUtilDelegate <NSObject>

- (void)handleReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)calculateNotificationNumber:(NSString *)from notification:(NSDictionary *)userInfo;

- (void)handleChatMessages:(NSDictionary *)userInfo;

- (void)handleOtherNotification:(NSDictionary *)userInfo;
@end
