//
//  LBSharedOrderDetailM.h
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"
@class LBUserM;
@class ShareActivityModel;
@class LBGuideInfoM;

@interface LBSharedOrderDetailM : LBBaseModel
/** 晒单编号 */
@property (nonatomic, assign) NSInteger Id;
/** 晒单图片数组 */
@property (nonatomic, strong) NSArray *Images;
/** 产品名称 */
@property (nonatomic, copy) NSString *ProductName;
/** 购买地 */
@property (nonatomic, copy) NSString *BuyFrom;
/** 品牌 */
@property (nonatomic, copy) NSString *Brand;
/** 价格 */
@property (nonatomic, copy) NSString *Price;
/** 晒单内容 */
@property (nonatomic, copy) NSString *Description;
/** 点赞数 */
@property (nonatomic, assign) NSInteger Like;
/** 评论数 */
@property (nonatomic, assign) NSInteger Comment;
/** 阅读量 */
@property (nonatomic, assign) NSInteger ViewNum;
/** 发表时间 */
@property (nonatomic, copy) NSString *CreateTime;
/** 用户信息 */
@property (nonatomic, strong) LBUserM *userM;
/** 是否已经点过赞(只有在用户登录并且是查看晒单详情时才有效) */
@property (nonatomic, assign) BOOL HasLike;
/** 活动 */
@property (nonatomic, strong) ShareActivityModel *activityM;

/** 将晒单数据模型包装成导购数据模型，为了给导购配套的Cell */
@property (nonatomic, strong) LBGuideInfoM *guideInfo;
@end
