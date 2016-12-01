//
//  LBGuideDetailM.h
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"

@interface LBGuideDetailM : LBBaseModel
/** 导购编号 */
@property (nonatomic, assign) NSInteger UserId;
/** 昵称 */
@property (nonatomic, copy) NSString *UserName;
/** 头像 */
@property (nonatomic, copy) NSString *HeadPortrait;
/** 关注数 */
@property (nonatomic, assign) NSInteger FollowNum;
/** 用户级别 */
@property (nonatomic, assign) NSInteger UserLevel;
/** 级别名称 */
@property (nonatomic, copy) NSString *UserLevelName;
/** 用户类型 */
@property (nonatomic, assign) NSInteger UserType;
/** 商铺编号 */
@property (nonatomic, assign) NSInteger ShopId;
/** 店铺名称 */
@property (nonatomic, copy) NSString *ShopName;
/** 店铺地址 */
@property (nonatomic, copy) NSString *ShopAddr;
/** 店铺类型 */
@property (nonatomic, copy) NSString *BusinessFormat;
/** 是否已关注【当用户为登录状态时才有可能为true】,目前只在导购详情页有效 */
@property (nonatomic, assign) BOOL HasFollow;
/** 环信聊天id */
@property (nonatomic, copy) NSString *ChatUser;
@end
