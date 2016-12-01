//
//  GJGLocationManager.m
//  GJieGo
//
//  Created by liubei on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGLocationManager.h"
#import "NetService.h"
#import <CoreLocation/CoreLocation.h>
#import "LBLocationConverter.h"

#define GJGUserDefaultCityNameKey       @"GJGUserDefaultCityNameKey"
#define GJGUserDefaultCityID            @"GJGUserDefaultCityID"
#define GJGUserDefaultLocationNameKey   @"GJGUserDefaultLocationNameKey"
#define GJGUserDefaultLongitudeKey      @"GJGUserDefaultLongitude"
#define GJGUserDefaultLatitudeKey       @"GJGUserDefaultLatitude"
#define GJGOpenCitysKey                 @"GJGOpenCitysKey"

@interface GJGLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) AFNetWorkRequest__ *request;

@end

@implementation GJGLocationManager
static GJGLocationManager *_instance;

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        _instance.openedCitys = [NSMutableArray array];
        
        _instance.locationManager = [[CLLocationManager alloc] init];
        _instance.geocoder = [[CLGeocoder alloc] init];
        [_instance.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _instance.locationManager.distanceFilter = 100;
        //实现协议
        _instance.locationManager.delegate = _instance;
        //开始定位
        [_instance.locationManager requestWhenInUseAuthorization];
        [_instance.locationManager startUpdatingLocation];
        
        _instance.request = [[AFNetWorkRequest__ alloc] init];
        
        NSString *locationCityName = nil;
        locationCityName = [kUserDefaults objectForKey:GJGUserDefaultCityNameKey];
        _instance.cityName = locationCityName ? locationCityName : @"北京";
        NSString *locationName = nil;
        locationName = [kUserDefaults objectForKey:GJGUserDefaultLocationNameKey];
        _instance.locationName = locationName ? locationName : @"定位中..";
//        NSNumber *cityID = nil;
//        cityID = [kUserDefaults objectForKey:GJGUserDefaultCityID];
        _instance.cityID = 2;//cityID ? [cityID integerValue] : 2;
        CGFloat longitude = 0.0;
        if ([kUserDefaults objectForKey:GJGUserDefaultLongitudeKey]) {
            longitude = [[kUserDefaults objectForKey:GJGUserDefaultLongitudeKey] doubleValue];
        }
        _instance.longitude = longitude == 0.0 ? 0.0 : longitude;  //116.343651
        CGFloat latitude = 0.0;
        if ([kUserDefaults objectForKey:GJGUserDefaultLatitudeKey]) {
            latitude = [[kUserDefaults objectForKey:GJGUserDefaultLatitudeKey] doubleValue];
        }
        _instance.latitude = latitude == 0 ? 0.0 : latitude;   //39.7319074
        if ([kUserDefaults objectForKey:GJGOpenCitysKey]) {
            [_instance.openedCitys addObjectsFromArray:[GJGOpenedCity objectsWithArray:[kUserDefaults objectForKey:GJGOpenCitysKey]]];
            NSLog(@"读取本地开放城市列表%@", _instance.openedCitys);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_instance requestOpenCitys];
        });
    });
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}


#pragma mark - Manager func

- (BOOL)locationManagerGetLocationService {
    
    if  ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }
    return NO;
}


