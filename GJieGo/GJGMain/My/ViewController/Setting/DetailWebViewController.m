//
//  DetailWebViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/6/21.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DetailWebViewController.h"

@interface DetailWebViewController ()

@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBody:self.infoId];
    [self loadRequest:self.urlStr];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadView];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadView];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
