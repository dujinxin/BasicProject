//
//  UserEntity.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "BasicEntity.h"

@interface UserEntity : BasicEntity

@property (nonatomic,copy) NSString * Token;//短令牌 2小时时效
@property (nonatomic,copy) NSString * RefreshToken;//长令牌 一个月时效
@property (nonatomic,copy) NSString * PhoneNumber;
@property (nonatomic,copy) NSString * UserID;
@property (nonatomic,copy) NSString * UserName;
@property (nonatomic,copy) NSString * UserAge;
@property (nonatomic,copy) NSString * UserImage;
@property (nonatomic,copy) NSString * UserGender;//0男1女

@property (nonatomic,copy) NSString * HxAccount;
@property (nonatomic,copy) NSString * HxPassword;

@end


@interface UserTokenEntity : BasicEntity

@property (nonatomic,copy) NSString * Token;//短令牌 2小时时效
@property (nonatomic,copy) NSString * RefreshToken;//长令牌 一个月时效

@end


@interface UserDetailEntity : BasicEntity

@property (nonatomic,copy) NSString * UserId;
@property (nonatomic,copy) NSString * UserName;
@property (nonatomic,copy) NSString * HeadPortrait;
@property (nonatomic,strong) NSNumber * FollowNum;
@property (nonatomic,strong) NSNumber * UserLevel;
@property (nonatomic,copy) NSString * UserLevelName;
@property (nonatomic,strong) NSNumber * UserType;
@property (nonatomic,strong) NSNumber * HasFollow;




@end


@interface UserObj : DJXRequest

@end

@interface RefreshTokenObj : DJXRequest

@end

@interface UserTokenObj : DJXRequest

@end

@interface UserDetailObj : DJXRequest

@end

@interface UserNameObj : DJXRequest

@end

@interface UploadImageObj : DJXRequest
@property (nonatomic, copy) NSString *imagePath;
@end