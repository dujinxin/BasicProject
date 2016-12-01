//
//  BasicWebViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BasicWebViewController.h"

@interface BasicWebViewController ()

@end

@implementation BasicWebViewController

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavStatusHeight, self.view.frame.size.width, kScreenHeight -kNavStatusHeight)];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView{
    [super loadView];
    [self.view addSubview:self.webView];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"baseWebView error : %@",error.localizedDescription);
}

#pragma mark - webViewControllerPrivate
- (void)setBody:(NSString *)body{
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:nil]];
}
-(void)loadRequest:(NSString *)urlStr{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

-(void)handleWebEventsWithDelegate:(UIViewController *)target UrlStr:(NSString *)urlStr param:(id)param{
}

@end
