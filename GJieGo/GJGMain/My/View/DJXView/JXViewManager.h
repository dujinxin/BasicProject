//
//  JXViewManager.h
//  JXView
//
//  Created by dujinxin on 15-5-25.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JXNoticeView.h"
#import "JXAlertView.h"
#import "JXGuideView.h"

typedef void(^completionHandler)(id object);

@interface JXViewManager : NSObject<UITabBarControllerDelegate>{
    JXNoticeView * _noticeView;
    JXAlertView  * _alertView;
    JXGuideView  * _guideView;
}
@property (nonatomic, strong)JXNoticeView * noticeView;
@property (nonatomic, strong)JXAlertView  * alertView;
@property (nonatomic, strong)JXGuideView  * guideView;

@property (nonatomic, copy)  completionHandler completion;

@property (strong, nonatomic) BaseTabBarController * tabBarController;

+ (JXViewManager *)sharedInstance;

/*
 *@param Toast
 */
- (void)showJXNoticeMessage:(NSString *)message;
- (void)showJXNoticeMessage:(NSString *)message completion:(completionHandler)completion;
/*
 *@param UIAlertView
 */
- (void)showAlertMessage:(NSString *)message;
- (void)showAlertMessage:(NSString *)message title:(NSString *)title;
- (void)showAlertMessage:(NSString *)message title:(NSString *)title delegate:(id<UIAlertViewDelegate>)delegate;
/*
 *@param JXAlertView
 */
- (void)showJXAlertMessage:(NSString *)message;
- (void)showJXAlertMessage:(NSString *)message title:(NSString *)title;
- (void)showJXAlertMessage:(NSString *)message title:(NSString *)title delegate:(id<JXAlertViewDelegate>)delegate;
- (void)showJXAlertMessage:(NSString *)message completion:(completionHandler)completion;
- (void)showJXAlertMessage:(NSString *)message title:(NSString *)title completion:(completionHandler)completion;
/*
 *@param JXGuideView
 */
- (void)showJXGuideImages:(NSArray *)images;
- (void)showJXGuideImages:(NSArray *)images delegate:(id<JXGuideViewDelegate>)delegate;
- (void)showJXGuideImages:(NSArray *)images completion:(completionHandler)completion;


- (void)showViewController:(UIViewController *)vc;
- (void)showViewController:(UIViewController *)vc delegate:(id)delegate;
- (void)showViewController:(UIViewController *)vc completion:(void(^)(id object))completion;

- (void)showWindowRootViewController:(UIViewController *)vc completion:(void(^)(id object))completion;

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void(^)(id object))completion;
- (void)dismissViewController:(BOOL)animated;
- (void)dismissViewController:(BOOL)animated resetRootViewController:(BOOL)yesOrNo;

- (void)popViewController:(BOOL)animated;

+ (void)show;
/**
 *	@brief	显示App启动插画 保持与启动时效果的一致 自动匹配iPhone 5尺寸的启动图片 
            请在首个Controller 的 viewWillAppear 里面执行
 *
 */
+ (void)show:(UIImage *)imageUrl;

/**
 *	@brief	以默认动画效果隐藏App启动图片 
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
 */
+ (void)hide:(BOOL)animated;

/**
 *	@brief	以自定义隐藏动画的方式隐藏App启动图片
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
 */
+ (void)hideWithCustomBlock:(void(^)(UIImageView *imageView))block;

/**
 *	@brief	清理,只在自定义动画时才需要调用
 */
+ (void)clear;





@end

/**
 *	@brief	通过SYAppStartViewController 来确保SYAppStart始终保持竖屏状态启动
 */
@interface SYAppStartViewController : UIViewController


@end

