//
//  GJGFindController.m
//  GJieGo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGFindController.h"

#import "LoginManager.h"

#import "LBRequestManager.h"
#import "CustomURLCache.h"

#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

#import "WebViewJavascriptBridge.h"
#import "HybirdUrlHandler.h"
#import "HyBridBridge.h"

#import "GeneralMarketController.h"
#import "RestaurantClassController.h"
#import "FilmClassController.h"

#import "ShopCenterController.h"
#import "ShareViewController.h"
#import "SharedOrderDetailViewController.h"

@interface GJGFindController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,HybridUrlHanlder>

@property (nonatomic,copy) NSString *type;

@property (nonatomic,strong) WebViewJavascriptBridge *bridge;

@property (nonatomic,strong) HyBridBridge *hyBirdBridge;

/**分享详情*/
@property (nonatomic,strong) GJGShareInfo *shareInfo;

@end

@implementation GJGFindController{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
    BOOL isNotFirstLoad;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initAttributs];
    [self setProgress];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)loadWebView{

    NSURL *url = [NSURL URLWithString:kDiscoveryUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    // @[@"getParames", @"goRelease", @"goShowDetails", @"shareToSocialSoftware",@"goodJob"]
    [self.bridge registerHandler:@"getParames" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"getParames data: %@", data);
        [self getParames:data[@"type"] Callback:responseCallback];
    }];
    [self.bridge registerHandler:@"goRelease" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [self goRelease];
        NSLog(@"goRelease data: %@", data);
    }];
    [self.bridge registerHandler:@"goShowDetails" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [self goShowDetails:data];
        NSLog(@"goShowDetails %@", data);
    }];
    // 建立桥接
//    [self.hyBirdBridge registerHybridUrlHanlder:self andBridge:self.bridge];
    // 注册
    [self.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
}


#pragma mark - Lazy

- (UIWebView *)webView {
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20 - 49)];
            _webView.opaque = NO;
        [self.view addSubview:_webView];
        _webView.delegate = self;
        self.view.backgroundColor = GJGRGB16Color(0xfee330);
//        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

- (HyBridBridge *)hyBirdBridge{
    if (!_hyBirdBridge) {
        _hyBirdBridge = [[HyBridBridge alloc] init];
    }
    return _hyBirdBridge;
}


#pragma mark - Init

