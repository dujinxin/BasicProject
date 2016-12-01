//
//  ChatManager.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "DBManager.h"
#import "ChattingUtil.h"

#define     ChatDBName      @"ChatManager"

UIKIT_EXTERN NSString *const HasUnreadChatMessagesNotification;

@interface ChatManager : DBManager<ChattingUtilDelegate>

@property (nonatomic,strong) UserProfileEntity *userProfileEntity;
@property (nonatomic,strong) NSString  * conversationId;

+(ChatManager *)shareManager;


@end

@interface UserProfileEntity: BasicEntity

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userImage;

@end

@interface UserProfileObj : DJXRequest

@end
