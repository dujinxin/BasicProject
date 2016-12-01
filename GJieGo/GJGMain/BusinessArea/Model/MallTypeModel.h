//
//  MallTypeModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取某业态类型下商场列表

#import "BaseModel.h"

@interface MallTypeModel : BaseModel
@property (nonatomic, copy)NSString *TypeName;
@property (nonatomic, assign)NSInteger TypeID;
@property (nonatomic, strong)NSMutableArray *MallList;
@end

@interface MallTypeItem : BaseModel
@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, copy)NSString *Name;
@property (nonatomic, copy)NSString *Image;
@property (nonatomic, assign)NSInteger Distance;
@property (nonatomic, copy)NSString *BusinessHour;
@end