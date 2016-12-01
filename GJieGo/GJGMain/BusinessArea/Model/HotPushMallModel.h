//
//  HotPushMallModel.h
//  GJieGo
//
//  Created by apple on 16/6/4.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---4.10.1	获取商场下所有热推   4.10.2	获取店铺下热推

#import "BaseModel.h"

@interface HotPushMallModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end

@interface HotPushMallItem : BaseModel
/*热推ID*/
@property (nonatomic, assign)NSInteger ID;
/*创建时间*/
@property (nonatomic, copy)NSString *createDate;
/*点赞数*/
@property (nonatomic, assign)NSInteger LikeNum;
/*热推名称*/
@property (nonatomic, copy)NSString *Name;
/*热推图片*/
@property (nonatomic, copy)NSString *Images;
/*店铺名称*/
@property (nonatomic, copy)NSString *shopName;
/*所属店铺业态*/
@property (nonatomic, copy)NSString *TypeKey;
/*浏览量*/
@property (nonatomic, assign)NSInteger ViewCount;
@end
