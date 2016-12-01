//
//  SGAlertUtil.m
//  SGShow
//
//  Created by fanshijian on 15-3-10.
//  Copyright (c) 2015年 fanshijian. All rights reserved.
//

#import "SGAlertUtil.h"
#import "SGSettingUtil.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
//#import "XMGlobleUtil.h"

@implementation SGAlertUtil
@synthesize isShow;

+ (id)alertManager {
    static SGAlertUtil *alertUtil;
    if (!alertUtil) {
        @synchronized(self) {
            if (!alertUtil) {
                alertUtil = [[SGAlertUtil alloc] init];
            }
        }
    }
    return alertUtil;
}

- (id)init {
    self = [super init];
    if (self) {
        promptHUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].delegate.window];
        promptHUD.removeFromSuperViewOnHide = YES;
        
        isShow = YES;
    }
    return self;
}

// 显示提示语，一闪而逝
- (void)showPromptInfo:(NSString *)info {
    if (![SGSettingUtil dataAndStringIsNull:info]) {
        if (self.isShow) {
            isShow = NO;
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            UIView *aview = [window.subviews lastObject];
            [[UIApplication sharedApplication].delegate.window addSubview:aview];
            
            [aview makeToast:info duration:1.0 position:@"center"];
            
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.4];
        } 
    }
}

- (void)delayMethod {
    isShow = YES;
}

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1);
}

#pragma mark - 类方法
// alert，单个按钮，没有回调
+ (void)showAlertInfoSingle:(NSString *)info {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
// alert，单个按钮，有回调
+ (void)showAlertInfoSingle:(NSString *)info delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:info delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
// alert，两个按钮，有回调
+ (void)showAlertInfoDouble:(NSString *)info delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:info delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

+(void)showHUDAndHidentAfterTimeOut:(NSInteger)timeOut
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES afterDelay:timeOut];
}
+(void)hidentHUDAfterRequestSuccess
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
}

@end
