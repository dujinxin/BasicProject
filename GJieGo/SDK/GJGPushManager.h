//
//  GJGPushManager.h
//  GJieGo
//
//  Created by liubei on 16/7/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGPushManager : NSObject
+ (instancetype)sharedManager;
/** 处理推送消息 */
- (void)handlerUserInfo:(NSDictionary *)userInfo;
@end




#pragma mark - 推送消息体模型

typedef enum {
    
    GJGPushMsgUserTypeIsUser = 1,
    GJGPushMsgUserTypeIsGuider = 2

}GJGPushMsgUserType;

/** 通知消息分类 */
typedef enum {
    
    GJGPushMsgTypeIsNewFans = 1,        //1	新的粉丝
    GJGPushMsgTypeIsNewLike = 2,        //2	新的赞
    GJGPushMsgTypeIsNewComment = 3,     //3	新的评论
    GJGPushMsgTypeIsNewShare = 4,       //4	新的分享
    GJGPushMsgTypeIsNewReply = 5        //5	新的回复
    
}GJGPushMsgType;

/** 通知关联信息的类型 */
typedef enum {
    
    GJGPushInfoTypeIsNone = 0,          //0	没有关联信息
    GJGPushInfoTypeIsShareOrder = 1,    //1	关联晒单信息
    GJGPushInfoTypeIsPromotion = 2,     //2	关联促销信息
    GJGPushInfoTypeIsShop = 3           //3	关联商铺信息
    
}GJGPushInfoType;

@interface GJGMsg_content : LBBaseModel
/** 触发通知的用户Id */
@property (nonatomic, assign) NSInteger UserId;
/** 触发通知的用户类型 */
@property (nonatomic, assign) GJGPushMsgUserType UserType;
/** 通知消息分类 */
@property (nonatomic, assign) GJGPushMsgType NoteType;
/** 通知关联的信息编号 */
@property (nonatomic, assign) NSInteger InfoId;
/** 通知关联信息的类型 */
@property (nonatomic, assign) GJGPushInfoType InfoType;
/** 通知消息内容 */
@property (nonatomic, copy) NSString *Message;
/** 发出通知的时间 */
@property (nonatomic, assign) NSInteger AddTime;
@end