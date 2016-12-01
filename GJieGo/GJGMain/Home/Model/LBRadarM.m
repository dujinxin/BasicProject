//
//  LBRadarM.m
//  GJieGo
//
//  Created by liubei on 16/6/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "LBRadarM.h"
#import "GJGLocationManager.h"

@implementation LBRadarM
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"ItemList"]) {
        if ([value isKindOfClass:[NSArray class]]) {
#warning 如果没有经纬度的模型需要剔除，那么在这里完成
            self.radarItemList = [LBRadarItemM objectsWithArray:value];
        }
    }
}
@end

@implementation LBRadarItemM

//- (CLLocation *)location {
//    
//    if (!_location) {
//        _location = [[CLLocation alloc] initWithLatitude:self.Latitude longitude:self.Longitude];
//    }
//    return _location;
//}

//- (CGFloat)distance {
//    
//    if (_distance == 0) {
//        // 计算两个CLLocation 的距离
//        CLLocation *orig = [[CLLocation alloc] initWithLatitude:self.userLocation.latitude longitude:self.userLocation.longitude];//[GJGLocationManager sharedManager].locaiton;
//        CLLocation* dist = self.location;
//        _distance = [orig distanceFromLocation:dist];
//        //    NSLog(@"距离: %f",distance);
//    }
////    // 计算两个CLLocation 的距离
////    CLLocation *orig = [[CLLocation alloc] initWithLatitude:self.userLocation.latitude longitude:self.userLocation.longitude];//[GJGLocationManager sharedManager].locaiton;
////    CLLocation* dist = self.location;
////    CLLocationDistance distance = [orig distanceFromLocation:dist];
//////    NSLog(@"距离: %f",distance);
//    
//    return _distance;
//}
@end