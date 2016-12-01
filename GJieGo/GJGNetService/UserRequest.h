//
//  UserRequest.h
//  SrbProject
//
//  Created by dujinxin on 16/4/5.
//  Copyright © 2016年 SuRuiBo. All rights reserved.
//

#import "DJXRequest.h"

#import "UserEntity.h"

#import "AttentionEntity.h"
#import "FansEntity.h"

#import "OrderEntity.h"
#import "CollectionEntity.h"
#import "CouponEntity.h"
#import "RecordEntity.h"
#import "LevelEntity.h"
#import "SettingEntity.h"
#import "NotificationEntity.h"
#import "ADViewEntity.h"

/*
 *@param 注册登录
 */
#define kApiUserRegiser  @"/UserLogin/Register"        /*用户注册*/
#define kApiUserLogin    @"/UserLogin/Login"           /*用户登录*/
#define kApiUserExit     @"/UserLogin/Exit"            /*用户退出*/
#define kApiUserResetPassword  @"/UserLogin/ResetPassword" /*修改、忘记密码*/
/*
 *@param token
 */
#define kApiUserLongToken  @"/UserLogin/RefreshToken"  /*刷新令牌时长*/
#define kApiUserShortToken @"/UserLogin/GetTokenByKey" /*获取游客令牌*/
/*
 *@param 修改个人信息
 */
#define kApiUserName     @"/UserInfo/UpdateUserName"  /*用户更改名字*/
#define kApiUserGender   @"/UserInfo/UpdateUserGender"/*用户更改性别*/
#define kApiUserImage    @"/UserInfo/UpdateUserImage" /*用户更改头像*/
/*
 *@param 验证码
 */
#define kApiUserSendValiCode  @"/UserLogin/SendValiCode"   /*发送验证码*/
#define kApiUserCheckValiCode @"/UserLogin/CheckValiCode"  /*验证验证码*/

#define kApiUserSendValiCodeL  @"/UserLogin/SendValiCodeL"  /*发送验证码*/
#define kApiUserCheckValiCodeL @"/UserLogin/CheckValiCodeL" /*验证验证码*/
/*
 *@param 用户详情
 */
#define kApiUserDetail   @"/UserInfo/UserDetails"      /*用户详情*/
/*
 *@param 关注
 */
#define kApiUserAttentionList  @"/UserInfo/GetFollowedUsers"  /*关注的用户*/
#define kApiGuideAttentionList @"/UserInfo/GetFollowedGuides" /*关注的导购*/
#define kApiUserAttented       @"/UserInfo/FollowUser"        /*关注用户*/
#define kApiGuiderAttented     @"/UserInfo/FollowUser"        /*关注导购*/
/*
 *@param 粉丝
 */
#define kApiUserFansList       @"/UserInfo/GetUserFans"       /*我的粉丝*/
#define kApiUserFansNumber     @"/UserInfo/GetUserFansMessage"/*粉丝数量*/
/*
 *@param 订单
 */
#define kApiUserOrderList      @"/Order/GetOrderByUser"       /*订单列表*/
#define kApiUserOrderDetail    @"/Order/GetOrderDetails"      /*订单详情*/
/*
 *@param 优惠券
 */
#define kApiShopCouponList     @"/Coupon/GetCouponByShop"     /*店铺可用优惠券列表*/
#define kApiUserCouponList     @"/Coupon/GetCouponByUser"     /*优惠券列表*/
#define kApiCouponDetail       @"/Coupon/GetCouponDetail"     /*优惠券详情*/
/*
 *@param 收藏
 */
#define kApiShopCollectionList @"/Shop/GetShopByUser"         /*店铺收藏列表*/
#define kApiShopCollectionCategory @"/Shop/GetShopCollectionType" /*店铺收藏分类筛选*/
/*
 *@param 记录
 */
#define kApiDistrubutionList   @"/UserInfo/MyUserShows"          /*我发布的列表*/
#define kApiCommentUserList    @"/UserInfo/MyCommentedUserShows" /*我评论的用户列表*/
#define kApiCommentGuiderList  @"/UserInfo/MyCommentedPromotions"/*我评论的导购列表*/
#define kApiDistrubutionDelete @"/UserShow/DelUserShow"          /*晒单删除*/
/*
 *@param 等级与成长值
 */
