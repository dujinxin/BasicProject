//
//  GJGPushManager.m
//  GJieGo
//
//  Created by liubei on 16/7/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGPushManager.h"
@class GJGMsg_content;

@implementation GJGPushManager
static id _instance;

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}

/*
 *  处理接收到的推送消息
 */
- (void)handlerUserInfo:(NSDictionary *)userInfo {
    
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        if ([[userInfo objectForKey:@"msg_content"] isKindOfClass:[NSDictionary class]]) {
            GJGMsg_content *pushMsg = [GJGMsg_content modelWithDict:[userInfo objectForKey:@"msg_content"]];
            [self handlePushMsg:pushMsg];
        }
    }
}

- (void)handlePushMsg:(GJGMsg_content *)pushMsg {
    
    switch (pushMsg.NoteType) {
        case GJGPushMsgTypeIsNewFans:
            
            break;
        case GJGPushMsgTypeIsNewLike:
            
            break;
        case GJGPushMsgTypeIsNewComment:
            
            break;
        case GJGPushMsgTypeIsNewShare:
            
            break;
        case GJGPushMsgTypeIsNewReply:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 新的粉丝
- (void)iHaveNewFans:(GJGMsg_content *)pushMsg {
    
}

#pragma mark - 新的赞
- (void)iHaveNewLike:(GJGMsg_content *)pushMsg {
    
}

#pragma mark - 新的评论
- (void)iHaveNewComment:(GJGMsg_content *)pushMsg {
    
}

#pragma mark - 新的分享
- (void)iHaveNewShare:(GJGMsg_content *)pushMsg {
    
}

#pragma mark - 新的回复
- (void)iHaveNewReply:(GJGMsg_content *)pushMsg {
    
}

@end



@implementation GJGMsg_content

@end