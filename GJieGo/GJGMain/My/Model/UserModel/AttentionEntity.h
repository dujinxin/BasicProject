//
//  AttentionEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface AttentionEntity : BasicEntity

@property (nonatomic,copy) NSString * UserId;
@property (nonatomic,copy) NSString * UserName;
@property (nonatomic,copy) NSString * HeadPortrait;//头像
@property (nonatomic,copy) NSString * FollowNum;//关注
@property (nonatomic,copy) NSString * UserLevel;
@property (nonatomic,copy) NSString * UserLevelName;
@property (nonatomic,copy) NSString * UserType;//用户类型

@end

@interface AttentionGuiderEntity : AttentionEntity

@property (nonatomic,copy) NSString * ShopId;  //店铺ID
@property (nonatomic,copy) NSString * ShopName;//店铺名

@end


@interface AttentionObj : DJXRequest

@end

@interface AttentionGuiderObj : DJXRequest

@end
