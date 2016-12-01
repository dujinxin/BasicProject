//
//  MallHomeInfoModel.h
//  GJieGo
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 yangzx. All rights reserved.
//  4.7.5	获取商场首页信息

#import "BaseModel.h"

@interface MallHomeInfoModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, strong)NSDictionary *Data;
@end

@interface MallHomeInfoItem : BaseModel
/*商场ID*/
@property (nonatomic, assign)NSInteger MallID;
/*名称*/
@property (nonatomic, copy)NSString *MallName;
/*图片*/
@property (nonatomic, copy)NSString *MallImage;
/*距离*/
@property (nonatomic, copy)NSString *Distance;
/*是否已收藏*/
@property (nonatomic, assign)NSInteger IsCollected;
/*经度*/
@property (nonatomic, assign)float Longitude;
/*纬度*/
@property (nonatomic, assign)float Latitude;
/*商场地址*/
@property (nonatomic, copy)NSString *MallAddress;
@end


@interface ShopHomeInfoItem : BaseModel
/*商场ID*/
@property (nonatomic, assign)NSInteger ShopID;
/*名称*/
@property (nonatomic, copy)NSString *ShopName;
/*图片*/
@property (nonatomic, copy)NSString *ShopImage;
/*距离*/
@property (nonatomic, copy)NSString *Distance;
/*是否已收藏*/
@property (nonatomic, assign)BOOL IsCollected;
/*经度*/
@property (nonatomic, assign)float Longitude;
/*纬度*/
@property (nonatomic, assign)float Latitude;
/*商场地址*/
@property (nonatomic, copy)NSString *ShopAddress;
@end