//
//  LBMsgM.h
//  GJieGo
//
//  Created by liubei on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"
#import "LBUserM.h"

@interface LBMsgM : LBBaseModel
/** 晒单编号 */
@property (nonatomic, assign) NSInteger InfoId;
/** 评论编号 */
@property (nonatomic, assign) NSInteger CommentId;
/** 发表评论的用户 */
@property (nonatomic, strong) LBUserM *user;
/** 评论内容 */
@property (nonatomic, copy) NSString *Content;
/** 评论时间 */
@property (nonatomic, copy) NSString *CreateTime;
/** 获取时的时间戳 */
@property (nonatomic, copy) NSString *CreateTimeOld;
/** 回复的评论编号 */
@property (nonatomic, assign) NSInteger ReplyId;
/** 被回复的用户编号 */
@property (nonatomic, assign) NSInteger BeRepliedUserId;
/** 被回复的用户昵称 */
@property (nonatomic, copy) NSString *BeRepliedUserName;
@end
