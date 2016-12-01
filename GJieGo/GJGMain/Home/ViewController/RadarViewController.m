/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 ABM Adnan
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "RadarViewController.h"
#import "ShareViewController.h"
#import "ShopGuideDetailViewController.h"
#import "SharedOrderDetailViewController.h"
#import "UserHomeViewController.h"
#import "GuideHomeViewController.h"
#import "RadarInfoCell.h"
#import "Radar.h"
#import "Arcs.h"
#import "Dot.h"
#import "LBRadarM.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define HalfScreenW (ScreenW * 0.5)
#define HalfScreenH (ScreenH * 0.5)

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

#define DotOfUserWidth 10.f
#define DotOfImgWidth 36.f

#define NoteLabelW ScreenWidth
#define NoteLabelH 19
#define NoteLabelX ((ScreenWidth - NoteLabelW) * 0.5)
#define NoteLabelY (CGRectGetMaxY(radarViewHolder.frame) + 4)

#define Radar_SliderW (ScreenW * 0.714f)
#define Radar_SliderH 19.f
#define Radar_SliderX (HalfScreenW - Radar_SliderW * 0.5)
#define Radar_SliderY (CGRectGetMaxY(self.distanceLabel.frame) + 22.f)

#define RadarWidth radarViewHolder.frame.size.width
#define RadarHeight radarViewHolder.frame.size.height
#define RadarX radarViewHolder.frame.origin.x
#define RadarY radarViewHolder.frame.origin.y

#define SliderMinimumTrackTintColor GJGRGB16Color(0xfee330)
#define SliderMaxmumTrackTintColor [UIColor whiteColor]

@interface RadarViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    UIScrollView *mainScrollView;
    
    UIView *radarViewHolder;
    Arcs *arcsView;
    Radar *radarView;
    UIView *radarLine;
    UIButton *shareBtn;
    
    UISlider *distanceSlider;
    CGFloat unitDistance;
    
    NSMutableArray *dots;
    NSArray *nearbyUsers;
    NSTimer *detectCollisionTimer;
    
    float currentDeviceBearing;
    CGFloat outDistance;
    CGFloat collectionViewHeight;
    CGRect collectionViewRect;
    CGRect collectionViewZeroRect;
    UIButton *nearlyBtn;
    UIButton *farBtn;
}
/** 雷达数据模型 */
@property (nonatomic, strong) LBRadarM *radarInfo;

@property (nonatomic, assign) CLLocationCoordinate2D myLoc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<LBRadarItemM *> *collectionDataSource;
@property (nonatomic, assign, getter=isShowList) BOOL showList;
/** This property(BOOL) in order to make cell disappear after collection view animation. */
@property (nonatomic, assign, getter=isCollectionViewAnimation) BOOL collectionViewAnimation;
@property (nonatomic, strong) UIView *collectionViewCover;
@property (nonatomic, strong) UIView *sliderViewCover;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation RadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initArrtibutes];
    [self createUI];
    
    // start spinning the radar forever
    [self spinRadar];
    
    // start heading event to rotate the arcs along with device rotation
    currentDeviceBearing = 0;
    [self startHeadingEvent];
    
    [self loadUsers];
}


#pragma mark - Controller func

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hiddenAllUserIcon];
}


#pragma mark - Init
- (void)initArrtibutes {
    
    self.view.backgroundColor = [UIColor clearColor];
    dots = [[NSMutableArray alloc] init];
    nearbyUsers = [[NSArray alloc] init];
    self.collectionDataSource = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createUI {
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    mainScrollView.backgroundColor = [UIColor clearColor];
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    mainScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUsers];
    }];
    [mainScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCollectionView)]];
    
    radarViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 6, ScreenW, ScreenW)];
    //    radarViewHolder.center = self.view.center;
    radarViewHolder.backgroundColor = [UIColor clearColor];
    radarViewHolder.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    [mainScrollView addSubview:radarViewHolder];
    
    arcsView = [[Arcs alloc] initWithFrame:radarViewHolder.bounds];
    // NOTE: Since our gradient layer is built as an image,
    // we need to scale it to match the display of the device.
    arcsView.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    // add tap gesture recognizer to arcs view to capture tap on dots (user profiles) and enlarge the selected dots with a white border
    arcsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDotTapped:)];
    [arcsView addGestureRecognizer:tapGestureRecognizer];
    [radarViewHolder addSubview:arcsView];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.layer.contentsScale = [UIScreen mainScreen].scale;
    [shareBtn.imageView setContentMode:UIViewContentModeScaleToFill];
    [shareBtn setImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
              forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(ScreenW *0.5 -32.5, ScreenW *0.5 -32.5, 65, 65);
    [arcsView addSubview:shareBtn];
    
    radarView = [[Radar alloc] initWithFrame:CGRectMake(3, 3, radarViewHolder.frame.size.width-6, radarViewHolder.frame.size.height-6)];
    
    radarView.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    radarView.alpha = 0.68;
    [radarViewHolder addSubview:radarView];
    
    radarLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 116, 1)];
    radarLine.hidden = YES;
    radarLine.center = CGPointMake(radarViewHolder.frame.size.width * 0.5, radarViewHolder.frame.size.height * 0.5);
    radarLine.layer.anchorPoint = CGPointMake(-0.18, 0.5);
    [radarViewHolder addSubview:radarLine];
    
    self.distanceLabel.frame = CGRectMake(NoteLabelX, NoteLabelY, NoteLabelW, NoteLabelH);
    [mainScrollView addSubview:self.distanceLabel];
    
    UIView *panGesFilterView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        Radar_SliderY - 20,
                                                                        ScreenWidth,
                                                                        Radar_SliderH + 40)];
//    panGesFilterView.backgroundColor = [UIColor redColor];
    panGesFilterView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panFilter = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFilter:)];
    [panGesFilterView addGestureRecognizer:panFilter];
    [mainScrollView addSubview:panGesFilterView];
    
    distanceSlider = [[UISlider alloc] initWithFrame:CGRectMake(Radar_SliderX,
                                                                Radar_SliderY,
                                                                Radar_SliderW,
                                                                Radar_SliderH)];
    distanceSlider.userInteractionEnabled = NO;
//    distanceSlider.backgroundColor = [UIColor redColor];
//    [distanceSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
    [distanceSlider setMinimumTrackTintColor:SliderMinimumTrackTintColor];
    [distanceSlider setMaximumTrackTintColor:SliderMaxmumTrackTintColor];
