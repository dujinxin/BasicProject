//
//  ScheduleTicketController.m
//  GJieGo
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ScheduleTicketController.h"

@interface ScheduleTicketController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation ScheduleTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview: self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    NSLog(@"-----%@", self.webUrl);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
