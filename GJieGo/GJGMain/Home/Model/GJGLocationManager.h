//
//  GJGLocationManager.h
//  GJieGo
//
//  Created by liubei on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class GJGOpenedCity;

@interface GJGLocationManager : NSObject

/*
 *  反地理编码工具
 */
@property (nonatomic, strong) CLGeocoder *geocoder;

/** 城市 */
@property (nonatomic, copy) NSString *cityName;
/** 城市ID */
@property (nonatomic, assign) NSInteger cityID;
/** 具体街道名 */
@property (nonatomic, strong) NSString *locationName;
/** 经度 */
@property (nonatomic, assign) CGFloat longitude;
/** 纬度 */
@property (nonatomic, assign) CGFloat latitude;
/** 当前坐标 */
@property (nonatomic, strong) CLLocation *locaiton;
/** 开放城市列表 */
@property (nonatomic, strong) NSMutableArray<GJGOpenedCity *> *openedCitys;
/** 获取定位管理器 */
+ (instancetype)sharedManager;
/** 当前定位功能是否开启 */
- (BOOL)locationManagerGetLocationService;
///*
// *  @pragma 更新地理位置名称, 更改首页的地理位置
// */
//- (void)updateLocationName;

@end


#import "LBBaseModel.h"
@interface GJGOpenedCity : LBBaseModel

/** 城市ID */
@property (nonatomic, assign) NSInteger CityID;
/** 城市名称 */
@property (nonatomic, copy) NSString *CityName;

@end