//    [distanceSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSlider:)];
    [distanceSlider addGestureRecognizer:pan];
    [mainScrollView addSubview:distanceSlider];
    
    nearlyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nearlyBtn addTarget:self
               action:@selector(reduceBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [nearlyBtn setImage:[[UIImage imageNamed:@"nearly"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
            forState:UIControlStateNormal];
    [mainScrollView addSubview:nearlyBtn];
    [nearlyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.mas_equalTo(18.f);
        make.right.equalTo(distanceSlider.mas_left).with.offset(-8);
        make.centerY.equalTo(distanceSlider.mas_centerY).with.offset(0);
    }];
    farBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [farBtn addTarget:self
               action:@selector(addBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [farBtn setImage:[[UIImage imageNamed:@"far"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
            forState:UIControlStateNormal];
    [mainScrollView addSubview:farBtn];
    [farBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(18.f);
        make.left.equalTo(distanceSlider.mas_right).with.offset(8);
        make.centerY.equalTo(distanceSlider.mas_centerY).with.offset(0);
    }];
}


#pragma mark - Load radarInfos
- (void)loadUsers {
    // empty the existing dots from radar
    //    [self removePreviousDots]; // this is useful if you want to remove existing dots at runtime
    [self hiddenCollectionView];
    
    [DJXRequest requestWithBlock:kApiGetAroundInfo param:nil success:^(id object,NSString *msg) {
        [mainScrollView.mj_header endRefreshing];
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([self.delegate respondsToSelector:@selector(radarView:RefreshSuccess:)]) {
                [self.delegate radarView:self RefreshSuccess:YES];
            }
            [self removePreviousDots];
            self.radarInfo = [LBRadarM modelWithDict:object];
            _myLoc = [GJGLocationManager sharedManager].locaiton.coordinate;
            for (LBRadarItemM *item in self.radarInfo.radarItemList) {
                CLLocation *orig = [[CLLocation alloc] initWithLatitude:item.Latitude
                                                              longitude:item.Longitude];
                CLLocation* dist = [[CLLocation alloc] initWithLatitude:_myLoc.latitude
                                                              longitude:_myLoc.longitude];
                item.distance = [orig distanceFromLocation:dist];
            }
            self.radarInfo.radarItemList = [self.radarInfo.radarItemList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                LBRadarItemM *item1 = obj1;    LBRadarItemM *item2 = obj2;
                if (item1.distance > item2.distance) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if (item1.distance < item2.distance) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            [self renderUsersOnRadar];
        }
    } failure:^(id object,NSString *msg) {
        [mainScrollView.mj_header endRefreshing];
        if ([msg isKindOfClass:[NSString class]]) {
            NSLog(@"雷达数据请求失败, %@", msg);
        }
    }];
    
//    [request requestUrl:kGJGRequestUrl(kApiGetAroundInfo)
//            requestType:RequestGetType
//             parameters:nil
//           requestblock:^(id responseobject, NSError *error)
//     {
//         [mainScrollView.mj_header endRefreshing];
//         if (!error) {   NSLog(@"lb_radarInfo_success:%@", responseobject);
//             if ([[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
//                 if ([[responseobject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//                     [self removePreviousDots];
//                     self.radarInfo = [LBRadarM modelWithDict:[responseobject objectForKey:@"data"]];
//                     _myLoc = [GJGLocationManager sharedManager].locaiton.coordinate;
//                     for (LBRadarItemM *item in self.radarInfo.radarItemList) {
//                         CLLocation *orig = [[CLLocation alloc] initWithLatitude:item.Latitude
//                                                                       longitude:item.Longitude];
//                         CLLocation* dist = [[CLLocation alloc] initWithLatitude:_myLoc.latitude
//                                                                       longitude:_myLoc.longitude];
//                         item.distance = [orig distanceFromLocation:dist];
//                     }
//                     self.radarInfo.radarItemList = [self.radarInfo.radarItemList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                         LBRadarItemM *item1 = obj1;    LBRadarItemM *item2 = obj2;
//                         if (item1.distance > item2.distance) {
//                             return (NSComparisonResult)NSOrderedDescending;
//                         }
//                         if (item1.distance < item2.distance) {
//                             return (NSComparisonResult)NSOrderedAscending;
//                         }
//                         return (NSComparisonResult)NSOrderedSame;
//                     }];
////                     for (int i = 0; i < self.radarInfo.radarItemList.count; i++) {
////                         NSLog(@"排序后距离, 数组第%d个 %f", i, self.radarInfo.radarItemList[i].distance);
////                     }
//                     [self renderUsersOnRadar];
//                 }else {
//                     [MBProgressHUD showError:[responseobject objectForKey:@"message"] toView:self.view];
//                 }
//             }
//         }else {
//             NSLog(@"lb_request_RadarInfo_fail:%@",error);
//         }
//     }];
    
    // At this point use your own method to load nearby users from server via network request.
    // I'm using some dummy hardcoded users data.
    // Make sure in your returned data the **sorted** by **nearest to farthest**
    //    nearbyUsers = @[
    //                    @{@"gender":@"female", @"lat":@48.859873, @"lng":@2.295083, @"distance":@143.1}, // *Nearest*
    //                    @{@"gender":@"male",   @"lat":@48.858619, @"lng":@2.296101, @"distance":@230}, //
    //                    @{@"gender":@"female", @"lat":@48.856492, @"lng":@2.298515, @"distance":@362.3}, // THE SORTING is
    //                    @{@"gender":@"male",   @"lat":@48.857618, @"lng":@2.300544, @"distance":@398.6}, // Very IMPORTANT!
    //                    @{@"gender":@"female", @"lat":@48.864176, @"lng":@2.297666, @"distance":@439.8},
    //                    @{@"gender":@"male",   @"lat":@48.855718, @"lng":@2.301544, @"distance":@418.6}, // Very IMPORTANT!
    //                    @{@"gender":@"female", @"lat":@48.858376, @"lng":@2.297666, @"distance":@499.8}, //
    //                    @{@"gender":@"male",   @"lat":@48.853643, @"lng":@2.289186, @"distance":@567.1}  // *Farthest*
    //                    ];
    
    // This method should be called after successful return of JSON array from your server-side service
    //    [self renderUsersOnRadar:nearbyUsers];
}


#pragma mark - Reload Radar

-(void) removePreviousDots {
    for (Dot *dot in dots) {
        [dot removeFromSuperview];
    }
    dots = [NSMutableArray array];
    
    // reset slider
    distanceSlider.minimumValue = 0;
    distanceSlider.maximumValue = 0;
    distanceSlider.value = 0;
    
    [arcsView removeFromSuperview];
    [_locManager stopUpdatingHeading];
    
    arcsView = [[Arcs alloc] initWithFrame:radarViewHolder.bounds];
    arcsView.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
    arcsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDotTapped:)];
    [arcsView addGestureRecognizer:tapGestureRecognizer];
    [radarViewHolder addSubview:arcsView];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.layer.contentsScale = [UIScreen mainScreen].scale;
    [shareBtn.imageView setContentMode:UIViewContentModeScaleToFill];
    [shareBtn setImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
              forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(ScreenW *0.5 -32.5, ScreenW *0.5 -32.5, 65, 65);
    [arcsView addSubview:shareBtn];
    //    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.and.height.equalTo(@65);
    //        make.center.equalTo(arcsView.center).with.offset(0);
    //    }];
    
    [arcsView bringSubviewToFront:shareBtn];
}

-(void)renderUsersOnRadar {//:(NSArray*)users{
    // 我的坐标
//    _myLoc = [GJGLocationManager sharedManager].locaiton.coordinate;//{ 48.858370, 2.294481 };
    
    // 获得数组中模型对象的最近和最远的，用来当滚动条的参数
    // the last user in the nearbyUsers list is the farthest
    CGFloat maxDistance = [self.radarInfo.radarItemList lastObject].distance;
    CGFloat minDistance = [self.radarInfo.radarItemList firstObject].distance;
    
    unitDistance = (maxDistance - minDistance) / ScreenWidth;
    distanceSlider.minimumValue = minDistance;
    distanceSlider.maximumValue = maxDistance;// + buffDis;
    distanceSlider.value = maxDistance;// - buffDis;
    
    NSLog(@"maxDis:%f minDis:%f unitDis:%f self_loc:%f %f", maxDistance, minDistance, unitDistance, _myLoc.latitude, _myLoc.longitude);
    
    //***************************** 模型转真实数据后的代码 *****************************
    
    NSMutableArray<LBRadarItemM *> *imgItems = [NSMutableArray array];
    // change radarItem to dot
    for (LBRadarItemM *radarItem in self.radarInfo.radarItemList) {
        
        if (radarItem.Type == RadarItemTypeIsGuideInfo || radarItem.Type == RadarItemTypeIsSharedOrder) {
            
            [imgItems addObject:radarItem];
            
        }else {
            
            Dot *dot = [[Dot alloc] initWithFrame:CGRectMake(0, 0, DotOfUserWidth, DotOfUserWidth)];
            dot.layer.contentsScale = [UIScreen mainScreen].scale;
            
            // user -> blue, guider -> red
            switch (radarItem.Type) {
                    
                case RadarItemTypeIsUser:
                    dot.type = DotTypeIsUser;
                    break;
                case RadarItemTypeIsGuider:
                    dot.type = DotTypeIsGuider;
                    break;
                    
                default:
                    break;
            }
            
            dot.radarItem = radarItem;
            float bearing = [self getHeadingForDirectionFromCoordinate:_myLoc
                                                          toCoordinate:CLLocationCoordinate2DMake(radarItem.Latitude,
                                                                                                  radarItem.Longitude)];
            dot.bearing = [NSNumber numberWithFloat:bearing];
            
            float d = radarItem.distance;
            float distance = MAX(55, d * (ScreenWidth * 0.5 - 45) / maxDistance); // 140 = radius of the radar circle, so the farthest user will be on the perimiter of radar circle
            
            dot.distance = [NSNumber numberWithFloat:distance]; // relative distance
            dot.userDistance = [NSNumber numberWithFloat:d];
            dot.radarItem = radarItem;
            dot.zoomEnabled = NO;
            dot.userInteractionEnabled = NO;
            
            [arcsView addSubview:dot];
            [self rotateDot:dot fromBearing:0 toBearing:bearing atDistance:distance];
            [dots addObject:dot];
        }
        
    }
    
    // add Image Dots
    // 遍历所有图片Dot，将其分区.
    
#pragma mark - New worker
//    
//    // <1> 获取雷达数据的经纬度最大区间
//    CGFloat maxLat = 0.f;
//    CGFloat minLat = 0.f;
//    CGFloat maxLng = 0.f;
//    CGFloat minLng = 0.f;
//    for (LBRadarItemM *item in imgItems) {
//        if (item.Latitude > maxLat)
//            maxLat = item.Latitude;
//        if (item.Latitude < minLat)
//            minLat = item.Latitude;
//        
//        if (item.Longitude > maxLng)
//            maxLng = item.Longitude;
//        if (item.Longitude < minLng)
//            minLng = item.Longitude;
//    }
//    
//    // <2> 根据区间切割成细致区域
//    static NSInteger col_row = 4;
//    CGFloat unitLat = fabs(maxLat - _myLoc.latitude) / (col_row * 0.5);
//    CGFloat unitLng = fabs(maxLng - _myLoc.longitude) / (col_row * 0.5);
//    NSMutableArray<NSMutableArray *> *allGroups = [NSMutableArray array];
//    
//    for (int i = 0; i < pow(col_row, 2); i++) {
//        NSMutableArray *itemArr = [NSMutableArray array];
//        [allGroups addObject:itemArr];
//    }
//    
//    // <3> 创建雷达图片对象, 并进行区间分配
//    for (LBRadarItemM *radarItem in imgItems) {
//        
//        Dot *dot = [[Dot alloc] initWithFrame:CGRectMake(0, 0, DotOfImgWidth, DotOfImgWidth)];
//        dot.layer.contentsScale = [UIScreen mainScreen].scale;
//        dot.type = DotTypeIsImage;
//        dot.radarItem = radarItem;
//        
//        float bearing = [self getHeadingForDirectionFromCoordinate:_myLoc
//                                                      toCoordinate:CLLocationCoordinate2DMake(radarItem.Latitude,
//                                                                                              radarItem.Longitude)];
//        dot.bearing = [NSNumber numberWithFloat:bearing];
//        
//        float d = radarItem.distance;
//        float distance = MAX(50, d * (ScreenWidth * 0.5 - 45) / maxDistance);
//        dot.distance = [NSNumber numberWithFloat:distance];
//        dot.userDistance = [NSNumber numberWithFloat:d];
//        dot.zoomEnabled = NO;
//        dot.userInteractionEnabled = YES;
//        
//        CGFloat lat = radarItem.Latitude;
//        CGFloat lng = radarItem.Longitude;
//        
//        CGFloat latDis = (lat - _myLoc.latitude) + unitLat * col_row * 0.5;
//        int latPartIndex = (int)(latDis / unitLat);
//        
//        CGFloat lngDis = (lng - _myLoc.longitude) + unitLng * col_row * 0.5;
//        int lngPartIndex = (int)(lngDis / unitLng);
//        NSLog(@"lat:%d lng:%d", latPartIndex, lngPartIndex);
//        NSInteger index = latPartIndex * col_row + lngPartIndex;
//        if (index >= pow(col_row, 2)) {
//            continue;
//        }
//        [allGroups[index] addObject:dot];
//    }
    
#pragma mark - End
    
    NSMutableArray *lt = [NSMutableArray array];
    NSMutableArray *lb = [NSMutableArray array];
    NSMutableArray *rt = [NSMutableArray array];
    NSMutableArray *rb = [NSMutableArray array];
    NSArray *allGroup  = @[lt, lb, rt, rb];
    
    for (LBRadarItemM *radarItem in imgItems) {
        
        Dot *dot = [[Dot alloc] initWithFrame:CGRectMake(0, 0, DotOfImgWidth, DotOfImgWidth)];
        dot.layer.contentsScale = [UIScreen mainScreen].scale;
        dot.type = DotTypeIsImage;
        dot.radarItem = radarItem;

//        CLLocationCoordinate2D userLoc = radarItem.location.coordinate;
        
        float bearing = [self getHeadingForDirectionFromCoordinate:_myLoc
                                                      toCoordinate:CLLocationCoordinate2DMake(radarItem.Latitude,
                                                                                              radarItem.Longitude)];
        dot.bearing = [NSNumber numberWithFloat:bearing];
        
        float d = radarItem.distance;
        float distance = MAX(55, d * (ScreenWidth * 0.5 - 45) / maxDistance);
        dot.distance = [NSNumber numberWithFloat:distance];
        dot.userDistance = [NSNumber numberWithFloat:d];
        dot.zoomEnabled = NO;
        dot.needLoadImg = YES;
        dot.userInteractionEnabled = YES;
        
        CGFloat lat = radarItem.Latitude;
        CGFloat lng = radarItem.Longitude;
        if (lat > _myLoc.latitude) {
            if (lng > _myLoc.longitude) {
                [rt addObject:dot];
            }else {
                [rb addObject:dot];
            }
        }else {
            if (lng > _myLoc.longitude) {
                [lt addObject:dot];
            }else {
                [lb addObject:dot];
            }
        }
    }
    
    for (int i = 0; i < allGroup.count; i++) {
        
        NSMutableArray *partArray = allGroup[i];
        
        if (partArray.count < 2) {

            for (int i = 0; i<partArray.count; i++) {
                
                Dot *dot = partArray[i];
                dot.needLoadImg = YES;
                [arcsView addSubview:dot];
                [self rotateDot:dot fromBearing:0 toBearing:dot.bearing.floatValue atDistance:dot.distance.floatValue];
                [dots addObject:dot];
            }
        }else {
            // 创建一个组Dot
            Dot *dot = [[Dot alloc] initWithFrame:CGRectMake(0, 0, DotOfImgWidth, DotOfImgWidth)];
            dot.layer.contentsScale = [UIScreen mainScreen].scale;
            dot.type = DotTypeIsGroup;
            dot.subDots = partArray;
            CLLocationCoordinate2D centerLoc = [self getCenterLocation:partArray];
            
            float bearing = [self getHeadingForDirectionFromCoordinate:_myLoc toCoordinate:centerLoc];
            dot.bearing = [NSNumber numberWithFloat:bearing];
            float d = [self getAveDistance:partArray];
            float distance = MAX(55, d * (ScreenWidth * 0.5 - 45) / maxDistance);
            dot.distance = [NSNumber numberWithFloat:distance];
            dot.userDistance = [NSNumber numberWithFloat:d];
            dot.zoomEnabled = NO;
            dot.userInteractionEnabled = NO;
            
            [self rotateDot:dot fromBearing:0 toBearing:bearing atDistance:distance];
            [arcsView addSubview:dot];
            [dots addObject:dot];
        }
    }
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_locManager startUpdatingHeading];
//        [self sliderValueChange:distanceSlider];
//        [self sliderValueChange:distanceSlider];
//    });
    int showCount = 0;
    //    NSLog(@"%lu 个dot, %lu 个模型", dots.count, self.radarInfo.radarItemList.count);
    for (Dot *dot in dots) {
        if (dot.type == DotTypeIsGroup || dot.type == DotTypeIsImage) {
            [arcsView bringSubviewToFront:dot];
        }
        if (!dot.isOut) {
            if (dot.type == DotTypeIsGroup) {
                showCount += dot.subDots.count;
            }else if (dot.type == DotTypeIsImage) {
                showCount += 1;
            }
        }
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm内%d个消息", (float)maxDistance/1000, showCount];

    detectCollisionTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                            target:self
                                                          selector:@selector(detectCollisions:)
                                                          userInfo:nil
                                                           repeats:YES];
    
    [arcsView bringSubviewToFront:shareBtn];
}

/*
 *  获得坐标组的中心点
 */
- (CLLocationCoordinate2D)getCenterLocation:(NSArray *)locations {
    
    float totalLat = 0.f;
    float totalLng = 0.f;
    
    for (Dot *dot in locations) {
        LBRadarItemM *item = dot.radarItem;
        totalLat += item.Latitude;
        totalLng += item.Longitude;
    }
    return CLLocationCoordinate2DMake(totalLat / locations.count, totalLng / locations.count);
}

- (float)getAveDistance:(NSArray *)distances {
    
    float totalDis = 0.f;
    
    for (Dot *dot in distances) {
        LBRadarItemM *item = dot.radarItem;
        totalDis += item.distance;
    }
    return totalDis / distances.count;
}


#pragma mark - Spin the radar view continuously
-(void)spinRadar{
    /**** spin animation object ***/
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spin.duration = 1;
    spin.toValue = [NSNumber numberWithFloat:-M_PI];
    spin.cumulative = YES;
    spin.removedOnCompletion = NO; // this is to keep on animating after application pause-resume
    spin.repeatCount = MAXFLOAT;
    
    [radarLine.layer addAnimation:spin forKey:@"spinRadarLine"];
    [radarView.layer addAnimation:spin forKey:@"spinRadarView"];
}

- (void)startHeadingEvent {
    if (nil == _locManager) {
        // Retain the object in a property.
        _locManager = [[CLLocationManager alloc] init];
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.distanceFilter = kCLDistanceFilterNone;
        _locManager.headingFilter = kCLHeadingFilterNone;
    }
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locManager requestWhenInUseAuthorization];
    }
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        [_locManager startUpdatingHeading];
    }
}


