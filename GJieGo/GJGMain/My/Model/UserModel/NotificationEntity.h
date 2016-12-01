//
//  NotificationEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/9/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface NotificationEntity : BasicEntity

@property (nonatomic,copy) NSString * UserId;
@property (nonatomic,copy) NSString * UserType;
@property (nonatomic,strong) NSNumber * NoteType;
@property (nonatomic,copy) NSString * InfoId;
@property (nonatomic,copy) NSString * Infotype;
@property (nonatomic,copy) NSString * Message;
@property (nonatomic,copy) NSString * AddTime;
@property (nonatomic,copy) NSString * HeadPortrait;
@property (nonatomic,copy) NSString * NoticeId;
@property (nonatomic,copy) NSString * ReadState;

@end

@interface NotificationObj : DJXRequest

@end