//
//  JXGuideView.m
//  JXView
//
//  Created by dujinxin on 15-1-9.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "JXGuideView.h"

@interface JXGuideView (){
    UIWindow * _bgWindow;
    CGRect     _frame;
    NSArray  * _imageArray;
}

@end

@implementation JXGuideView

-(void)dealloc{

}
-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _frame = frame;
        if (imageArray) {
            _imageArray = imageArray;
        }else{
            _imageArray = [self setImageArrayData:nil];
        }
        _imageArray = imageArray;
        
        self.mainScrollView.contentSize = CGSizeMake(frame.size.width * _imageArray.count, kScreenHeight);
        [self addSubview:self.mainScrollView];
        
        
        self.pageControl.numberOfPages = _imageArray.count;
        [self addSubview:self.pageControl];
        
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*i, 0, frame.size.width, frame.size.height)];
            imageView.userInteractionEnabled = YES;
            [imageView setImage:imageArray[i]];
            [_mainScrollView addSubview:imageView];

            if (i == imageArray.count -1) {
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
                [imageView addGestureRecognizer:tap];
//                [imageView addSubview:self.endBtn];
            }
        }
        
    }
    return self;
}
#pragma mark - 
- (void)show:(BOOL)animated{
    [self showInView:nil animate:animated];
}
- (void)showInView:(UIView *)view animate:(BOOL)animated{
    
    if (view) {
        [view addSubview:self];
    }else{
        _bgWindow = ({
            UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel = UIWindowLevelAlert + 2;
            window.backgroundColor = [UIColor clearColor];
            window.userInteractionEnabled = YES;
            window.hidden = NO;
            window;
        });
        [_bgWindow addSubview:self];
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(guideViewDidFinish)]) {
        [self.delegate guideViewDidFinish];
    }
    [self hideWithFadeOutDuration:0.3];
}
- (void)valueChange:(UIPageControl *)page{
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width * page.currentPage, 0)];
}
- (void)hideWithFadeOutDuration:(CGFloat)duration {
    if (_completion) {
        self.completion(nil);
    }
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (_bgWindow) {
                _bgWindow.hidden = YES;
                _bgWindow = nil;
            }
        }
    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x/_mainScrollView.frame.size.width;
    
    if (offset - (int)offset >=0.5) {
        _pageControl.currentPage = (int)offset +1;
    }else{
        _pageControl.currentPage = (int)offset;
    }
    
    if (offset > (_imageArray.count-1) +0.2) {
        if ([(id)self.delegate respondsToSelector:@selector(guideViewDidFinish)]) {
            [self.delegate guideViewDidFinish];
        }
        [self hideWithFadeOutDuration:0.3];
    }else{
        //[self setAlpha:offset - (int)offset];
    }
    
}

-(NSArray *)setImageArrayData:(id)d{
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        UIImage * image;
        if (iPhone5) {
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_0%d_5",i+1] ofType:@"jpg"]];
        }else{
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_0%d",i+1] ofType:@"jpg"]];
        }
        [array addObject:image];
    }
    
    return array;
}
#pragma mark - initView
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:_frame];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.scrollEnabled = YES;
    }
    return _mainScrollView;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(60, kScreenHeight - 30 , 200, 30)];
        _pageControl.backgroundColor = [UIColor clearColor];
        [_pageControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
-(UIButton *)endBtn{
    if (!_endBtn) {
        _endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endBtn setBackgroundColor:[UIColor redColor]];
        [_endBtn setFrame:CGRectMake(0, 0, 200, _frame.size.height-20)];
        [_endBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}
@end
