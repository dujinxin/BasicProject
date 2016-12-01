//
//  WifiFreePriceController.m
//  GJieGo
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 免费WiFi ---

#import "WifiFreePriceController.h"

@interface WifiFreePriceController (){
    UIView *statusBackView;
    NSArray *sourceArray;
}

@end

@implementation WifiFreePriceController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费WiFi";
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *wifiId;
    if ([self.shopId isEqualToString:@""]) {
        wifiId = self.mallId;
    }else{
        wifiId = self.shopId;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"Id":wifiId, @"Type":self.Type}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_FreeWifi) parameters:param requestblock:^(id responseobject, NSError *error) {
        if ([responseobject[@"status"] integerValue] == 0) {
            if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                sourceArray = responseobject[@"data"];
                [self makeWiFiUIWithArray:responseobject[@"data"]];
            }else{
                
            }
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];

}

- (void)makeUIWithArray:(NSMutableArray *)array{
    UIScrollView *wfScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    wfScroll.backgroundColor = GJGRGB16Color(0xf1f1f1);
    wfScroll.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 1);
    [self.view addSubview:wfScroll];
    
    UIView * lastone = nil;
    for (int i = 0; i < array.count; i ++) {
        if (i == 0) {
            UIView *oneView = [[UIView alloc] init];
            [wfScroll addSubview:oneView];
            UIImageView *oneImage = [[UIImageView alloc] init];
            [oneImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@690W_1o", array[i][@"Image"]]] placeholderImage:[UIImage imageNamed:@"default_landscape_normal"]];
            [oneView addSubview:oneImage];
            
            UILabel *oneLabel = [UILabel labelWithFrame:CGRectZero text:array[i][@"Desc"] tinkColor:GJGRGB16Color(0x333333) fontSize:14];
            [oneView addSubview:oneLabel];
        }
        CGRectGetMaxY(lastone.frame);
    }
}

- (void)makeWiFiUIWithArray:(NSMutableArray *)array{
    
    
    CGFloat imageWidth = ScreenWidth - 30;
    CGFloat imageHeight = imageWidth * 0.8;
    
    UIScrollView *wfScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    wfScroll.backgroundColor = GJGRGB16Color(0xf1f1f1);
    wfScroll.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 1);
    [self.view addSubview:wfScroll];
    
    CGFloat wordHeight = 0;
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13 + (imageHeight + 30 + wordHeight) * i, imageWidth, imageHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@690W_1o", array[i][@"Image"]]] placeholderImage:[UIImage imageNamed:@"default_landscape_normal"]];//@690w
        
        if ([array[i][@"Desc"] isKindOfClass:[NSNull class]]) {
            wordHeight = 40;
        }else{
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0f] forKey:NSFontAttributeName];
            CGSize size = [array[i][@"Desc"] boundingRectWithSize:CGSizeMake(imageWidth, MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:dic
                                                          context:nil].size;
            
            size.height < 40 ? (wordHeight = 40) : (wordHeight = size.height);
            
        }
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height + 15, ScreenWidth, wordHeight)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = GJGRGB16Color(0x333333);
        label.textAlignment = NSTextAlignmentCenter;
        if ([array[i][@"Desc"] isKindOfClass:[NSNull class]]) {
            label.text = @"";
        }else{
            label.text = array[i][@"Desc"];
        }
        
        
        [wfScroll addSubview:imageView];
        [wfScroll addSubview:label];
    }
    if ((13 + (imageHeight + 30 + wordHeight) * array.count) < (ScreenHeight + 1)) {
        wfScroll.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 1);
    }else{
        wfScroll.contentSize = CGSizeMake(ScreenWidth, 13 + (imageHeight + 30 + wordHeight) * array.count);
    }
}
@end
