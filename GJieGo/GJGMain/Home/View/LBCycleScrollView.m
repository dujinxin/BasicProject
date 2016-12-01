//
//  LBCycleScrollView.m
//
//  内部使用视图: scrollView * 1, pageControl * 1, ImageView * 3.
//
//
//

#define LabelHeight 27.0
#define pageDefaultMargin 10.0

#import "LBCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "AppMacro.h"


@interface LBCycleScrollView () <UIScrollViewDelegate> {
    
    int once;
}

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *imageViews;
@property (nonatomic, strong) NSArray *labelViews;
@property (nonatomic, assign) CGFloat scrollViewWidth;

@end

typedef enum {
    
    LBCycleScrollViewScrollToLeft  = 0,
    LBCycleScrollViewScrollToRight = 1
    
}LBCycleScrollViewScrollTo;


@implementation LBCycleScrollView

#pragma mark - 构造方法

+ (instancetype)cycleScrollView {
    
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame {
    
    return [[self alloc] initWithFrame:frame];
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame isAutoSwitch:(BOOL)autoSwitch timeInterval:(NSTimeInterval)timeInterval isUseLabel:(BOOL)useLabel clickBlick:(ClickBlock)block{
    
    LBCycleScrollView *cycleScrollView = [[LBCycleScrollView alloc] initWithFrame:frame];

    cycleScrollView.autoSwitch    = autoSwitch;
    cycleScrollView.timeInterval  = timeInterval;
    cycleScrollView.useLabel      = useLabel;
    cycleScrollView.clickBlock    = block;
    
    return cycleScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame isAutoSwitch:(BOOL)autoSwitch timeInterval:(NSTimeInterval)timeInterval isUseLabel:(BOOL)useLabel clickBlock:(ClickBlock)block{
    
    if (self = [self initWithFrame:frame]) {
        
        self.autoSwitch    = autoSwitch;
        self.timeInterval  = timeInterval;
        self.useLabel      = useLabel;
        self.clickBlock    = block;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // <0> Init
        once = 0;
        
        // <1> ScrollView
        UIScrollView *scrollView                       = [[UIScrollView alloc] init];
        self.scrollView                                = scrollView;
        self.scrollView.bounces                        = NO;
        self.scrollView.delegate                       = self;
        self.scrollView.pagingEnabled                  = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        
        NSMutableArray *imageViews = [NSMutableArray array];
        NSMutableArray *labelViews = [NSMutableArray array];
        
        for (int i = 0; i < 3; i++) {
            
            UIImageView *imageView           = [[UIImageView alloc] init];
            
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(imageViewTap:)];
            [imageView addGestureRecognizer:tap];
            [imageView setImage:[UIImage imageNamed:@"login_bg"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            UILabel *label         = [[UILabel alloc] init];
            label.backgroundColor  = [UIColor blackColor];
            label.alpha            = 0.6;
            label.font             = [UIFont systemFontOfSize:15];
            label.textColor        = [UIColor whiteColor];
            label.textAlignment    = NSTextAlignmentCenter;
          
            [imageView addSubview:label];
            [self.scrollView addSubview:imageView];
            
            [labelViews addObject:label];
            [imageViews addObject:imageView];
        }
        
        _labelViews = labelViews;
        _imageViews = imageViews;
        
        [self addSubview:scrollView];

        // <2> PageViewController
        UIPageControl *pageController = [[UIPageControl alloc] init];
        self.pageControl              = pageController;
        self.pageControl.hidden       = YES;
        [self addSubview:pageController];
        
        self.pageLabel = [[UILabel alloc] init];
        [self.pageLabel setTextAlignment:NSTextAlignmentCenter];
        [self.pageLabel setBackgroundColor:[UIColor blackColor]];
        [self.pageLabel setTextColor:[UIColor whiteColor]];
        [self.pageLabel setAlpha:0.5f];
        [self.pageLabel.layer setCornerRadius:6.f];
        [self.pageLabel.layer setMasksToBounds:YES];
        [self.pageLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:self.pageLabel];
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.bottom.equalTo(self.mas_bottom).with.offset(-16);
            make.height.mas_equalTo(@14);
            make.width.mas_equalTo(@28);
        }];
        
        // <3> timer
        [self beginTimer];
        
        if (self.timer)
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}


#pragma mark - UIView delegate

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    if (once == 0) {
        self.pageControl.currentPage = self.urlDataSource.count;
        [self changeImgWithdirection:LBCycleScrollViewScrollToRight];
        once ++;
    }
}


#pragma mark - 设置frame
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // <1> scrollView
    if (CGRectEqualToRect(self.scrollViewFrame, CGRectZero)) {
        
        CGFloat scrollViewX = 0;
        CGFloat scrollViewY = 0;
        CGFloat scrollViewW = self.frame.size.width;
        CGFloat scrollViewH = self.frame.size.height;

        self.scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);

    }else {
        
        self.scrollView.frame = self.scrollViewFrame;
    }
    
    self.scrollViewWidth          = self.scrollView.frame.size.width;
    
    self.scrollView.contentSize   = CGSizeMake(self.scrollViewWidth * 3, self.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollViewWidth, 0);
    
    // <2> scrollView.subViews
    for (int i = 0; i<self.imageViews.count; i++) {
        
        UIImageView *imageView = self.imageViews[i];
        CGFloat imageX         = self.scrollViewWidth * i;
        imageView.frame        = CGRectMake(imageX, 0, self.scrollViewWidth, self.scrollView.frame.size.height);
        
        if (self.isUseLabel) {
            
            UILabel *label = self.labelViews[i];
            label.frame = CGRectMake(0, imageView.frame.size.height - LabelHeight, imageView.frame.size.width, LabelHeight);
        }
    }
    
    // <3> pageController
    if (CGRectEqualToRect(self.pageViewFrame, CGRectZero)) {
        
        CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.urlDataSource.count];
        CGFloat pageW   = pageSize.width;
        CGFloat pageH   = pageSize.height - pageDefaultMargin;
        CGFloat pageY   = self.frame.size.height - (self.isUseLabel ? (pageH + LabelHeight): pageH);
        CGFloat pageX;
        
        switch (self.pageType) {
                
            case LBCycleScrollViewPageViewAlignmentBottomCenter: {
                
                pageX = (self.frame.size.width - pageW) * 0.5;
            }
                break;
                
            case LBCycleScrollViewPageViewAlignmentBottomLeft: {
                
                pageX = pageDefaultMargin;
            }
                break;
                
            case LBCycleScrollViewPageViewAlignmentBottomRight: {
                
                pageX = self.frame.size.width - pageW - pageDefaultMargin;
            }
                break;
                
            default:
                NSLog(@" error <LBCyclePageViewAlignment>: The type of pageViewAlignment is wrong, has being change to LBCyclePageViewAlignmentBottomCenter");
                
                pageX = (self.frame.size.width - pageW) * 0.5;
                
                break;
        }
        
        self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
        
    }else {
        
        self.pageControl.frame = self.pageViewFrame;
    }
}


