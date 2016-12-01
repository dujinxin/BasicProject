//
//  GJGFindController.h
//  GJieGo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HybirdUrlHandler.h"


@interface GJGFindController : BaseViewController
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy) HybridCallbackBlock callBackBlock;
@end