#pragma mark - CLLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    float heading = newHeading.magneticHeading; //in degrees
    float headingAngle = -(heading*M_PI/180); //assuming needle points to top of iphone. convert to radians
    currentDeviceBearing = heading;
    //        circle.transform = CGAffineTransformMakeRotation(headingAngle);
    [self rotateArcsToHeading:headingAngle];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //    CLLocation *newLocation = [locations lastObject];
    //    _myLoc = newLocation.coordinate;
}

- (void)rotateArcsToHeading:(CGFloat)angle {
    // rotate the circle to heading degree
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.toValue = [NSNumber numberWithFloat:angle];
//    [arcsView.layer addAnimation:animation forKey:@"animation"];
    for (Dot *dot in dots) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.3];
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        animation.value
//        [animation setDuration:0.3f];
//        animation.fillMode = kCAFillModeForwards;
//        animation.autoreverses = NO;
//        animation.repeatCount = 0;
//        animation.removedOnCompletion = NO;
//        animation.cumulative = YES;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        
//        animation.toValue = [NSNumber numberWithFloat:angle];
//        [dot.layer addAnimation:animation forKey:@"rotationAnimation"];
        dot.transform = CGAffineTransformMakeRotation(-angle);
//        [UIView commitAnimations];
    }
    shareBtn.transform = CGAffineTransformMakeRotation(-angle);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    arcsView.transform = CGAffineTransformMakeRotation(angle);
    [UIView commitAnimations];
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc {
    
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return -degree;
    } else {
        return -(360+degree);
    }
}


