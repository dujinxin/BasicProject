//
//  MapOfMainViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/17.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define GJGApplication [UIApplication sharedApplication]

#import "MapOfMainViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class LBLocationConverter;

@interface MapOfMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView* mapView;
    UIView *statusBackView;
    CLLocationManager *locationmanager;
//    CLLocationCoordinate2D coor2d;
    CLGeocoder *geocoder;
    
    NSString *name;
    NSString *address;
}

@end

@implementation MapOfMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:GJGRGB16Color(0xfee330)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - Init

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initAttributes];
    [self createUI];
}

- (void)initAttributes {
    
    name = @"目的地";
    address = @"地址:";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
    
    UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorImage = img;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = img;
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
}

- (void)createUI {
    
    [self createNav];
    if ( (self.shopLocation.coordinate.latitude >= -90)
        && (self.shopLocation.coordinate.latitude <= 90)
        && (self.shopLocation.coordinate.longitude >= -180)
        && (self.shopLocation.coordinate.longitude <= 180) )
    {
        [self createMap];
        [self updateShopDetail];
    } else {
        [MBProgressHUD showError:@"经纬度异常" toView:self.view];
    }
}

- (void)createNav {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [titleLabel setText:@"地图导航"];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:GJGRGB16Color(0x333333)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)createMap {
    
    // Do any additional setup after loading the view.
    //初始化地图视图
    mapView = [[MKMapView alloc]init];
    //地图的代理方法
    mapView.delegate = self;
    //是否显示当前的位置
//    mapView.showsUserLocation = YES;
    //地图的类型， iOS开发中自带的地图
    //使用第三方的地图可以查找周边环境的餐馆，学校之类的
    /*
     MKMapTypeStandard 标准地图
     MKMapTypeSatellite 卫星地图
     MKMapTypeHybrid 混合地图
     */
    mapView.mapType = MKMapTypeStandard;
    
//    coor2d = self.shopLocation.coordinate;//CLLocationCoordinate2DMake(41.6, 117.52);

    //显示范围，数值越大，范围就越大
    MKCoordinateSpan span = {5,5};
    MKCoordinateRegion region = {self.shopLocation.coordinate,span};
    //是否允许缩放，一般都会让缩放的
    //mapview.zoomEnabled = NO;//mapview.scrollEnabled = NO;
    
    //地图初始化时显示的区域
    [mapView setRegion:region];
    [self.view addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(64);
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    locationmanager = [[CLLocationManager alloc]init];
    //设置定位的精度
    /*
     kCLLocationAccuracyBest
     kCLLocationAccuracyNearestTenMeters
     kCLLocationAccuracyHundredMeters
     kCLLocationAccuracyHundredMeters
     kCLLocationAccuracyKilometer
     kCLLocationAccuracyThreeKilometers
     */
    [locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    //实现协议
    locationmanager.delegate = self;
    //开始定位
    [locationmanager requestWhenInUseAuthorization];
    [locationmanager startUpdatingLocation];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self zoomToAnnotations];
//    });
}


#pragma mark - Update shop detail

- (void)updateShopDetail {
    
    if (self.shopName != nil && self.shopAddress != nil) {
        
        name = self.shopName;
        address = self.shopAddress;
        [self zoomToAnnotations];
        return;
    }
    
    [request requestUrl:kGJGRequestUrl(kGet_ShopDetail)
            requestType:RequestGetType
             parameters:@{@"ShopId" : [NSNumber numberWithInteger:self.shopId]}
           requestblock:^(id responseobject, NSError *error) {
               if (!error) {    NSLog(@"lb_map_getShopInfo:%@", responseobject);
                   if ([responseobject isKindOfClass:[NSDictionary class]] && [[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
                       if ([responseobject[@"data"] isKindOfClass:[NSDictionary class]]) {
                           name = responseobject[@"data"][@"Name"] ? responseobject[@"data"][@"Name"] : @"目的地";
                           address = responseobject[@"data"][@"Address"] ? responseobject[@"data"][@"Address"] : @"";
                       }
                   }
               }else {
                   NSLog(@"lb_request_shop fail:%@",error);
               }
               [self zoomToAnnotations];
           }];
}


#pragma mark - LocationManager delegate

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    
    for (CLLocation* location in locations) {
        NSLog(@"delegate: %@",location);
    }
 //停止定位
  [manager stopUpdatingLocation];
}


-(void)zoomToAnnotations {
    
    MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
    pinAnnotation.coordinate = self.shopLocation.coordinate;
    pinAnnotation.title = name;//@"京城第一家海鲜大咖0中心二中南门对面";
    pinAnnotation.subtitle = address;//@"双榆树北里甲18号楼附近";
    
    [mapView addAnnotation:pinAnnotation];
    // 指定新的显示区域
    [mapView setRegion:MKCoordinateRegionMake(pinAnnotation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    // 选中标注
    [mapView selectAnnotation:pinAnnotation animated:YES];
}
 
#pragma mark - MKMapView Delegate
//返回标注视图（大头针视图）
-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView * view = [[MKAnnotationView alloc]initWithAnnotation:annotation
                                                          reuseIdentifier:@"annotation"];
    //设置标注的图片
    view.image=[UIImage imageNamed:@"destination"];
    //点击显示图详情视图 必须MJPointAnnotation对象设置了标题和副标题
    view.canShowCallout=YES;
    
    UIView * guideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(guideDidClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"导航" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setImage:[UIImage imageNamed:@"alert_success_icon"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;

    [guideView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(guideView.center).with.offset(0);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    view.rightCalloutAccessoryView = guideView;
    view.detailCalloutAccessoryView.backgroundColor = GJGRGBAColor(0, 0, 0, 0.3);
    
    return view;
}

//更新当前位置调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}
//选中注释图标
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}
//地图的显示区域改变了调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManagerdidFailWithError:%@",error);
}


#pragma mark - Click event

- (void)guideDidClick:(UIButton *)sender {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请选择地图"
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *iOSMapSheet = [UIAlertAction actionWithTitle:@"使用苹果自带地图导航"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
    {
        [self openiOSMap];
    }];
    [alertC addAction:iOSMapSheet];
    
    if ([GJGApplication canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        UIAlertAction *sheet = [UIAlertAction actionWithTitle:@"使用高德地图导航"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self openGaodeMap];
                                }];
        [alertC addAction:sheet];
    }
    if ([GJGApplication canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        UIAlertAction *sheet = [UIAlertAction actionWithTitle:@"使用百度地图导航"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
        {
            [self openBaiduMap];
        }];
        [alertC addAction:sheet];
    }
    
    if ([GJGApplication canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        UIAlertAction *sheet = [UIAlertAction actionWithTitle:@"使用腾讯地图导航"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
        {
            [self openTengxunMap];
        }];
        [alertC addAction:sheet];
    }
    UIAlertAction *cancelSheet = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {}];
    [alertC addAction:cancelSheet];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)openiOSMap {
    CLLocationCoordinate2D coordinate = self.shopLocation.coordinate;
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    //    CLLocationCoordinate2D coordinate = self.shopLocation.coordinate;
    //    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"逛街购",@"UrlSection",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)openGaodeMap {
    CLLocationCoordinate2D coordinate = self.shopLocation.coordinate;
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"逛街购",@"guangjiego",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)openBaiduMap {
    CLLocationCoordinate2D coordinate = self.shopLocation.coordinate;
//    CLLocationCoordinate2D enLocation = [LBLocationConverter gcj02ToBd09:coordinate];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"lb_longitude_before:%lf %f, after: %lf %lf", coordinate.latitude, coordinate.longitude, enLocation.latitude, enLocation.longitude);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)openTengxunMap {
    CLLocationCoordinate2D coordinate = self.shopLocation.coordinate;
    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=%f,%f&coord_type=1&policy=0",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

//- (LBLocation)lb_bd_encrypt:(LBLocation gcLoc) {
//    
//    double x = gcLoc.lng, y = gcLoc.lat;
//    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
//    return LBLocationMake(z * cos(theta) + 0.0065, z * sin(theta) + 0.006);
//}
@end

