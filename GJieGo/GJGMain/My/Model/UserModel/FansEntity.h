//
//  FansEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface FansEntity : BasicEntity

@property (nonatomic,copy) NSString * UserID;//用户ID
@property (nonatomic,copy) NSString * UserName;//用户名称
@property (nonatomic,copy) NSString * UserImage;//头像
@property (nonatomic,copy) NSString * IsLiked;//是否已关注,0是1否
@property (nonatomic,copy) NSString * LikedNumber;//被关注数
@property (nonatomic,copy) NSString * Level;//等级
@property (nonatomic,copy) NSString * LevelName;//级别名称
@end

@interface FansObj : DJXRequest

@end


@interface FansNumberObj : DJXRequest

@end