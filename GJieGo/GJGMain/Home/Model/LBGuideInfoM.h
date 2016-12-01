//
//  LBGuideInfoM.h
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"
#import "LBGuideDetailM.h"
#import "ShareActivityModel.h"

@interface LBGuideInfoM : LBBaseModel

@property (nonatomic, assign) NSInteger InfoId;         // 信息编号
@property (nonatomic, copy) NSString *Content;          // 内容
@property (nonatomic, strong) NSArray *imgUrls;         // 图片, 以","号分隔
@property (nonatomic, strong) LBGuideDetailM *guider;   // 导购
@property (nonatomic, assign) NSInteger LikeNum;        // 点赞数
@property (nonatomic, assign) NSInteger CommentNum;     // 评论数
@property (nonatomic, assign) NSInteger ViewNum;        // 阅读量
@property (nonatomic, copy) NSString *Distance;         // 距离
@property (nonatomic, assign) CGFloat longitude;        // 经度
@property (nonatomic, assign) CGFloat latitude;         // 纬度
@property (nonatomic, copy) NSString *CreateTime;       // 发布时间
@property (nonatomic, assign) BOOL HasLike;             // 是否已经点过赞

/** 晒单所属活动, 导购里不应该有这个, 但是用到了导购的cell, 所以需要包装 */
@property (nonatomic, strong) ShareActivityModel *activityM;

@property (nonatomic, copy) NSString *statisticChat; // 进入私聊时候的对应数据埋点

@end