#pragma mark - Rotate/Trsnslate Dot

- (void)rotateDot:(Dot*)dot fromBearing:(CGFloat)fromDegrees toBearing:(CGFloat)degrees atDistance:(CGFloat)distance {
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path,nil, HalfScreenW, HalfScreenW, distance, degreesToRadians(fromDegrees), degreesToRadians(degrees), YES);
    
    CAKeyframeAnimation *theAnimation;
    
    // animation object for the key path
    theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    theAnimation.path = path;
    CGPathRelease(path);
    
    // set the animation properties
    theAnimation.duration = 3;
    theAnimation.removedOnCompletion = NO;
    theAnimation.repeatCount = 0;
    theAnimation.autoreverses = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.cumulative = YES;
    
    CGPoint newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+HalfScreenW, distance*sin(degreesToRadians(degrees))+HalfScreenW);
    dot.layer.position = newPosition;
//    [dot dotAddAnimation:theAnimation];
    [dot.layer addAnimation:theAnimation forKey:@"rotateDot"];
}

- (void)translateDot:(Dot*)dot toBearing:(CGFloat)degrees atDistance:(CGFloat)distance {
    
    if (distance < HalfScreenW) {
        if (!dot.isInOutAnimating) {
        
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setFromValue:[NSValue valueWithCGPoint:[[dot.layer.presentationLayer valueForKey:@"position"] CGPointValue] ]];
            CGPoint newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+HalfScreenW,
                                              distance*sin(degreesToRadians(degrees))+HalfScreenW);
            [animation setToValue:[NSValue valueWithCGPoint: newPosition]];
            [animation setDuration:0.3f];
            animation.fillMode = kCAFillModeForwards;
            animation.autoreverses = NO;
            animation.repeatCount = 0;
            animation.removedOnCompletion = NO;
            animation.cumulative = YES;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [dot.layer removeAllAnimations];
            [dot.layer addAnimation:animation forKey:@"translateDot"];
        }
        
        if (dot.type == DotTypeIsGroup) {
            return;
        }
        
        if (dot.isOut) {
            dot.out = NO;
            CAAnimation *enterAnimation = [self getAnimationIsOut:NO duration:0.8f dot:dot];
            dot.ani = enterAnimation;
            [dot.layer addAnimation:enterAnimation forKey:@"dotEnterAnimation"];
            //        }else {//if (!dot.isOutAnimating) {
            //            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            //            [animation setFromValue:[NSValue valueWithCGPoint:[[dot.layer.presentationLayer valueForKey:@"position"] CGPointValue]]];
            //            CGPoint newPosition = CGPointMake(distance*cos(degreesToRadians(degrees))+HalfScreenW,
            //                                              distance*sin(degreesToRadians(degrees))+HalfScreenW);
            //            [animation setToValue:[NSValue valueWithCGPoint: newPosition]];
            //            [animation setDuration:0.3f];
            //            animation.fillMode = kCAFillModeForwards;
            //            animation.autoreverses = NO;
            //            animation.repeatCount = 0;
            //            animation.removedOnCompletion = NO;
            //            animation.cumulative = YES;
            //            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            //            //            [dot.layer removeAllAnimations];
            //            [dot dotAddAnimation:animation];
            //            [dot.layer addAnimation:animation forKey:@"dotTranslate"];
        }
    }else {
        if (dot.type == DotTypeIsGroup) {
            return;
        }
        if (!dot.isOut) {
            dot.out = YES;
            CAAnimation *outAnimation = [self getAnimationIsOut:YES duration:0.8f dot:dot];
            dot.ani = outAnimation;
            [dot.layer addAnimation:outAnimation forKey:@"dotOutAnimation"];
        }
    }
    
    // 显示,隐藏动画
    /*    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
     //    [alphaAnimation setDuration:0.5f];
     //    alphaAnimation.fillMode = kCAFillModeForwards;
     //    alphaAnimation.autoreverses = NO;
     //    alphaAnimation.repeatCount = 0;
     //    alphaAnimation.removedOnCompletion = NO;
     //    alphaAnimation.cumulative = YES;
     //    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
     //    if (distance > 132) {
     //        [alphaAnimation setToValue:[NSNumber numberWithFloat:0.0f]];
     //
     //    }else{
     //        [alphaAnimation setToValue:[NSNumber numberWithFloat:1.0f]];
     //
     //    }*/
    
    // 进出场动画
