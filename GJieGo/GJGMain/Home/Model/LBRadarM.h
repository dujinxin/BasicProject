//
//  LBRadarM.h
//  GJieGo
//
//  Created by liubei on 16/6/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBBaseModel.h"
@class LBRadarItemM;

@interface LBRadarM : LBBaseModel
/** 范围 */
@property (nonatomic, assign) NSInteger Distance;
/** 元素列表 */
@property (nonatomic, strong) NSArray<LBRadarItemM *> *radarItemList;
@end


#pragma mark - 元素模型

typedef enum {
    
    RadarItemTypeIsUser = 1,
    RadarItemTypeIsGuider = 2,
    RadarItemTypeIsSharedOrder = 3,
    RadarItemTypeIsGuideInfo = 4
    
}RadarItemType;

@interface LBRadarItemM : LBBaseModel
/** 活动 */
@property (nonatomic, copy) NSString *ActivityName;
/** 描述 */
@property (nonatomic, copy) NSString *Description;
/** ID */
@property (nonatomic, assign) NSInteger ID;
/** 图片 */
@property (nonatomic, copy) NSString *Image;
/** 图片数量 */
@property (nonatomic, assign) int ImgCount;
///** 经度 */
@property (nonatomic, assign) CGFloat Longitude;
/** 纬度 */
@property (nonatomic, assign) CGFloat Latitude;
///** 经纬度坐标(整合) */
//@property (nonatomic, strong) CLLocation *location;
/** 用户坐标 */
//@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
/** 元素名称 */
@property (nonatomic, copy) NSString *Name;
/** 元素类型
 1	用户
 2	导购
 3	晒单
 4	导购信息
 */
@property (nonatomic, assign) RadarItemType Type;
/** 距用户的距离(计算得出) */
@property (nonatomic, assign) CGFloat distance;
/** 创建时间 */
@property (nonatomic, assign) NSInteger CreateDate;
/** 等级 */
@property (nonatomic, copy) NSString *Level;
@end
