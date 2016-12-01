//
//  GJGBusinessClassView.m
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 品牌分类 ---

#import "GJGBusinessClassView.h"
#define btnX ScreenWidth * 0.25

@interface GJGBusinessClassView()<UIScrollViewDelegate>{
    UIScrollView *_backScrollView;
    UIPageControl *_pageControl;
}
@end

@implementation GJGBusinessClassView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (id)initWithFrame:(CGRect)frame sourceArray:(NSMutableArray *)sourceArray{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeGJGBusinessArearUIWithCalssData:sourceArray];
    }
    return self;
}
#pragma mark - pageControl Action
- (void)pageControlAction:(UIPageControl *)pageControl{
    [_backScrollView setContentOffset:CGPointMake(ScreenWidth * pageControl.currentPage, 0) animated:YES];
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPageIndicatorTintColor = GJGGRAYCOLOR;      //page当前点的颜色
    _pageControl.pageIndicatorTintColor = GJGRGB16Color(0xd2d2d2);                     //page点的颜色
}
- (void)makeGJGBusinessArearUIWithCalssData:(NSMutableArray*)classArray{
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 4 * 2 + 15)];
    _backScrollView.delegate = self;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    _backScrollView.contentSize = CGSizeMake(ScreenWidth * ceilf(classArray.count / 8.0), ScreenWidth / 4 * 2 + 15);
    _backScrollView.pagingEnabled = YES;
    _backScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backScrollView];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (ScreenWidth / 4) * 2 , ScreenWidth, 10)];
    if (ScreenWidth < 370) {
        _pageControl.frame = CGRectMake(0, (ScreenWidth / 4) * 2 + 2, ScreenWidth, 10);
    }
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = ceilf(classArray.count / 8.0);
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = GJGGRAYCOLOR;
    _pageControl.pageIndicatorTintColor = GJGRGB16Color(0xd2d2d2);
    [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventTouchUpInside];
    for (int i = 0; i < classArray.count; i++) {
        NSDictionary *sourceDic = [[NSDictionary alloc] initWithDictionary:classArray[i]];
        NSString *imageName = [sourceDic[@"DicExt"] copy];
        UIImage * image;
        if ([imageName isKindOfClass:[NSNull class]] || imageName == NULL || imageName == nil || [imageName isEqualToString:@""]) {
            image = [UIImage imageNamed:@"default_portrait_less"];
        }else{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageName]]]];
        }
        UIButton *classButton = [UIButton buttonWithType:UIButtonTypeCustom tag:1000 + i title:nil titleSize:11 frame:CGRectMake(btnX * (i % 4) + ScreenWidth * (i / 8), btnX * ((i / 4) % 2) - 5 * ((i / 4) % 2), btnX, btnX-5) Image:nil target:self action:@selector(didClickClassButton:)];
        [_backScrollView addSubview:classButton];
        //        if (i == 1 || i == 8 || i == 4 || i == 9) {
        //            classButton.backgroundColor = [UIColor greenColor];
        //        }
        UIImageView *btnImage = [[UIImageView alloc] init];
        [btnImage sd_setImageWithURL:[NSURL URLWithString:sourceDic[@"DicExt"]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
        [classButton addSubview:btnImage];
        [btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo((btnX - 44) * 0.5);
            make.top.equalTo(24);
            make.size.equalTo(CGSizeMake(44, 44));
        }];
        UILabel *btnLabel = [UILabel labelWithFrame:CGRectZero text:sourceDic[@"DicName"]tinkColor:GJGRGB16Color(0x333333) fontSize:11.0f];
        [classButton addSubview:btnLabel];
        [btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btnImage);
            make.top.equalTo(btnImage.bottom).offset(6);
        }];
    }
}
- (void)setSourceArray:(NSMutableArray *)sourceArray{
    if (_sourceArray != sourceArray) {
        [self makeGJGBusinessArearUIWithCalssData:sourceArray];
    }
}
//每个按钮的响应方法
- (void)didClickClassButton:(UIButton *)button{
    NSLog(@"品牌分类===%ld", (long)button.tag);
    [self.delegate transformBusinessViewButtonAction:button];
}

@end
