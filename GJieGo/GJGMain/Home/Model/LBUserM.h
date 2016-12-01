//
//  LBUserM.h
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"

@interface LBUserM : LBBaseModel
/** 用户编号 */
@property (nonatomic, assign) NSInteger UserId;
/** 昵称 */
@property (nonatomic, copy) NSString *UserName;
/** 头像 */
@property (nonatomic, copy) NSString *HeadPortrait;
/** 关注人数 */
@property (nonatomic, assign) NSInteger FollowNum;
/** 级别 */
@property (nonatomic, assign) NSInteger UserLevel;
/** 级别名称 */
@property (nonatomic, copy) NSString *UserLevelName;
/** 用户类型, 1 == 用户, 2 == 导购 */
@property (nonatomic, assign) NSInteger UserType;
/** 我是否已关注【当用户为登录状态时才有可能为true】,目前只在用户详情页有效 */
@property (nonatomic, assign) BOOL HasFollow;
@end
