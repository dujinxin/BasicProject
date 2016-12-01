//
//  HotPushDetailsModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.10.3	获取热推详情

#import "BaseModel.h"

@interface HotPushDetailsItem : BaseModel
/*热推ID*/
@property (nonatomic, assign)NSInteger ID;
/*热推名称*/
@property (nonatomic, copy)NSString *Name;
/*热推图片*/
@property (nonatomic, copy)NSString *Images;
/*创建时间*/
@property (nonatomic, copy)NSString *createDate;
/*点赞数*/
@property (nonatomic, assign)NSInteger LikeNum;
/*热推内容*/
@property (nonatomic, copy)NSString *Description;
/*当前用户是否对该热推点赞*/
@property (nonatomic, assign)BOOL HasLike;
@end

@interface HotPushDetailsModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSDictionary *Data;

@end

