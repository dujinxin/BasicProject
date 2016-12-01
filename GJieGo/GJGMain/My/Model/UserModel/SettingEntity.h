//
//  SettingEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface SettingEntity : BasicEntity

@property (nonatomic,copy) NSString * InfoTitle;//标题
@property (nonatomic,copy) NSString * Url;//链接

@end

@interface NormalFAQEntity : SettingEntity

@property (nonatomic,copy) NSString * InfoId;//编号

@end


@interface SettingObj : DJXRequest

@end

@interface NormalFAQObj : DJXRequest

@end