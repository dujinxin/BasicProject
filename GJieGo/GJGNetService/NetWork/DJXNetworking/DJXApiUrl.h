//
//  DJXApiUrl.h
//  FJ_Project
//
//  Created by dujinxin on 15/10/21.
//  Copyright © 2015年 BLW. All rights reserved.
//

#ifndef DJXApiUrl_h
#define DJXApiUrl_h


#pragma mark ------------basic------------

#define kRequestUrl(s)  [NSString stringWithFormat:@"%@%@?user_skey=%@",kHostUrl,s,kUser_skey]
#define kReqeustHtmlUrl(s) [NSString stringWithFormat:@"%@%@",kHostUrl,s]

#define kHostTest            @"http://dev.appapi.rciba.com/"
#define kHostProduct         @"http://124.202.155.218/"

#pragma mark ------------Html------------

#define kSpeedEntry          @"v1/web/navigation"   /*快速通道*/
#define kMy                  @"v1/web/my_page"      /*我的界面*/
#define kGoodsDetail         @"v1/web/goods_info"   /*商品详情*/
#define kDMDetail            @"v1/web/dm_info"      /*促销详情*/
#define kOrderDetailWeb      @"v1/web/order_info"   /*订单详情*/
#define kDeliveryDetail      @"v1/web/order_tracking"/*订单跟踪*/

#define kWebInfo             @"v1/web/html_content_show"/*详情、说明*/
#define kWebAboutProduct     @"v1/web/about_our_product"/*关于产品*/

#pragma mark ------------Html-URL------------
// 商品详情
#define kWebGoodsDetailUrl(bu_goods_id)  [NSString stringWithFormat:@"%@%@?no=%@&session_id=%@&region_id=%@",kHostUrl,kGoodsDetail,bu_goods_id,[UserInfo shareManager].session_id,[UserInfo shareManager].region_id]
// 促销详情
#define kWebDMUrl(dm_id)  [NSString stringWithFormat:@"%@%@?dm_id=%@&session_id=%@&region_id=%@",kHostUrl,kDMDetail,dm_id,[UserInfo shareManager].session_id,[UserInfo shareManager].region_id]
// 订单详情
#define kWebOrderDetailUrl(order_list_id)  [NSString stringWithFormat:@"%@%@?order_list_id=%@&session_id=%@&region_id=%@",kHostUrl,kOrderDetailWeb,order_list_id,[UserInfo shareManager].session_id,[UserInfo shareManager].region_id]
// 配送详情
#define kWebDeliveryDetailUrl(order_list_no)  [NSString stringWithFormat:@"%@%@?order_list_no=%@&session_id=%@&region_id=%@",kHostUrl,kDeliveryDetail,order_list_no,[UserInfo shareManager].session_id,[UserInfo shareManager].region_id]

#define kWebInfoURLWithType(type) [NSString stringWithFormat:@"%@%@?type=%@",kHostUrl,kWebInfo,type]
//
#define kWebInfoURLAboutProduct(version) [NSString stringWithFormat:@"%@%@?version=%@",kHostUrl,kWebAboutProduct,version]


#pragma mark ------------main------------

#define kNearStore           @"region/getNearStore" /*获取最近门店*/
#define kUserIsRegister      @"user/isregister"     /*用户是否注册*/
#define kGetCaptcha          @"message/captcha"     /*获取验证码*/
#define kSalt                @"user/getsalt"        /*获取登录信息*/
#define kUserLogin           @"user/login"          /*用户登陆*/

#define kAddressAdd          @"order/address/add"   /*新增地址*/
#define kAddressList         @"order/address/list"  /*地址列表*/
#define kAddressDelete       @"order/address/del"   /*删除地址*/
#define kAddressUpdate       @"order/address/update"/*修改地址*/

#define kShakeList           @"shake/activityList"  /*摇一摇活动*/
#define kShakeResult         @"shake"               /*摇一摇结果*/
#define kShakeInfo           @"shake/info"          /*摇一摇信息*/
#define kShakePrize          @"shake/prizeInfo"     /*摇一摇奖品*/


#define kUserInfo            @"v1/user/info"        /*用户信息*/
#define kUserModifyInfo      @"v1/user/edit_info"   /*修改用户信息*/
#define kUserModifyPassword  @"v1/user/edit_password"/*重置密码*/
#define kUserUploadImage     @"v1/file_upload/image"/*上传图片*/

#define kUserThirdLogin      @"v1/open/platform/login"/*第三方登录检测*/
#define kUserThirdBind       @"v1/open/platform/bind"/*第三方登录绑定*/


#endif /* DJXApiUrl_h */