- (void)initAttributs {
    
    self.navigationItem.title = @"发现";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 设置代理
- (void)setProgress{
    _webViewProgress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _webViewProgress;
    _webViewProgress.webViewProxyDelegate = self;
    _webViewProgress.progressDelegate = self;
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                    navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self loadWebView];
    _webViewProgressView.frame = CGRectMake(0, 64, ScreenWidth, 2);
    [self.view addSubview:_webViewProgressView];
//    [self.navigationController.navigationBar addSubview:_webViewProgressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [_webViewProgressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 定义支持的方法名称
//- (NSArray *)actionNames{
//    return @[@"getParames", @"goRelease", @"goShowDetails"];
////    return @[@"getParames", @"goRelease", @"goShowDetails", @"shareToSocialSoftware",@"goodJob"];
//}

#pragma mark - 注册对应的方法
//- (BOOL)handleDictionAry:(NSDictionary *)dictionary callback:(HybridCallbackBlock)callbackBlock{
//    
//    NSString *actionTag = dictionary[@"actionName"];
//    
//    if ([actionTag isEqualToString:@"getParames"]) {
//        _callBackBlock = [callbackBlock copy];
//        [self getParames:dictionary[@"type"] Callback:callbackBlock];
//        return YES;
//    }else if ([actionTag isEqualToString:@"goRelease"]) {
//        [self goRelease];
//        return YES;
//    }else if ([actionTag isEqualToString:@"goShowDetails"]) {
//        [self goShowDetails:dictionary[@"type"]];
//        return YES;
//    }
//    
////    if ([actionTag isEqualToString:@"shareToSocialSoftware"]) {
////        [self shareToSocialSoftware:dictionary[@"json"]];
////        return YES;
////    }
////    
////    if ([actionTag isEqualToString:@"goodJob"]) {
////        [self goodJob:dictionary[@"state"]];
////        return YES;
////    }
//    
//    return NO;
//}


#pragma mark - jsWebView 交互 method
// 给JS传递 需要的参数
- (void)getParames:(NSString *)Type Callback:(HybridCallbackBlock)callbackBlock{
    
    
    NSArray *arrtype = [Type componentsSeparatedByString:@","];
    NSString *type = arrtype[0];
    NSLog(@"str:%@", Type);
    if (type.intValue == 2) { // 分享
        int shareType = GJGShareInfoTypeIsFind;
        NSString *ID = arrtype[1];
        if (arrtype.count > 2) {
            shareType = GJGShareInfoTypeIsActivity;
        }
        
       [[LoginManager shareManager] checkUserLoginState:^{
           
           [[LBRequestManager sharedManager] getSharedInfoWithInfoId:ID.intValue
                                                            infoType:shareType
                                                              result:^(id responseobject, NSError *error)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    
                    GJGShareInfo *shareInfo = responseobject;
//                    NSString *url = [NSString stringWithFormat:@"%@?share=1", shareInfo.Url];

                    [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                          title:shareInfo.Title
                                                                       imageUrl:shareInfo.Images
                                                                            url:shareInfo.Url
                                                                    description:@""
                                                                         infoId:ID
                                                                      shareType:UserShopHomeShareType
                                                            presentedController:self
                                                                        success:^(id object, UserShareSns sns){}
                                                                        failure:^(id object, UserShareSns sns) {
                                                                            NSLog(@"分享失败.");
                                                                        }];
//                    [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
//                                                                          title:shareInfo.Title
//                                                                       imageUrl:shareInfo.Images
//                                                                            url:shareInfo.Url
//                                                                    description:@""
//                                                            presentedController:self
//                                                                        success:^(id object, UserShareSns sns)
//                     {
//                         [DJXRequest requestWithBlock:kApiShareSuccess
//                                                param:@{@"InfoId" : ID,
//                                                        @"infoType" : @(GJGShareInfoTypeIsFind),
//                                                        @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]}
//                                              success:^(id object){
//                                                  if([object isKindOfClass:[NSString class]]){
//                                                      [MBProgressHUD showSuccess:object toView:self.view];
//                                                  }
//                                              }
//                                              failure:^(id object){}];
//                     } failure:^(id object, UserShareSns sns){
//
//                     }];
                }else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showError:@"获取分享内容失败, 请检查网络." toView:self.view];
                }
            }];
        }];
    }
    
    if(type.intValue == 3){ // 点赞
        [[LoginManager shareManager] checkUserLoginState:^{
            
        }];
    }
    
    if(type.intValue == 4){ // 跳转到店铺首页
        BaseTabBarController *baseVC = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        BaseNavigationController *Vc = baseVC.viewControllers[2];
        NSString *shopID = arrtype[2];
        NSString *infoType = arrtype[3];
        
        if ([infoType isEqualToString:@"supermarket"]) {//超市    ②③
            GeneralMarketController *controller = [[GeneralMarketController alloc] init];
            //        controller.title = item.ShopName;
            controller.shopId = [NSString stringWithFormat:@"%@", shopID];
            NSLog(@"跳转shopid : %@  infoType: %@",shopID,infoType);
            [Vc pushViewController:controller animated:YES];
            
        }else if ([infoType isEqualToString:@"cafe"] || [infoType isEqualToString:@"hotel"] || [infoType isEqualToString:@"ktv"] || [infoType isEqualToString:@"restaurant"]){//咖啡店、酒店、KTV、美食  ①②
            RestaurantClassController *controller = [[RestaurantClassController alloc] init];
            //        controller.title = item.ShopName;
            controller.shopId = shopID;
            //        [Vc.navigationController  pushViewController:controller animated:YES];
            
            [Vc pushViewController:controller animated:YES];
            
        }else{//影院、亲子、甜点饮品、美业、酒吧、健身、培训、足疗按摩、宠物店 ②
            
            FilmClassController *controller = [[FilmClassController alloc] init];
            //        controller.title = item.ShopName;
            controller.shopId = shopID;
            [Vc pushViewController:controller animated:YES];
         
        }
        return;
    }
    
    if(type.intValue == 5){// 跳转到商场
        BaseTabBarController *baseVC = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        BaseNavigationController *Vc = baseVC.viewControllers[2];
        ShopCenterController *controller = [[ShopCenterController alloc] init];
        NSString *shopID = arrtype[2];
        NSString *infoType = arrtype[3];
        
        NSLog(@"shopid:%@,infotype:%@",shopID,infoType);
        if ([infoType isEqualToString:@"shoppingcenter"] || [infoType  isEqualToString:@"departmentstore"]) {
            //购物中心
            controller.type = 1;
        }else{
            //电器卖场
            controller.type = 2;
            
        }
        controller.mId = shopID;
        [Vc pushViewController:controller animated:YES];
          return;
    }
    
    if(type.intValue == 5){// 跳转到商场
        BaseTabBarController *baseVC = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        BaseNavigationController *Vc = baseVC.viewControllers[2];
        ShopCenterController *controller = [[ShopCenterController alloc] init];
        NSString *shopID = arrtype[2];
        NSString *infoType = arrtype[3];
        
        NSLog(@"shopid:%@,infotype:%@",shopID,infoType);
        if ([infoType isEqualToString:@"shoppingcenter"] || [infoType  isEqualToString:@"departmentstore"]) {
            //购物中心
            controller.type = 1;
        }else{
            //电器卖场
            controller.type = 2;
            
        }
        controller.mId = shopID;
        [Vc pushViewController:controller animated:YES];
        return;
    }
    
    if(type.intValue == 6){// 跳转到发布晒单
        [[LoginManager shareManager] checkUserLoginState:^{
            BaseTabBarController *baseTBVc = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            BaseNavigationController *homeNav = baseTBVc.viewControllers[2];
            ShareViewController *shareVc = [[ShareViewController alloc] init];
            if (arrtype.count > 2) {
                shareVc.activityName = arrtype[1];
                shareVc.activityId = arrtype[2];
            }
            [homeNav pushViewController:shareVc animated:YES];
            return;
        }];
    }
    
    if(type.intValue == 7){// 跳转到晒单详情
        
        BaseTabBarController *baseTBVc = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        BaseNavigationController *homeNav = baseTBVc.viewControllers[2];
        NSString *ID = arrtype[1];
        SharedOrderDetailViewController *detailVc = [[SharedOrderDetailViewController alloc] init];
        detailVc.infoId = [ID integerValue];
        [homeNav pushViewController:detailVc animated:YES];
        return;
    }
    
    self.type = type;
    
    NSString *Token;
    
    NSString *Version = kAppVersion;
    
    NSString *Package = kPackage;
    
    NSString *Channel = @"appStore";
    
    NSString *Mac = @"";
    
    NSString *IP = @"";
    
    CGFloat longitude = [GJGLocationManager sharedManager].longitude;
    
    CGFloat latitude = [GJGLocationManager sharedManager].latitude;
    
    NSString *loginstate;
    if([LoginManager shareManager].isHadLogin){
        loginstate = @"0";
    }else{
        loginstate = @"1";
    }

    if ([[LoginManager shareManager] isHadLogin] ) { // 是否登录
        
        Token = [UserDBManager shareManager].Token;
    }else{
        Token = [kUserDefaults objectForKey:UDKEY_VisitorToken];
    }

    NSString *str = [NSString stringWithFormat:@"%@,%@,%@,%@,%f,%f,%@,%@,%@",Version,Package,Token,Channel,longitude,latitude,Mac,IP,loginstate];
    
        callbackBlock(str);

}

