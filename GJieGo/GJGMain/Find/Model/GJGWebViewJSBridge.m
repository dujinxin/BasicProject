//
//  GJGWebViewJSBridge.m
//  GJieGo
//
//  Created by gjg on 16/7/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGWebViewJSBridge.h"
#import "ShareManager.h"

@interface GJGWebViewJSBridge ()

@property (nonatomic,copy) NSString *type;

@end

@implementation GJGWebViewJSBridge


#pragma mark - 给JS传递 需要的参数
- (NSString *)getParames:(NSString *)type{
    
    self.type = type;
    
    NSString *Token;
    
    NSString *Version = kAppVersion;
    
    NSString *Package = kPackage;
    
    NSString *Channel = @"appStore";
    
    NSString *Mac = @"";
    
    NSString *IP = @"";
    
    CGFloat longitude = [GJGLocationManager sharedManager].longitude;
    
    CGFloat latitude = [GJGLocationManager sharedManager].latitude;
    
    if ([[LoginManager shareManager] isHadLogin] ) { // 是否登录
        
        Token = [UserDBManager shareManager].Token;
    }else{
        Token = [kUserDefaults objectForKey:UDKEY_VisitorToken];
    }
    
    NSString *str = [NSString stringWithFormat:@"{Version:%@,Package:%@,Token:%@,Channel:%@,longitude:%f,latitude:%f,Mac:%@,IP:%@}",Version,Package,Token,Channel,longitude,latitude,Mac,IP];
    
    return str;
}

#pragma mark - 分享到社交软件
- (void)shareToSocialSoftware:(NSString *)json{
    
    // typ = 0 弹出登录页面 typ = 1 已经登录
    if(self.type.intValue == 0 && ![[LoginManager shareManager] isHadLogin]){
        // 弹出登录界面
        [[LoginManager shareManager] presentLoginViewController:YES loginSuccess:^{
//                [ShareManager shareManager] showCustomShareViewWithObject:<#(id)#> presentedController:self success:<#^(id object, UserShareSns sns)success#> failure:<#^(id object, UserShareSns sns)failure#>
        } cancel:^{
            
        }];
    }
}

- (bool)goodJob:(NSString *)ID{
    
    
    return true;
}
@end
