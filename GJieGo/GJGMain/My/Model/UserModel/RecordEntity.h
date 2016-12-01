//
//  RecordEntity.h
//  GJieGo
//
//  Created by dujinxin on 16/6/5.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicEntity.h"

@interface RecordEntity : BasicEntity //我发布的，我评论的用户

@property (nonatomic,copy) NSString * Id;//晒单编号
@property (nonatomic,copy) NSString * Title;//晒单标题
@property (nonatomic,copy) NSString * Img;//晒单图片
@property (nonatomic,copy) NSString * Like;//点赞数
@property (nonatomic,copy) NSString * Comment;//评论数
@property (nonatomic,copy) NSString * CreateTime;//创建时间
@property (nonatomic,strong)UserDetailEntity* User;//用户
//2016.10.16 v1.0.1
@property (nonatomic,copy) NSString * ViewNum;//浏览量
//2016.11.15 v1.0.3
@property (nonatomic,strong) NSDictionary * ActivityInfo;//活动
/*
 {
    ActivityName : 双十一晒单大比拼,
    ActivityId : 7,
    ActivityUrl : http://172.136.1.220:168/Activity/Details.html?id=7
}
*/
@end



@interface RecordGuiderEntity : BasicEntity

@property (nonatomic,copy) NSString * InfoId;//信息编号
@property (nonatomic,strong) AttentionGuiderEntity * User;//导购
@property (nonatomic,copy) NSString * Content;//内容
@property (nonatomic,copy) NSString * Images;//图片，以“,”号分隔
@property (nonatomic,copy) NSString * LikeNum;//点赞数
@property (nonatomic,copy) NSString * CommentNum;//评论数
@property (nonatomic,copy) NSString * Distance;//距离
@property (nonatomic,copy) NSString * longitude;//经度
@property (nonatomic,copy) NSString * latitude;//纬度
@property (nonatomic,copy) NSString * CreateTime;//发布时间
//2016.10.16 v1.1.0
@property (nonatomic,copy) NSString * ViewNum;//浏览量


@end

@interface RecordObj : DJXRequest

@end

@interface RecordGuiderObj : DJXRequest

@end

