//
//  HomeApis.h
//  GJieGo
//
//  Created by liubei on 16/6/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#ifndef HomeApis_h
#define HomeApis_h

#import "GJGApiUrl.h"
#import "NetService.h"

#pragma mark - 公共请求
#define kApiGetOpenedCity           @"/City/GetOpenedCity"                  // 获取开放城市
#define kApiGetShareInfo            @"/UserInfo/GetShareInfo"               // 获取分享内容

#pragma mark - 雷达请求
#define kApiGetAroundInfo           @"/Radar/AroundInfo"                    // 获取雷达首页信息

#pragma mark - 促销请求
#define kApiGetPromotions           @"/SalesPromotion/GetPromotions"        // 查询促销信息
#define kApiGetPromotionDetails     @"/SalesPromotion/GetDetails"           // 促销信息详情

#define kApiGetPromotionComments    @"/SalesPromotion/GetComments"          // 获得促销评论
#define kApiAddPromotionComment     @"/SalesPromotion/AddComment"           // 发表评论及回复

#define kApiPromotionLike           @"/SalesPromotion/Like"                 // 点赞 - 促销
#define kApiPromotionUnLike         @"/SalesPromotion/UnLike"               // 取消点赞 - 促销

#pragma mark - 导购信息请求
#define kApiGetGuideType            @"/Shop/GetShopCollectionType"          // 导购信息类型(获取用户收藏店铺商品类型)
#define kApiGetGuideInfoDetails     @"/GuideInfo/GetDetails"                // 导购详情
#define kApiGetGuideSimple          @"/GuideInfo/GetGuideSimple"            // 导购简单信息
#define kApiGetPromotionsByGuide    @"/SalesPromotion/GetPromotionsByGuide" // 导购发布的促销信息
#define kApiFollowGuide             @"/UserInfo/FollowGuide"                // 关注导购

#pragma mark - 晒单请求
#define kApiGetUserShows            @"/UserShow/Index"                      // 首页晒单列表
#define kApiGetUserShowDetail       @"/UserShow/GetDetails"                 // 晒单详情

#define kApiGetUserShowComments     @"/UserShow/GetComments"                // 获得晒单评论
#define kApiAddUserShowComment      @"/UserShow/AddComment"                 // 发表评论及回复

#define kApiUserShowLike            @"/UserShow/Like"                       // 点赞 - 晒单
#define kApiUserShowUnLike          @"/UserShow/UnLike"                     // 取消点赞 - 晒单

#pragma mark - 用户信息请求
#define kApiGetUserDetail           @"/UserInfo/UserDetails"                // 查看用户详情
#define kApiGetUser_UserShows       @"/UserShow/User_UserShows"             // 查看指定用户的晒单
#define kApiFollowUser              @"/UserInfo/FollowUser"                 // 关注用户

#pragma mark - 搜索接口
#define kApiSearchTop               @"/Search/SearchTop"                    // 获取热门搜索
#define kApiSearchOften             @"/Search/SearchOften"                  // 获取常用搜索
#define kApiUserShowSearchSug       @"/Search/UserShowSearchSuggestion"     // 搜索晒单智能提示
#define kApiShopSearchSug           @"/Search/ShopSearchSuggestion"         // 搜索店铺智能提示
#define kApiUserShowSearch          @"/UserShow/Search"                     // 根据字段搜索晒单
#define kApiShopSearch              @"/Shop/GetShopByName"                  // 根据字段搜索店铺
#define kApiGetShopByType           @"/Shop/GetShopByType"                  // 根据类型搜索店铺

#pragma mark - 发布晒单
#define kApiAddUserShowAll          @"/userShow/AddUserShowAll"             // 一口气全部传完的接口
#define kApiGetHotActivity          @"/Activity/Index"                      // 获得热门活动
#define kApiGetSearchActivity       @"/Activity/SearchActivities"           // 搜索活动

#define kApiAddUserShow             @"/UserShow/AddUserShow"                // 添加晒单文字信息(发布晒单第一步)
#define kApiAddUserShowAddImage     @"/UserShow/AddImage"                   // 上传图片
#define kApiAddUserShowDelImage     @"/UserShow/DelImage"                   // 删除图片
#define kApiAddUserShowComplete     @"/UserShow/Complete"                   // 完成晒单
#define kApiAddUserShowGiveup       @"/UserShow/Giveup"                     // 放弃晒单

#pragma mark - Userdefault Key

#define kShopGuideClassfiUserDefaultKey @"kShopGuideClassfiUserDefaultKey"

#endif /* HomeApis_h */
