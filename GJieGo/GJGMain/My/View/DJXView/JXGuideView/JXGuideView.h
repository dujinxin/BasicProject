//
//  JXGuideView.h
//  JXView
//
//  Created by dujinxin on 15-1-9.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXGuideViewDelegate <NSObject>

- (void)guideViewDidFinish;

@end

typedef void (^completionHandler)(id object);

@interface JXGuideView : UIView<UIScrollViewDelegate>
{
    UIScrollView  * _mainScrollView;
    UIPageControl * _pageControl;
    UIButton      * _endBtn;
}
@property (nonatomic, strong) UIButton      * endBtn;
@property (nonatomic, strong) UIScrollView  * mainScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) id<JXGuideViewDelegate> delegate;
@property (nonatomic, copy)   completionHandler completion;

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

- (void)show:(BOOL)animated;
- (void)showInView:(UIView *)view animate:(BOOL)animated;

@end
