//
//  MallBCModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取商圈下商场（商圈首页）   获取某业态类型下商场列表

#import "BaseModel.h"


@interface MallBCListItem : BaseModel
/*商场ID*/
@property (nonatomic, assign)NSInteger ID;
/*商场名称*/
@property (nonatomic, copy)NSString *Name;
/*商场图片*/
@property (nonatomic, copy)NSString *Image;
/*距离*/
@property (nonatomic, copy)NSString * Distance;
/*营业时间*/
@property (nonatomic, copy)NSString *BusinessHours;
@end

@interface MallBCItem : BaseModel
/*商场类别名称*/
@property (nonatomic, copy)NSString *TypeName;
/*商场类别ID*/
@property (nonatomic, assign)NSInteger TypeID;
/*商场业态类型*/
@property (nonatomic, copy) NSString *TypeKey;
/*商场列表 */
@property (nonatomic, strong)NSMutableArray *MallList;
@end


@interface MallBCModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;

@end