#pragma mark - 设置Label属性
- (void)lb_setLabelAttribute:(UIColor *)bgColor alpha:(CGFloat)alpha font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment {
    
    for (UILabel *label in self.labelViews) {
        
        label.backgroundColor = (bgColor       ? bgColor       : [UIColor blackColor]);
        label.alpha           = (alpha         ? alpha         : 0.6);
        label.font            = (font          ? font          : [UIFont systemFontOfSize:15]);
        label.textColor       = (textColor     ? textColor     : [UIColor whiteColor]);
        label.textAlignment   = (textAlignment ? textAlignment : NSTextAlignmentCenter);
    }
}

#pragma mark - 图片点击事件

- (void)imageViewTap:(UITapGestureRecognizer *)tap {
    
    NSUInteger currentPage  = self.pageControl.currentPage;
    
    if (self.clickBlock) {
        
        self.clickBlock(currentPage);
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDidClickImageWithIndexOfDataSource:)]) {
        
        [self.delegate cycleScrollViewDidClickImageWithIndexOfDataSource:currentPage];
    }
}


#pragma mark - 定时器 - 自动跳转

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    
    _timeInterval = timeInterval;
    
    [self endTimer];
    [self beginTimer];
}

- (void)setAutoSwitch:(BOOL)autoSwitch {
    
    _autoSwitch = autoSwitch;
    
    [self endTimer];
    [self beginTimer];
}

- (void)beginTimer{
    
    if (!self.isAutoSwitch) return;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:4//(self.timeInterval ? self.timeInterval: 4)
                                                  target:self selector:@selector(nextAdver)
                                                userInfo:nil repeats:YES];
}

- (void)endTimer{
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark 广告跳转方法
- (void)nextAdver{

    [self.scrollView setContentOffset:CGPointMake(self.scrollViewWidth * 2, 0) animated:YES];
}


#pragma mark - scrollView监听

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self endTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self beginTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self calculateTheDirection];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self calculateTheDirection];
}

/** 计算结束滚动后的方向 */
- (void)calculateTheDirection {
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    
    if (contentOffsetX <= 10){
        
        [self changeImgWithdirection:LBCycleScrollViewScrollToLeft];
        
    }else if (contentOffsetX >= 2 * self.scrollViewWidth - 10){
        
        [self changeImgWithdirection:LBCycleScrollViewScrollToRight];
    }
}



#pragma mark - 重写set方法

