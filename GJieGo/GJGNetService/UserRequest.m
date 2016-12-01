//
//  UserRequest.m
//  SrbProject
//
//  Created by dujinxin on 16/4/5.
//  Copyright © 2016年 SuRuiBo. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest

static UserRequest * manager;
+ (UserRequest *)shareManager{
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
/*
 * @param 注册、登录
 */
- (void)userRegister:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)userLogin:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [UserObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userExit:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)userModifyPassword:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
/*
 * @param token
 */
- (void)userLongToken:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [RefreshTokenObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userShortToken:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [UserTokenObj requestWithBlock:url param:param success:success failure:failure];
}
/*
 * @param 个人信息修改
 */
- (void)userName:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)userGender:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)userImage:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [UploadImageObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userImage:(NSString *)url param:(NSDictionary *)param delegate:(id)delegate{
    [UploadImageObj requestWithDelegate:delegate nApiTag:0 url:url param:param];
}
- (void)userName:(NSString *)url param:(NSDictionary *)param delegate:(id)delegate{
    [UserNameObj requestWithDelegate:delegate nApiTag:0 url:url param:param];
}
/*
 * @param 验证码
 */
- (void)sendValiCode:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)checkValiCode:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
/*
 *@param 用户详情
 */
- (void)userDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [UserDetailObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure showLoadView:(UIView *)view animated:(BOOL)animated{
    [UserDetailObj requestWithBlock:url param:param success:success failure:failure showInView:view animated:animated loadText:@"Loading"];
}
/*
 * @param 关注
 */
- (void)userGuiderAttentionList:(NSString *)url param:(NSDictionary *)param type:(UserType)type success:(completion)success failure:(completion)failure{
    if (type == Guider) {
        [AttentionGuiderObj requestWithBlock:url param:param success:success failure:failure];
    }else{
        [AttentionObj requestWithBlock:url param:param success:success failure:failure];
    }
}
//- (void)guiderAttentionList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
//    [AttentionGuiderObj requestWithBlock:url param:param success:success failure:failure];
//}

- (void)userAttented:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)guiderAttented:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    
}

/*
 * @param 粉丝
 */
- (void)userFansList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [FansObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
/*
 * @param 订单
 */
- (void)userOrderList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [OrderObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
- (void)userOrderDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [OrderDetailObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
/*
 * @param 收藏
 */
- (void)shopCollectionList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [CollectionObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
- (void)shopCollectionCategory:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [CategoryObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
/*
 * @param 优惠券
 */
- (void)shopCouponList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [CouponShopObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
- (void)userCouponList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [CouponObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
- (void)couponDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [CouponDetailObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
/*
 * @param 记录
 */
- (void)recordDistrubutionCommentUserList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [RecordObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
//- (void)recordCommentUserList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
//    [RecordObj requestWithBlock:url param:param success:success failure:failure];
//}
- (void)recordCommentGuiderList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [RecordGuiderObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
/*
 *@param 等级与成长值
 */
- (void)userLevelList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [LevelObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userTaskList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [TaskObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userLevel:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [UserLevelObj requestWithBlock:url param:param success:success failure:failure];
}
/*
 *@param 通知
 */
- (void)userNotificationList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [NotificationObj requestWithBlock:url param:param success:success failure:failure];
}
- (void)userNotificationState:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)userNotificationNews:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
- (void)userNotificationSubNews:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure];
}
/*
 *@param 设置
 */
- (void)userFeedback:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [DJXRequest requestWithBlock:url param:param success:success failure:failure showInView:nil animated:YES loadText:@"Submit"];
}
- (void)userAboutUs:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [SettingObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}
- (void)userNormalFAQ:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure{
    [NormalFAQObj requestWithBlock:url param:param success:success failure:failure animated:YES];
}


/*
 *@param 广告页
 */
- (void)getADView:(NSString*)url success:(completion)success failure:(completion)failure{
    [ADObj requestWithBlock:url param:nil success:success failure:failure];
}

@end