//    if (distance > HalfScreenW) {
//        
//    }else{
//        
//    }
}


#pragma mark - Get a animation
- (CAAnimation *)getAnimationIsOut:(BOOL)isOut duration:(CFTimeInterval)duration dot:(Dot *)dot{
    
    CGPoint p = [[dot.layer.presentationLayer valueForKey:@"position"] CGPointValue];
    float newDistance = hypot(fabs(p.x-HalfScreenW), fabs(p.y-HalfScreenW));
    
    UIBezierPath *arcPath = nil;
    
    NSMutableArray *anis = [NSMutableArray array];
    
    if (isOut) {
        
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//        [animation setFromValue:[NSValue valueWithCGPoint:[[dot.layer.presentationLayer valueForKey:@"position"] CGPointValue] ]];
//        CGPoint newPosition = CGPointMake(HalfScreenW * cos(degreesToRadians(dot.bearing.floatValue))+HalfScreenW,
//                                          HalfScreenW * sin(degreesToRadians(dot.bearing.floatValue))+HalfScreenW);
//        [animation setToValue:[NSValue valueWithCGPoint: newPosition]];
//        [animation setDuration:0.3f];
//        animation.fillMode = kCAFillModeForwards;
//        animation.autoreverses = NO;
//        animation.repeatCount = 0;
//        animation.removedOnCompletion = NO;
//        animation.cumulative = YES;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        [anis addObject:animation];
        
        arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(HalfScreenW, HalfScreenW)
                                                 radius:newDistance
                                             startAngle:degreesToRadians(dot.bearing.floatValue)
                                               endAngle:degreesToRadians(dot.bearing.floatValue)-M_PI_2
                                              clockwise:NO];
    }else {
        arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(HalfScreenW, HalfScreenW)
                                                 radius:newDistance
                                             startAngle:degreesToRadians(dot.bearing.floatValue)+M_PI_2
                                               endAngle:degreesToRadians(dot.bearing.floatValue)
                                              clockwise:NO];
    }
    CAKeyframeAnimation *arc = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    arc.duration             = duration;
    arc.fillMode             = kCAFillModeForwards;
    arc.autoreverses         = NO;
    arc.removedOnCompletion  = NO;
    arc.timingFunction       = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    arc.path                 = arcPath.CGPath;
    [anis addObject:arc];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [alphaAnimation setDuration:duration];
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.autoreverses = NO;
    alphaAnimation.removedOnCompletion = NO;
    [alphaAnimation setFromValue:[NSNumber numberWithFloat:isOut ? 1.f : 0.f]];
    [alphaAnimation setToValue:[NSNumber numberWithFloat:isOut ? 0.f : 1.f]];
    [anis addObject:alphaAnimation];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = duration;
    group.autoreverses = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = [anis copy];
    
    return group;
}