#define kApiLevelList          @"/Growth/GetLevels"            /*等级列表*/
#define kApiTaskList           @"/Growth/GetOnceTasks"         /*任务列表*/
#define kApiUserLevel          @"/Growth/GetUserPoint"         /*我的成长值*/
/*
 *@param 通知
 */
#define kApiNotificationList   @"/UserInfo/GetNoticeByType"    /*通知列表*/
#define kApiNotificationState  @"/UserInfo/ReadNotice"         /*是否已读*/
#define kApiNotificationNews   @"/UserInfo/HasNewNotice"       /*是否有新通知*/
#define kApiNotificationSubNews  @"/UserInfo/GetNewNoticeTypes"/*子类有新通知*/
/*
 *@param 设置
 */
#define kApiFeedback           @"/CommonInfo/AddSuggestionForUs" /*意见反馈*/
#define kApiAboutUs            @"/AboutUs/GetAboutUsList"        /*关于我们*/
#define kApiNormalFAQ          @"/FAQ/GetFAQs"                   /*常见问题*/
#define kApiCheckVersion       @"/Version/CheckUpdate"           /*版本更新*/


#define kApiShareInfo          @"/UserInfo/GetShareInfo"         /*分享内容*/
#define kApiShareSuccess       @"/UserInfo/SaveShare"            /*分享成功->记录*/

#define kApiInvite             @"/UserLogin/Invite"              /*提交邀请*/
#define kApiInvitation         @"/UserInfo/GetInvitedInfo"       /*邀请信息*/
#define kApiInvitationCode     @"/UserInfo/GetInvitedCode"       /*邀请码*/

/*
 *@param 广告页面
 */
#define kAD                    @"/StartAD/GetStartAD" /*广告页*/


typedef void(^completion)(id object,NSString *msg);

@interface UserRequest : NSObject

+ (UserRequest *)shareManager;
/*
 * @param 注册、登录
 */
- (void)userRegister:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;//注册
- (void)userLogin:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userExit:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userModifyPassword:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;//忘记密码，修改密码公用
/*
 * @param token
 */
- (void)userLongToken:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userShortToken:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 * @param 个人信息修改
 */
- (void)userName:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userGender:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userImage:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userImage:(NSString *)url param:(NSDictionary *)param delegate:(id)delegate;
- (void)userName:(NSString *)url param:(NSDictionary *)param delegate:(id)delegate;
/*
 * @param 验证码
 */
- (void)sendValiCode:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)checkValiCode:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 *@param 用户详情
 */
- (void)userDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure showLoadView:(UIView *)view animated:(BOOL)animated;
/*
 * @param 关注
 */
- (void)userGuiderAttentionList:(NSString *)url param:(NSDictionary *)param type:(UserType)type success:(completion)success failure:(completion)failure;
//- (void)guiderAttentionList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;

- (void)userAttented:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)guiderAttented:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;

/*
 * @param 粉丝
 */
- (void)userFansList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 * @param 订单
 */
- (void)userOrderList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userOrderDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 * @param 优惠券
 */
- (void)shopCouponList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userCouponList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)couponDetail:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 * @param 收藏
 */
- (void)shopCollectionList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)shopCollectionCategory:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 * @param 记录
 */
- (void)recordDistrubutionCommentUserList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
//- (void)recordCommentUserList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)recordCommentGuiderList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 *@param 等级与成长值
 */
- (void)userLevelList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userTaskList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userLevel:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 *@param 通知
 */
- (void)userNotificationList:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userNotificationState:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userNotificationNews:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userNotificationSubNews:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 *@param 设置
 */
- (void)userFeedback:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userAboutUs:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
- (void)userNormalFAQ:(NSString *)url param:(NSDictionary *)param success:(completion)success failure:(completion)failure;
/*
 *@param 广告页
 */
- (void)getADView:(NSString*)url success:(completion)success failure:(completion)failure;





@end
