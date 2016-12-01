//
//  AvatarBrowser.m
//  GJieGo
//
//  Created by liubei on 16/5/6.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "AvatarBrowser.h"

static CGRect oldframe;

@implementation AvatarBrowser

+ (void)showImage:(UIImageView *)avatarImageView{
    
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:
                              CGRectMake(0,
                                         0,
                                         [UIScreen mainScreen].bounds.size.width,
                                         [UIScreen mainScreen].bounds.size.height)];
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imgW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imgH = image.size.height * imgW / image.size.width;
    CGFloat imgX = 0.f;
    CGFloat imgY = (screenH - image.size.height * imgW / image.size.width) / 2;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        backgroundView.alpha = 1;
    }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