#pragma mark - Detect Collisions

- (void)detectCollisions:(NSTimer*)theTimer {
    
    float radarLineRotation = radiandsToDegrees([[radarLine.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue]);
    
    if (radarLineRotation >= 0) {
        radarLineRotation -= 360;
    }
    
    
    for (int i = 0; i < [dots count]; i++) {
        Dot *dot = [dots objectAtIndex:i];
        
        float dotBearing = [dot.bearing floatValue] - currentDeviceBearing;
        
        if (dotBearing < -360) {
            dotBearing += 360;
        }
        
        // collision detection
        if( ABS(dotBearing - radarLineRotation) <=  20)
        {
            [self pulse:dot];
        }
    }
}
- (void)pulse:(Dot*)dot {
    
    if([dot.layer.animationKeys containsObject:@"dotPulse"] || dot.zoomEnabled){ // view is already animating. so return
        return;
    }
    
    CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 0.15;
    pulse.toValue = [NSNumber numberWithFloat:1.4];
    pulse.autoreverses = YES;
    dot.layer.contentsScale = [UIScreen mainScreen].scale; // Retina
//    [dot dotAddAnimation:pulse];
    [dot.layer addAnimation:pulse forKey:@"dotPulse"];
}


#pragma mark - Slider

- (void)sliderValueChange:(UISlider *)sender {
    
    float new_distance = [sender value];
    
    for (Dot *dot in dots) {
        if (dot.type == DotTypeIsGroup) {
            dot.value = (new_distance - sender.minimumValue) / (sender.maximumValue - sender.minimumValue);
        }
    }
    
    float distanceFilter = 0;
    for (int i = 0; i < self.radarInfo.radarItemList.count; i++) {
        LBRadarItemM *itemM = self.radarInfo.radarItemList[i];
        
        float distance = itemM.distance;
        float nextDistance = distance;
        //NSLog(@"distance %f <--->nextDistance %f ===>distanceFilter %f",distance, nextDistance, distanceFilter);
        
        if (i < self.radarInfo.radarItemList.count - 1) {
            LBRadarItemM *itemM = self.radarInfo.radarItemList[i + 1];
            nextDistance = itemM.distance;
        }
        
        if (distance <= new_distance && nextDistance >= new_distance) {
            if (nextDistance == new_distance) {
                distanceFilter = nextDistance;
            }else{
                distanceFilter = distance;
            }
            //NSLog(@"%f <---> %f ===> %f",distance, nextDistance, distanceFilter);
            break;
        }
    }
    
    int showCount = 0;
    for (Dot *dot in dots) {
        if (!dot.isOut) {
            if (dot.type == DotTypeIsGroup) {
                for (Dot *subDot in dot.subDots) {
                    if (!subDot.isOut) {
                        showCount ++;
                    }
                }
            }else if (dot.type == DotTypeIsImage) {
                showCount ++;
            }
        }
    }
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm内%d个消息", (float)new_distance/1000, showCount];
//    NSLog(@"更新消息提示%@",self.distanceLabel.text);
    static float last_distanceFilter;
//    NSLog(@"sliderValueChange: %f  distanceFilter:%f", new_distance, distanceFilter);
    if (last_distanceFilter == distanceFilter) {    // 如果两次距离一样, 就不做操作, 否则会动画重复加载, 出现抽搐
        return;
    }
    last_distanceFilter = distanceFilter;
    
    // 原始代码
//    float new_distance = [sender value];
//    float distanceFilter = 0;
//    for (int i = 0; i < [nearbyUsers count]; i++) {
//        NSDictionary *user = nearbyUsers[i];
//        
//        float distance = [[user valueForKey:@"distance"] floatValue];
//        float nextDistance = distance;
//        //NSLog(@"distance %f <--->nextDistance %f ===>distanceFilter %f",distance, nextDistance, distanceFilter);
//        
//        if (i< [nearbyUsers count]-1) {
//            NSDictionary *nextUser = nearbyUsers[i+1];
//            nextDistance = [[nextUser valueForKey:@"distance"] floatValue];
//        }
//        
//        if (distance <= new_distance && nextDistance >= new_distance) {
//            if (nextDistance == new_distance) {
//                distanceFilter = nextDistance;
//            }else{
//                distanceFilter = distance;
//            }
//            //NSLog(@"%f <---> %f ===> %f",distance, nextDistance, distanceFilter);
//            break;
//        }
//    }
    
    [self filterNearByUsersByDistance: distanceFilter];
}

- (void)panSlider:(UIGestureRecognizer *)ges {
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    static CGFloat beginX;
    
//    CGFloat gesTrueY = [ges locationInView:window].y;
    CGFloat gesTrueX = [ges locationInView:window].x;
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        beginX = gesTrueX;
        distanceSlider.userInteractionEnabled = NO;
//        self.sliderViewCover.alpha = 0.f;
//        self.sliderViewCover.hidden = NO;
//        [self.sliderViewCover removeFromSuperview];
//        [window addSubview:self.sliderViewCover];
//        
//        self.distanceLabel.alpha = 0.f;
//        self.distanceLabel.hidden = NO;
//        [self.distanceLabel removeFromSuperview];
//        [window addSubview:self.distanceLabel];
//        
//        CGRect rect = self.sliderViewCover.frame;
//        rect.origin.x = gesTrueX;
//        self.sliderViewCover.frame = rect;
//        
//        [UIView animateWithDuration:0.2 animations:^{
//        
//            distanceSlider.alpha = 0.f;
//            self.sliderViewCover.alpha = 0.4f;
//            self.distanceLabel.alpha = 0.4f;
//            
//        } completion:nil];
        
    }else if (ges.state == UIGestureRecognizerStateChanged) {
        
        distanceSlider.userInteractionEnabled = YES;
        CGFloat changeValue = gesTrueX - beginX;
        distanceSlider.value += changeValue * unitDistance;
        [self sliderValueChange:distanceSlider];
        [self sliderValueChange:distanceSlider];
        
//        CGRect rect = self.sliderViewCover.frame;
//        rect.origin.x = gesTrueX;
//        self.sliderViewCover.frame = rect;
//        
//        CGRect frame = self.distanceLabel.frame;
//        
//        CGFloat labelWidth = self.distanceLabel.frame.size.width;
//        CGFloat labelHeight = self.distanceLabel.frame.size.height;
//        
//        frame.origin.x = gesTrueX > HalfScreenW ? (gesTrueX - labelWidth) : gesTrueX;
//        frame.origin.y = gesTrueY - labelHeight;
//        
//        self.distanceLabel.frame = frame;
        
        beginX = gesTrueX;
        
    }else if (ges.state == UIGestureRecognizerStateEnded) {
        
        distanceSlider.userInteractionEnabled = YES;
        
//        [UIView animateWithDuration:0.2 animations:^{
//        
//            distanceSlider.alpha = 1.f;
//            self.sliderViewCover.alpha = 0.f;
//            self.distanceLabel.alpha = 0.f;
//            
//        }completion:^(BOOL finished) {
//            
//            self.sliderViewCover.hidden = YES;
//            [self.sliderViewCover removeFromSuperview];
//            [self.distanceLabel removeFromSuperview];
//        }];
    }
}

