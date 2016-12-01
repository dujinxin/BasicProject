//
//  BusinessTypeModel.h
//  GJieGo
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---获取商圈行业类别【吃货、。。】

#import "BaseModel.h"



@interface BusinessTypeItem : BaseModel
/*行业类别ID*/
@property (nonatomic, copy)NSString *DicID;
/*行业类别标记*/
@property (nonatomic, copy)NSString *DicKey;
/*行业类别名称*/
@property (nonatomic, copy)NSString *DicName;
/*行业类别图片*/
@property (nonatomic, copy)NSString *DicExt;
@end

@interface BusinessTypeModel : BaseModel
@property(nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger alerttype;
@property (nonatomic, strong)NSString *message;
@property (nonatomic, strong)NSMutableArray *Data;
@end