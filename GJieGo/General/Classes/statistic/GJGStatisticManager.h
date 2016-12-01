//
//  GJGStatisticManager.h
//  GJieGo
//
//  Created by gjg on 16/8/8.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsticUtil.h"

@interface GJGStatisticManager : NSObject

+ (instancetype)sharedManager;

- (void)upLoadToServer;
/**
 *  埋点的通用方法 事件ID 商圈ID 商场ID 店铺ID 业态类型 是必选参数  其他获取不到传nil
 *
 *  @param EventID      事件ID    参照埋单表
 *  @param BCID         商圈ID
 *  @param MallID       商场ID
 *  @param ShopID       店铺ID
 *  @param BusinessType 业态类型
 *  @param ItemID       热推文章ID|促销信息ID|晒单ID|发现文章ID等.....【操作的是那个对象就填哪个ID】
 *  @param ItemText     搜索关键字等文本信息
 *  @param OpUserID     操作对象用户ID，导购ID，晒单作者ID
 */
- (void)statisticByEventID:(NSString *)EventID andBCID:(NSString *)BCID andMallID:(NSString *)MallID andShopID:(NSString *)ShopID andBusinessType:(NSString *)BusinessType andItemID:(NSString *)ItemID andItemText:(NSString *)ItemText andOpUserID:(NSString *)OpUserID;

/**
 *  埋点的通用方法  增加 itemtype参数
 */

- (void)statisticByEventID:(NSString *)EventID andBCID:(NSString *)BCID andMallID:(NSString *)MallID andShopID:(NSString *)ShopID andItemType:(NSString *)ItemType andBusinessType:(NSString *)BusinessType andItemID:(NSString *)ItemID andItemText:(NSString *)ItemText andOpUserID:(NSString *)OpUserID;


@end