#pragma mark - Core location delegate

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    self.locaiton = newLocation;
    self.longitude = newLocation.coordinate.longitude;
    self.latitude = newLocation.coordinate.latitude;
    
    CLLocationCoordinate2D tureCoor = [LBLocationConverter wgs84ToGcj02:self.locaiton.coordinate];
    
    self.locaiton = [[CLLocation alloc] initWithLatitude:tureCoor.latitude longitude:tureCoor.longitude];
    self.longitude = tureCoor.longitude;
    self.latitude = tureCoor.latitude;
    
    [kUserDefaults setObject:[NSNumber numberWithDouble:self.longitude]
                      forKey:GJGUserDefaultLongitudeKey];
    [kUserDefaults setObject:[NSNumber numberWithDouble:self.latitude]
                      forKey:GJGUserDefaultLatitudeKey];
    [kUserDefaults synchronize];
    
    NSLog(@"定位出来的坐标 lat:%f lon:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"修改偏差出来的坐标 lat:%f lon:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    //根据经纬度反向地理编译出地址信息
    [self.geocoder reverseGeocodeLocation:newLocation
                        completionHandler:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
//            locality : 北京市,
//            country : 中国,
//            subLocality : 东城区,
//            administrativeArea : 北京市,
//            subThoroughfare : 4-17号,
//            fullThoroughfare : 珠市口东大街4-17号,
//            countryCode : CN,
//            thoroughfare : 珠市口东大街,
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            if (placemark.thoroughfare) {
                self.locationName = [NSString stringWithFormat:@"%@%@", placemark.administrativeArea, placemark.thoroughfare];
            }else if (placemark.subLocality) {
                self.locationName = [NSString stringWithFormat:@"%@%@", placemark.administrativeArea, placemark.subLocality];
            }else {
                self.locationName = placemark.administrativeArea;
            }
//            NSLog(@"%@ %@ %@", placemark.administrativeArea, placemark.thoroughfare, placemark.subLocality);
//            self.locationName = [NSString stringWithFormat:@"%@%@", placemark.administrativeArea, placemark.thoroughfare];
            [kUserDefaults setObject:self.locationName
                              forKey:GJGUserDefaultLocationNameKey];
            [kUserDefaults synchronize];
//            NSLog(@"反地理编码出新的地区拼接字段：%@", self.locationName);
//            NSLog(@"place: locality:%@ /n sublocality:%@ /n subthoroughfare:%@ /n /n thoroughfare:%@", placemark.locality, placemark.subLocality, placemark.subThoroughfare, placemark.thoroughfare);
            NSString *city = placemark.locality;
            if (!city)
                city = placemark.administrativeArea;
            self.cityName = city;//[[city componentsSeparatedByString:@"市"] firstObject];
            [kUserDefaults setObject:self.cityName
                              forKey:GJGUserDefaultCityNameKey];
            [kUserDefaults synchronize];
        }else if (error == nil && [array count] == 0) {
            NSLog(@"No results were returned.");
        }else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if ([error code] == kCLErrorDenied) {
        // 访问被拒绝
        NSLog(@"访问被拒绝");
    }else if ([error code] == kCLErrorLocationUnknown) {
        // 无法获取位置信息
        NSLog(@"无法获取位置信息");
    }
}

/*
 *  获得最新的开放城市列表
 */
- (void)requestOpenCitys {
    
    [self.request requestUrl:kGJGRequestUrl(kApiGetOpenedCity)
                 requestType:RequestGetType
                  parameters:nil
                requestblock:^(id responseobject, NSError *error)
     {
         if (!error) {   // NSLog(@"lb_getOpenCitys:%@", responseobject);
             if ([[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
                 if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                     [self.openedCitys removeAllObjects];
                     [self.openedCitys addObjectsFromArray:[GJGOpenedCity objectsWithArray:responseobject[@"data"]]];
                     [kUserDefaults setObject:responseobject[@"data"] forKey:GJGOpenCitysKey];
                     NSLog(@"存储本地开放城市列表%@", responseobject[@"data"]);
                     [kUserDefaults synchronize];
                 }
             }
         }else {
             NSLog(@"lb_getOpenCitys_fail:%@", error);
         }
    }];
}

//- (void)updateLocationName {
//    
//}


#pragma mark - getting

- (NSInteger)cityID {
    
    for (GJGOpenedCity *openedCity in self.openedCitys) {
        if ([openedCity.CityName isEqualToString:self.cityName]) {
            _cityID = openedCity.CityID;
            return _cityID;
        }
    }
    return 2;
}

- (CLLocation *)locaiton {
    
    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];;
}

@end



@implementation GJGOpenedCity

@end