// 替换slider的触发, 一个大出滚动条触发区域的滑动手势
- (void)panFilter:(UIPanGestureRecognizer *)panGes {
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    static CGFloat beginX;
    
    CGFloat gesTrueX = [panGes locationInView:window].x;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
        beginX = gesTrueX;
        
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        
        distanceSlider.userInteractionEnabled = YES;
        CGFloat changeValue = gesTrueX - beginX;
        distanceSlider.value += changeValue * unitDistance;
        [self sliderValueChange:distanceSlider];
        [self sliderValueChange:distanceSlider];
        beginX = gesTrueX;
        
    }else if (panGes.state == UIGestureRecognizerStateEnded) {
        
    }
}


#pragma mark - Abandon

- (UIView *)sliderViewCover
{
    if (!_sliderViewCover) {
        
        _sliderViewCover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _sliderViewCover.hidden = YES;
        _sliderViewCover.backgroundColor = [UIColor blackColor];
        _sliderViewCover.alpha = 0.3;
    }
    return _sliderViewCover;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        
        _distanceLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0, 0, 130, 94)];
        _distanceLabel.numberOfLines = 1;
//        _distanceLabel.layer.cornerRadius = 5.f;
//        _distanceLabel.layer.borderWidth = 2.f;
//        _distanceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _distanceLabel.textColor = [UIColor whiteColor];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.font = [UIFont systemFontOfSize:14];
//        _distanceLabel.hidden = YES;
    }
    return _distanceLabel;
}


#pragma mark - Radar MATH func

// for this function to work, sorting of users data by distance in ASC order (nearest to farthest) is a must
-(void) filterNearByUsersByDistance: (float)maxDistance{
    for (Dot *d in dots) {
        //        float distance = MAX(50,[d.userDistance floatValue] * (ScreenWidth * 0.5 - 45) / maxDistance);
        float distance = MAX(55,[d.userDistance floatValue] * (kScreenWidth * 0.5 - 45) / maxDistance);
        [self translateDot:d toBearing:[d.bearing floatValue] atDistance: distance];
    }
    /*
     *  假数据时代码
     */
//    for (id d in dots) {
//        Dot *dot = (Dot *)d;
//        float distance = MAX(50,[dot.userDistance floatValue] * (ScreenWidth * 0.5 - 45) / maxDistance);
//        [self translateDot:dot toBearing:[dot.bearing floatValue] atDistance: distance];
//    }
}


#pragma mark - Click event

