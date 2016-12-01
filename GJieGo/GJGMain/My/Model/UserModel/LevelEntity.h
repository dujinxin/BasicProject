//
//  LevelEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface LevelEntity : BasicEntity

@property (nonatomic,copy) NSString * LevelId;//级别编号
@property (nonatomic,copy) NSString * Points;//级别要求点数
@property (nonatomic,copy) NSString * LevelName;//级别名称


@end

@interface TaskEntity : BasicEntity

@property (nonatomic,copy) NSString * TaskType;//任务类型编号
@property (nonatomic,copy) NSString * TaskName;//任务名称
@property (nonatomic,copy) NSString * TaskPoint;//任务+成长值
@property (nonatomic,strong) NSNumber * IsComplete;//是否已完成

@end

@interface UserLevelEntity : BasicEntity

@property (nonatomic,copy) NSString * GrowthValue;//任务类型编号

@end




@interface LevelObj : DJXRequest

@end

@interface TaskObj : DJXRequest

@end

@interface UserLevelObj : DJXRequest

@end
