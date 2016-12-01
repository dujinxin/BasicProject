//
//  LBRequestManager.h
//  GJieGo
//
//  Created by liubei on 16/7/1.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GJGShareInfo;

typedef enum {

    GJGShareInfoTypeIsShareOrder = 1,   //1	晒单分享
    GJGShareInfoTypeIsGuideInfo = 2,    //2	促销分享
    GJGShareInfoTypeIsHot = 3,          //3	热推分享
    GJGShareInfoTypeIsShopHome = 4,     //4	商铺首页分享
    GJGShareInfoTypeIsCoupon = 5,       //5	优惠券分享
    GJGShareInfoTypeIsFind = 6,         //6	发现分享
    GJGShareInfoTypeIsGuiderDetail = 7, //7	导购详情分享
    GJGShareInfoTypeIsUserDetail = 8,   //8	用户详情分享
    GJGShareInfoTypeIsInvitation = 9,   //9 邀请
    GJGShareInfoTypeIsMallHome = 10,    //10 商场、购物中心等首页分享
    GJGShareInfoTypeIsActivity = 11     //11 晒单活动分享
    
}GJGShareInfoType;

typedef void(^ResultBlock)(id responseobject,NSError *error);

@interface LBRequestManager : NSObject

+ (instancetype)sharedManager;

/*
 *  @pragma 获取分享内容方法
 */
- (void)getSharedInfoWithInfoId:(NSInteger)infoId infoType:(GJGShareInfoType)type result:(ResultBlock)resultBlock;

@end


#import "LBBaseModel.h"
@interface GJGShareInfo : LBBaseModel

@property (nonatomic, assign) NSInteger InfoId;     // 分享数据的编号(晒单编号, 导购编号, 促销信息编号等)
@property (nonatomic, copy) NSString *Title;        // 分享标题
@property (nonatomic, copy) NSString *Content;      // 分享内容
@property (nonatomic, copy) NSString *Images;       // 图片
@property (nonatomic, copy) NSString *Url;          // 链接地址

@end