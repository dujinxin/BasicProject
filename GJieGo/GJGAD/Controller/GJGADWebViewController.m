//
//  GJGADWebViewController.m
//  GJieGoGuide
//
//  Created by gjg on 16/7/28.
//  Copyright © 2016年 guangjiego.yangzx. All rights reserved.
//

#import "GJGADWebViewController.h"

@interface GJGADWebViewController () {
    
    UIView *statusBackView;
}

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation GJGADWebViewController

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [self loadWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    [self.view addSubview:statusBackView];
}

- (void)loadWebView {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    statusBackView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    statusBackView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