//// 分享到社交软件
//- (NSString *)shareToSocialSoftware:(NSString *)json{
//    
//    BOOL isHadLogin = [[LoginManager shareManager] checkUserLoginState:^{
//        
//    }];
//    
//    [[LBRequestManager sharedManager] getSharedInfoWithInfoId:json.integerValue
//                                                     infoType:GJGShareInfoTypeIsFind
//                                                       result:^(id responseobject, NSError *error)
//     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
//         if (!error) {
//             
//             GJGShareInfo *shareInfo = responseobject;
//             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
//                                                                   title:shareInfo.Title
//                                                                imageUrl:shareInfo.Images
//                                                                     url:shareInfo.Url
//                                                             description:@""
//                                                     presentedController:self
//                                                                 success:^(id object, UserShareSns sns)
//              {
////                  [MBProgressHUD showSuccess:@"分享成功, 获得5成长值" toView:self.view];
//              } failure:^(id object, UserShareSns sns){
//
//              }];
//         }else {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             [MBProgressHUD showError:@"获取分享内容失败, 请检查网络." toView:self.view];
//         }
//     }];
////
//    return isHadLogin?@"0":@"1";
//}
// 点赞
//- (int)goodJob:(NSString *)ID{
//
//    BOOL isHadLogin = [[LoginManager shareManager] checkUserLoginState:^{
//        
//    }];
//    
//    if (isHadLogin) {
//        return 0;
//    }else{
//        return 1;
//    }
//}
//
//
//#pragma mark - 分享
//- (void)shareTo{
//    
//    
//    
//}

@end



