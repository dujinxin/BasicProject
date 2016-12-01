//
//  BusinessInfoController.m
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 商场介绍 ---

#import "BusinessInfoController.h"
#import "GJGMallPropertyModel.h"

@interface BusinessInfoController (){
    UIView *statusBackView;
    UIScrollView *backScrollView;
    GJGMallPropertyModel *_mallPropertyModel;
}

@property (nonatomic, strong)UIImageView *topImageView;
@property (nonatomic, strong)UILabel *infoLable;
@end

@implementation BusinessInfoController
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
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    [self loadData];
}

- (void)loadData{

    [request requestUrl:kGJGRequestUrl(self.viewRequest) requestType:RequestPostType parameters:self.requestDic requestblock:^(id responseobject, NSError *error) {
        NSLog(@"%@ = %@", self.title, responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            _mallPropertyModel = [[GJGMallPropertyModel alloc] initWithDic:responseobject];
            [self makeUI];

        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}
- (void)makeUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    MallPropertyItem *item = [[MallPropertyItem alloc] initWithDic:_mallPropertyModel.Data];
    CGFloat imageHigh = 0.0;
//    self.title = _mallPropertyModel.Data.PropertyName;
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    backScrollView.scrollEnabled = YES;
    self.topImageView = [[UIImageView alloc] init];
    if (item.PropertyImage == nil) {
//        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:item.PropertyImage] placeholderImage:[UIImage imageNamed:@""]];
        self.topImageView.image = [UIImage imageNamed:@""];
        imageHigh = 0.0;
    }else{
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", item.PropertyImage, (int)ScreenWidth]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
        imageHigh = (self.topImageView.image.size.height / self.topImageView.image.size.width) * ScreenWidth;
    }
    self.infoLable = [[UILabel alloc] init];
    self.infoLable.font = [UIFont systemFontOfSize:14];
    self.infoLable.textColor = GJGRGB16Color(0x333333);
    self.infoLable.numberOfLines = 0;
    self.infoLable.text = item.PropertyContent;
    [backScrollView addSubview:self.topImageView];
    [backScrollView addSubview:self.infoLable];
    [self.view addSubview:backScrollView];
    
    
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(backScrollView);//.offset(64);
        make.trailing.equalTo(self.view);
        make.height.equalTo(imageHigh);//equalTo(self.view).multipliedBy(164/1334);//
    }];
    [self.infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.top.equalTo(self.topImageView.bottom).offset(18);
        make.trailing.equalTo(self.view).offset(-15);
        make.size.greaterThanOrEqualTo(self.infoLable);
    }];
//    [backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    [backScrollView layoutIfNeeded];
    //    [self.topImageView layoutIfNeeded];
    //    [self.infoLable layoutIfNeeded];
    
    NSLog(@"%f", self.topImageView.bounds.size.height + self.infoLable.frame.size.height);
    backScrollView.contentSize = CGSizeMake(ScreenWidth, self.topImageView.bounds.size.height + self.infoLable.frame.size.height + 18 + 10);
}
@end
