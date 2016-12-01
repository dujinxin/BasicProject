//
//  LBCycleScrollView.h
//
//  本视图直接创建,添加到目标view中即可.
//
//  Create by LB && SS on 16-2-20.
//
//  版本: 1.1 (修复bug: 单张数据不能显示.)
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSInteger index);


@protocol LBCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDidClickImageWithIndexOfDataSource:(NSUInteger)index;

@end


@interface LBCycleScrollView : UIView

typedef enum {
    
    LBCycleScrollViewPageViewAlignmentBottomCenter = 0,
    LBCycleScrollViewPageViewAlignmentBottomLeft   = 1,
    LBCycleScrollViewPageViewAlignmentBottomRight  = 2
    
}LBCycleScrollViewPageViewAlignment;

typedef enum {
    
    LBCycleScrollViewDataSourceTypeUrl = 0,
    LBCycleScrollViewDataSourceTypeImage   = 1
    
}LBCycleScrollViewDataSourceType;


#pragma mark - 成员属性

@property (nonatomic) CGRect scrollViewFrame;   // detault is 填充.
@property (nonatomic) CGRect pageViewFrame; // default is LBCycleScrollViewPageAlignmentCenter.


/** 分页视图的位置类型. */
@property (nonatomic, assign) LBCycleScrollViewPageViewAlignment pageType;  // default is center.
/** 数据源类型. */
@property (nonatomic, assign) LBCycleScrollViewDataSourceType dataSourceType; // default is url.

/** url数据源, 内部使用SDWebImage(需添加), 只需要在数组中按顺序放入url(string)就可以(至少2个). */
@property (nonatomic, strong) NSArray *urlDataSource;
/** image数据源, 需要提供一个存放有image的数组 */
@property (nonatomic, strong) NSArray *imageDataSource;
/** 底部标签数据源, 用于显示在底部控件的数据, 内部元素应为NSString. 数量应与uilDataSource相同. */
@property (nonatomic, strong) NSArray *labelDataSource;

/** 滚动视图自动跳转的时间间隔. */
@property (nonatomic, assign) NSTimeInterval timeInterval;  // default is 2.5

/** 是否自动跳转 */
@property (nonatomic, assign, getter=isAutoSwitch) BOOL autoSwitch; // default is NO.
/** 是否使用底部标签 */
@property (nonatomic, assign, getter=isUseLabel) BOOL useLabel; //default is NO.


@property (nonatomic, assign) id<LBCycleScrollViewDelegate> delegate;

@property (nonatomic, strong) ClickBlock clickBlock;


#pragma mark - 构造方法
/** 直接返回一个frame为(0, 0, 0, 0)的headerView */
+ (instancetype)cycleScrollView;

/**  根据传入的frame返回一个LBHeaderView, 默认不会自动滚动. */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame;

/** 
 *  frame:view的尺寸
 *  autoSwitch:是否自动跳转
 *  timeInterval:跳转的时间间隔
 *  useLabel:是否使用底部label
 *  block:点击图片回调block.
 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame isAutoSwitch:(BOOL)autoSwitch timeInterval:(NSTimeInterval)timeInterval isUseLabel:(BOOL)useLabel clickBlick:(ClickBlock)block;
- (instancetype)initWithFrame:(CGRect)frame isAutoSwitch:(BOOL)autoSwitch timeInterval:(NSTimeInterval)timeInterval isUseLabel:(BOOL)useLabel clickBlock:(ClickBlock)block;


#pragma mark - 设置属性方法
/**
 *  设置底部label的属性.
 *  默认状态下:
 *              bgColor = blackColor
 *              alpha = 0.6
 *              font = 15
 *              fontColor = white
 *              textAlignment = NSTextAlignmentCenter
 */
- (void)lb_setLabelAttribute:(UIColor *)bgColor alpha:(CGFloat)alpha font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

/**
 *  dataSource: 图片数据源.
 *  labelDataSource: 底部label数据源
 *  type: 数据源类型
 */
- (void)lb_setDataSource:(NSArray *)dataSource labelDataSource:(NSArray *)labelDataSource type:(LBCycleScrollViewDataSourceType)type;

@end
