- (void)lb_setDataSource:(NSArray *)dataSource labelDataSource:(NSArray *)labelDataSource type:(LBCycleScrollViewDataSourceType)type {
    
    _dataSourceType = type;
    
    if (labelDataSource)
        [self setLabelDataSource:labelDataSource];
    else if (self.useLabel == YES)
        NSLog(@"error <lb_setDataSource>: the labelDataSource is nil!");
    
    switch (type) {
            
        case LBCycleScrollViewDataSourceTypeUrl:
            
            if (dataSource)
                [self setUrlDataSource:dataSource];
            else
                NSLog(@"error <lb_setDataSource>: the urlDataSource is nil!");
            break;
            
        case LBCycleScrollViewDataSourceTypeImage:
            
            if (dataSource)
                [self setImageDataSource:dataSource];
            else
                NSLog(@"error <lb_setDataSource>: the imageDataSource is nil!");
            break;
            
        default:
            
            NSLog(@"error <lb_setDataSource: type:>: the DataSourceType is woring!");
            
            break;
    }
}

- (void)setUrlDataSource:(NSArray *)urlDataSource {
    
    _urlDataSource = urlDataSource;
    
    if (self.dataSourceType == LBCycleScrollViewDataSourceTypeUrl) {
        
        self.pageControl.numberOfPages = urlDataSource.count;
        self.scrollView.scrollEnabled = _urlDataSource.count != 1 ? YES : NO;
        if (_urlDataSource.count < 2) {
            [self.timer invalidate];
        }
    }
    
    [self calculateTheDirection];
}

- (void)setImageDataSource:(NSArray *)imageDataSource {
    
    _imageDataSource = imageDataSource;
    
    if (self.dataSourceType == LBCycleScrollViewDataSourceTypeImage) {
        
        self.pageControl.numberOfPages = imageDataSource.count;
        
        [self calculateTheDirection];
    }
}

- (void)setLabelDataSource:(NSArray *)labelDataSource {

    _labelDataSource = labelDataSource;
    
    if (labelDataSource.count == self.urlDataSource.count) {
        
        [self calculateTheDirection];
    }
}


#pragma mark - 根据方向计算出page, 并根据page重置ImageViews
- (void)changeImgWithdirection:(LBCycleScrollViewScrollTo)direction{
    
    // <1> page
    NSInteger page = self.pageControl.currentPage;
    
    if (direction == LBCycleScrollViewScrollToRight) {

        if (self.dataSourceType == LBCycleScrollViewDataSourceTypeUrl) {
            
            page = (++page == self.urlDataSource.count) ? 0: page;
        
        }else {
            
            page = (++page == self.imageDataSource.count) ? 0: page;
        }
        
        
    } else if (direction == LBCycleScrollViewScrollToLeft){
        
        if (self.dataSourceType == LBCycleScrollViewDataSourceTypeImage) {
            
            page = (--page == -1) ? (self.imageDataSource.count - 1): page;
        
        }else {
            
            page = (--page == -1) ? (self.urlDataSource.count - 1): page;
        }
    }

    self.pageControl.currentPage = page;
    
    [self.pageLabel setText:[NSString stringWithFormat:@"%lu/%lu", page + 1, self.urlDataSource.count]];

    // <2> imageViews
    switch (self.dataSourceType) {
            
        case LBCycleScrollViewDataSourceTypeUrl:
            
            [((UIImageView *)self.imageViews[0]) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.urlDataSource[page == 0 ? (self.urlDataSource.count - 1) : (page - 1)]]]
                                                   placeholderImage:[UIImage imageNamed:@"image_four"]];

            [((UIImageView *)self.imageViews[1]) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.urlDataSource[page]]] placeholderImage:[UIImage imageNamed:@"image_four"]];
            
            [((UIImageView *)self.imageViews[2]) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.urlDataSource[page == self.urlDataSource.count - 1 ? 0 : page + 1]]] placeholderImage:[UIImage imageNamed:@"image_four"]];
    
            break;
            
        case LBCycleScrollViewDataSourceTypeImage:
            NSLog(@"%zd", (page == 0) ? (self.imageDataSource.count - 1) : (page - 1));
            [((UIImageView *)self.imageViews[0]) setImage:self.imageDataSource[(page == 0) ? (self.imageDataSource.count - 1) : (page - 1)]];
            
            [((UIImageView *)self.imageViews[1]) setImage:self.imageDataSource[page]];
            
            [((UIImageView *)self.imageViews[2]) setImage:self.urlDataSource[page == self.imageDataSource.count - 1 ? 0 : page + 1]];
            
            break;
            
        default:
            
            NSLog(@"error <changeImgWithdirection>: The type of dataSource is wrong!");
            
            break;
    }
//
//    // <3> labels
//    if (self.useLabel && self.pageControl.numberOfPages <= self.labelDataSource.count) {
//        
//        ((UILabel *)self.labelViews[0]).text = self.labelDataSource[page == 0 ? (self.urlDataSource.count - 1) : (page - 1)];
//        ((UILabel *)self.labelViews[1]).text = self.labelDataSource[page];
//        ((UILabel *)self.labelViews[2]).text = self.labelDataSource[page == self.urlDataSource.count - 1 ? 0 : page + 1];
//    }
    
    // <4> back to center
    self.scrollView.contentOffset = CGPointMake(self.scrollViewWidth, 0);
}


@end
















