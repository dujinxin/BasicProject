//
//  WebViewController.m
//  GJieGo
//
//  Created by liubei on 2016/11/22.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "WebViewController.h"

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

@interface WebViewController ()<UIWebViewDelegate> {
    
    UIView *statusBackView;
}
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) WebViewJavascriptBridge *bridge;
@property (nonatomic,strong) GJGShareInfo *shareInfo;

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview: self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    [self.view addSubview:statusBackView];
    
    UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 20, 40, 40);
    [button addTarget:self
               action:@selector(buttonDidClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:img forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [self buildBridge];
}

- (void)buildBridge {
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    // @[@"getParames", @"goRelease", @"goShowDetails", @"shareToSocialSoftware",@"goodJob"]
    [self.bridge registerHandler:@"getParames" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"getParames data: %@", data);
        [self getParames:data[@"type"] Callback:responseCallback];
    }];
    [self.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
}

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
            [self.navigationController pushViewController:shareVc animated:YES];
            return;
        }];
    }
    
    if(type.intValue == 7){// 跳转到晒单详情
//        BaseTabBarController *baseTBVc = (BaseTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        BaseNavigationController *homeNav = baseTBVc.viewControllers[2];
        NSString *ID = arrtype[1];
        SharedOrderDetailViewController *detailVc = [[SharedOrderDetailViewController alloc] init];
        detailVc.infoId = [ID integerValue];
        [self.navigationController pushViewController:detailVc animated:YES];
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

- (void)buttonDidClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