- (void)shareClick:(UIButton *)button {
    
    [[LoginManager shareManager] checkUserLoginState:^{
        [self hiddenAllUserIcon];
        ShareViewController *shareVC = [[ShareViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
}

- (void)reduceBtnClick:(UIButton *)nearlyBtn {
    
    [self hiddenAllUserIcon];
    CGFloat maxValue = distanceSlider.maximumValue;
    CGFloat minValue = distanceSlider.minimumValue;
    CGFloat unitValue = (maxValue - minValue) * 0.2f;
    CGFloat popValue = (distanceSlider.value - unitValue) < minValue ? minValue : distanceSlider.value - unitValue;
    distanceSlider.value = popValue;
    [self sliderValueChange:distanceSlider];
    [self sliderValueChange:distanceSlider];
}

- (void)addBtnClick:(UIButton *)farBtn {
    
    [self hiddenAllUserIcon];
    CGFloat maxValue = distanceSlider.maximumValue;
    CGFloat minValue = distanceSlider.minimumValue;
    CGFloat unitValue = (maxValue - minValue) * 0.2f;
    CGFloat popValue = (distanceSlider.value + unitValue) > maxValue ? maxValue : distanceSlider.value + unitValue;
    distanceSlider.value = popValue;
    [self sliderValueChange:distanceSlider];// 调用两次是因为，第一次调用的时候, dot的out属性还没更改, 第二次的时候才能查询到
    [self sliderValueChange:distanceSlider];
}


#pragma mark - Tap Event on Dot

- (void)onDotTapped:(UITapGestureRecognizer *)recognizer {
    
    UIView *circleView = recognizer.view;
    CGPoint point = [recognizer locationInView:circleView];
    
    NSMutableArray *tappedUsers = [NSMutableArray array];
    NSMutableArray *tappedImgs = [NSMutableArray array];
    
    for (Dot *d in dots) {
//        if (d.zoomEnabled) {
//            // remove selection from previously selected dot(s)
        d.zoomEnabled = NO;
////            d.layer.borderColor = [UIColor clearColor].CGColor;
//            [d setNeedsDisplay];
//        }
        if([d.layer.presentationLayer hitTest:point] != nil){
//            NSLog(@"dot.isOut %d, dot.alpha %f", d.isOut, d.alpha);
            if (d.isOut) continue;
            if (d.type == DotTypeIsGroup) {
                for (Dot *subDot in d.subDots) {
                    if (!subDot.isOut) {
                        [tappedImgs addObject:subDot];
                    }
                }
            }else if (d.type == DotTypeIsImage) {
                [tappedImgs addObject:d];
            }else {
                [tappedUsers addObject:d];
            }
            // Show white border for selected dot(s) and zoom out a little bit
            //            d.layer.borderColor = [UIColor whiteColor].CGColor;
            //            d.layer.borderWidth = d.type == DotTypeIsGroup ? 0.f : 1.f;
            //            d.layer.cornerRadius = d.type == DotTypeIsPoint ? DotWidth * 0.5 : 0.f;
            //            [d setNeedsDisplay];
//            [self pulse:d];
            d.zoomEnabled = YES; // it'll keep a trace of selected dot(s)
        }
    }
    
    if (tappedImgs.count) {
        [self hiddenAllUserIcon];
        [self.collectionDataSource removeAllObjects];
        for (Dot *imgDot in tappedImgs) {
            [self.collectionDataSource addObject:imgDot.radarItem];
            [self.collectionView reloadData];
        }
        self.showList = YES;
    }else if (tappedImgs.count == 0 && tappedUsers.count) {
        Dot *d = [tappedUsers lastObject];
        [self pulse:d];
        [self showUserBubble:d];
        [self hiddenCollectionView];
    }else if (tappedUsers.count == 0 && tappedImgs.count == 0) {
        
        [self hiddenAllUserIcon];
        if (self.isShowList)    [self tapCover:nil];
    }
}


#pragma mark - Show user bubble

- (void)showUserBubble:(Dot *)dot {
    
    if (dot.isShowIcon) {
        [self hiddenAllUserIcon];
        if (dot.radarItem.Type == 1) {  // 用户
            UserHomeViewController *userHome = [[UserHomeViewController alloc] init];
            userHome.userId = dot.radarItem.ID;
            [self.navigationController pushViewController:userHome animated:YES];
        }else { // 导购
            GuideHomeViewController *guiderHome = [[GuideHomeViewController alloc] init];
            guiderHome.gid = dot.radarItem.ID;
            guiderHome.statisticChatOfHome = ID_0201030180013;
            [self.navigationController pushViewController:guiderHome animated:YES];
        }
    }else {
        
        [self hiddenAllUserIcon];
        [arcsView bringSubviewToFront:dot];
        dot.showIcon = YES;
    }
}


#pragma mark - Hidden all userIcon

- (void)hiddenAllUserIcon {
    
    for (Dot *dot in dots) {
        if (dot.type == DotTypeIsImage || dot.type == DotTypeIsGroup) {
            [arcsView bringSubviewToFront:dot];
        }
        if (!dot.isOut) {
            dot.showIcon = NO;
        }
    }
    [arcsView bringSubviewToFront:shareBtn];
}


#pragma mark - Show colleciton view

- (void)setShowList:(BOOL)showList {
    
    if (_showList == showList)    return;
    
    _showList = showList;
    
    if (self.isShowList) {
        
        distanceSlider.hidden = YES;
        nearlyBtn.hidden = YES;
        farBtn.hidden = YES;
        
        //        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [self.collectionView removeFromSuperview];
        [self.view.superview addSubview:self.collectionView];
        //        [window addSubview:self.collectionView];
        //        [window bringSubviewToFront:self.collectionView];
        self.collectionView.frame = collectionViewZeroRect;
        self.collectionView.hidden = NO;
        
        self.collectionViewAnimation = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.collectionView.frame = collectionViewRect;
            
        } completion:^(BOOL finished) {
            
            self.collectionViewAnimation = NO;
            [self.collectionView reloadData];
        }];
    }
}


#pragma mark - Collection view cover _BE_ABANDON__

- (UIView *)collectionViewCover
{
    if (!_collectionViewCover) {
        
        _collectionViewCover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _collectionViewCover.backgroundColor = [UIColor blackColor];
        _collectionViewCover.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
        [_collectionViewCover addGestureRecognizer:tap];
    }
    return _collectionViewCover;
}

- (void)tapCover:(UIGestureRecognizer *)ges {
    
    if (self.isShowList) {
        
        self.collectionViewAnimation = YES;
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.collectionView.frame = collectionViewZeroRect;
            self.collectionViewCover.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            self.showList = NO;
            // Remove items
            [self.collectionViewCover removeFromSuperview];
            [self.collectionView removeFromSuperview];
            // Remove data source
            [self.collectionDataSource removeAllObjects];
            [self.collectionView reloadData];
            // show slider & btns
            distanceSlider.hidden = NO;
            nearlyBtn.hidden = NO;
            farBtn.hidden = NO;
            self.collectionView.hidden = YES;
            self.collectionViewAnimation = NO;
        }];
    }
}


#pragma mark - Collection view

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CGRect superRect = self.view.superview.frame;
        CGFloat superHeight = superRect.size.height;
        collectionViewHeight = [RadarInfoCell lb_getSize].height + 15;
        collectionViewRect = CGRectMake(0, superHeight - collectionViewHeight - 49.f, ScreenW, collectionViewHeight);
        
        CGFloat colW = collectionViewRect.size.width;
        CGFloat colH = 0.f;
        CGFloat colX = collectionViewRect.origin.x;
        CGFloat colY = collectionViewRect.origin.y + collectionViewRect.size.height * 0.5;
        collectionViewZeroRect = CGRectMake(colX, colY, colW, colH);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect
                                             collectionViewLayout:layout];
        [_collectionView registerClass:[RadarInfoCell class]
            forCellWithReuseIdentifier:NSStringFromClass([RadarInfoCell class])];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.hidden = YES;
        _collectionView.backgroundColor = GJGRGBAColor(0, 0, 0, 0.6);
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
//    NSLog(@"lb_debug_numOfItem:%@", self.collectionDataSource);
    return self.isCollectionViewAnimation ? 0 : self.collectionDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RadarInfoCell *cell = [RadarInfoCell cellWithCollectionView:collectionView andIndexPath:indexPath];
    LBRadarItemM *radarItem = self.collectionDataSource[indexPath.row];
    if (radarItem.Type == RadarItemTypeIsGuideInfo) {
        cell.radarType = RadarTypeIsGuide;
    }else {
        cell.radarType = RadarTypeIsSharedOrder;
    }
    cell.radarItem = radarItem;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.alpha = 0.f;
    [UIView animateWithDuration:0.15f animations:^{
        cell.alpha = 1.f;
    } completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self hiddenAllUserIcon];
    LBRadarItemM *radarItem = self.collectionDataSource[indexPath.row];
    if (radarItem.Type == 3) {  // 晒单
        SharedOrderDetailViewController *sharedOrderVC = [[SharedOrderDetailViewController alloc] init];
        sharedOrderVC.infoId = radarItem.ID;
        [self.navigationController pushViewController:sharedOrderVC animated:YES];
    }else { // 导购
        ShopGuideDetailViewController *guideVC = [[ShopGuideDetailViewController alloc] init];
        guideVC.infoid = radarItem.ID;
        guideVC.statisticSendMsg = ID_0201030130002;
        guideVC.statisticLike = ID_0201030110003;
        guideVC.statisticShare = ID_0201030120004;
        [self.navigationController pushViewController:guideVC animated:YES];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(4, 2, 0, 2);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [RadarInfoCell lb_getSize];
}

- (void)hiddenCollectionView {
    [self tapCover:nil];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxDraggingValue = kScreenWidth * 0.35;
    
    if (offsetY <= 0 && offsetY >= -maxDraggingValue) {
        if ([self.delegate respondsToSelector:@selector(radarView:DidDragging:)]) {
            [self.delegate radarView:self DidDragging:(1 + offsetY/maxDraggingValue)];
        }
    }
}

@end
