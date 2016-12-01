//
//  ShareImageDetailViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShareImageDetailViewController.h"

@interface ShareImageDetailViewController () {
    
    UIView *statusBackView;
}

@end

@implementation ShareImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init

- (void)initAttributes {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
    
    UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorImage = img;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = img;
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
}

- (void)createUI {
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(0,0,44,40);
    [rightButton setTitle:@"删除" forState:UIControlStateNormal];
    [rightButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    [rightButton setTitleColor:GJGRGB16Color(0x999999) forState:UIControlStateDisabled];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightButton addTarget:self action:@selector(deleteThisImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.image = self.showImage;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).with.offset(64);
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
}

- (void)deleteThisImage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"要删除这张图片吗?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(shareImageDetailViewControllerDeleteThisImage:)]) {
            [self.delegate shareImageDetailViewControllerDeleteThisImage:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
