//
//  LBSharedOrderM.h
//  GJieGo
//
//  Created by liubei on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"
#import "LBUserM.h"
#import "ShareActivityModel.h"

@interface LBSharedOrderM : LBBaseModel
/** 晒单编号 */
@property (nonatomic, assign) NSInteger Id;
/** 晒单标题 */
@property (nonatomic, copy) NSString *Title;
/** 晒单图片 */
@property (nonatomic, copy) NSString *image;
/** 点赞数 */
@property (nonatomic, assign) NSInteger Like;
/** 评论数 */
@property (nonatomic, assign) NSInteger Comment;
/** 阅读量 */
@property (nonatomic, assign) NSInteger ViewNum;
/** 创建时间 */
@property (nonatomic, assign) NSInteger CreateTime;
/** 用户信息 */
@property (nonatomic, strong) LBUserM *userM;
/** 晒单所属活动 */
@property (nonatomic, strong) ShareActivityModel *activityM;
@end
