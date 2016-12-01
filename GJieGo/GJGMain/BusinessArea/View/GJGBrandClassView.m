//
//  GJGBrandClassView.m
//  GJieGo
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 yangzx. All rights reserved.
//  促销分类view

#import "GJGBrandClassView.h"
#import "RunTypeMallModel.h"

#define btnX ScreenWidth/5
#define btnY (200 * (ScreenWidth / 375) - 10)/2

@interface GJGBrandClassView ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    CGFloat btnHeight;      //button高度
    CGFloat selfHeight;     //self的高度
    CGFloat varHeight;      //button间隔
}

@end

@implementation GJGBrandClassView

- (id)initWithFrame:(CGRect)frame sourceArray:(NSArray *)sourceArray{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeGJGBusinessArearUIWithCalssData:sourceArray];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (ScreenWidth > 350) {
            selfHeight  = 180;
            varHeight = 10;
            
        }else{
            selfHeight = 150;
            varHeight = 0;
        }
        btnHeight  = (selfHeight * (ScreenWidth / 375) - 10)/2;
    }
    return self;
}

- (void)setSourceArray:(NSMutableArray *)sourceArray{
    
    if (sourceArray != _sourceArray) {
        [self makeGJGBusinessArearUIWithCalssData:sourceArray];
    }
}
- (void)makeGJGBusinessArearUIWithCalssData:(NSArray*)classArray{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, selfHeight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat num = classArray.count / 10;
    if (classArray.count % 10 != 0) {
        num++;
    }
    
    if (classArray.count < 11) {
        selfHeight = 170;
        if (ScreenWidth < 375) {
            selfHeight = 140;
        }
    }else{
        selfHeight = 180;
        if (ScreenWidth < 375) {
            selfHeight = 150;
        }
    }
    _scrollView.contentSize = CGSizeMake(num * ScreenWidth, self.bounds.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < classArray.count; i++) {
        
        RunTypeMallItem *item = [[RunTypeMallItem alloc] initWithDic:classArray[i]];
        CGFloat btnH;
        
        if ([self viewsWithFloat:100] > ScreenWidth / 5) {
            btnH = ScreenWidth / 5 - 30;
        }else{
            btnH = [self viewsWithFloat:100] - 30;
        }
        UIImage *image;
        if ([self isBlankString:item.DicExt]) {
            image = [UIImage imageNamed:@"default_portrait_less"];
        }else{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.DicExt]]];
        }
        UIButton *classButton = [UIButton buttonWithType:UIButtonTypeCustom
                                                     tag:1000 + i
                                                   title:item.DicName
                                               titleSize:0.0f
                                                   frame:CGRectZero
                                                   Image:image
                                                  target:self
                                                  action:@selector(didClickClassButton:)];
        [_scrollView addSubview:classButton];
        _scrollView.delegate = self;
        classButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [classButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(btnX * (i % 5) + (i / 10) * ScreenWidth + 15);
            make.top.equalTo((btnHeight - varHeight) * ((i / 5) % 2));
            make.size.equalTo(CGSizeMake(btnH, btnH));
        }];
        
        UILabel *classLabel = [UILabel labelWithFrame:CGRectZero text:item.DicName tinkColor:GJGBLACKCOLOR fontSize:12];
        [_scrollView addSubview:classLabel];
        [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(classButton);
            make.top.equalTo(classButton.bottom).offset(5);
        }];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, selfHeight - 10, ScreenWidth, 10)];
    view.backgroundColor = GJGRGB16Color(0xf1f1f1);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.top.equalTo(self.bottom).offset(-10);
        make.width.equalTo(ScreenWidth);
        make.height.equalTo(10);
    }];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(0);
        make.bottom.equalTo(-13);
        make.width.equalTo(ScreenWidth);
        make.height.equalTo(15);
    }];
    _pageControl.numberOfPages = num;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = GJGGRAYCOLOR;      //page当前点的颜色
    _pageControl.pageIndicatorTintColor = GJGRGB16Color(0xd2d2d2);
    [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventTouchUpInside];
    if (num > 1) {
        _pageControl.hidden = NO;
    }else{
        _pageControl.hidden = YES;
    }
}

#pragma mark - scaleAspect
- (CGFloat)viewsWithFloat:(CGFloat)f{
    return f * ( 375 /ScreenWidth );
}

#pragma mark - brandClass
- (void)didClickClassButton:(UIButton *)button{
    [self.delegate clickBrandClassButton:button];
}

#pragma mark - pageControlAction
- (void)pageControlAction:(UIPageControl *)pageControl{
    [_scrollView setContentOffset:CGPointMake(ScreenWidth * pageControl.currentPage, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPageIndicatorTintColor = GJGGRAYCOLOR;      //page当前点的颜色
    _pageControl.pageIndicatorTintColor = GJGRGB16Color(0xd2d2d2);                     //page点的颜色
}
@end
