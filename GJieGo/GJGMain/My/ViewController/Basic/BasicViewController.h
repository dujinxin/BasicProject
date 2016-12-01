//
//  BasicViewController.h
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

#define getBackItem(target,sel) [self getNavigationItem:target selector:sel image:JXImageNamed(@"back") style:kSingleImage]

typedef NS_ENUM (NSInteger, kNavigationItemStyle){
    kDefault,                           /* 默认     */
    kSingleLineWords,                   /* 单行显示  */
    kDoubleLineWords,                   /* 两行显示  */
    kSingleImage,                       /* 单张图片  */
    kDoubleImages,                      /* 两张图片  */
    kImage_textWithLeftImage,           /* 左图右文  */
    kImage_textWithLeftWord,            /* 左文右图  */
};

typedef NS_ENUM(NSInteger, PageType) {
    PageTypeNone          =  0,        /*默认没有*/
    PageTypeNetworkLost,               /*网络原因*/
    PageTypeDataEmpty,                 /*数据为空*/
};

typedef void(^CallBackBlock)(id object);

@interface BasicViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, assign)kNavigationItemStyle navigationItemStyle;
@property (nonatomic, strong)UIView   * navigationBarBackgroundView;
@property (nonatomic, strong)UILabel  * titleView;

@property (nonatomic, copy) NSString  * urlStr;
@property (nonatomic, copy) CallBackBlock backBlock;
@property (nonatomic, assign) id  target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) PageType      pageType;
@property (nonatomic, strong) UIView      * basicBgView;
@property (nonatomic, strong) UIImageView * basicImageView;
@property (nonatomic, strong) UILabel     * basicLabelView;

/*
 *@param custom NavigationBar
 */
- (UIView *)setNavigationBar:(NSString *)title backgroundColor:(UIColor *)backgroundColor leftItem:(UIView *)leftItem rightItem:(UIView *)rightItem delegete:(id)delegate;
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style;
- (UIBarButtonItem *)getNavigationItem:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style;

- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;
- (NSArray *)getNavigationItems:(id)delegate selector:(SEL)selector title:(NSString *)title image:(UIImage *)image style:(kNavigationItemStyle)style isLeft:(BOOL)isLeft;
- (void)setBackBarButtonItemTitle:(NSString *)title;
- (void)backItemClick:(UIButton *)button;
/*
 *@param MBProgressHUD
 */
- (void)showLoadView;
- (void)showLoadView:(NSString *)text;
- (void)hideLoadView;
/*
 *@param Toast
 */
- (void)showNoticeMessage:(NSString *)message;
/*
 *@param UIAlertView
 */
- (void)showAlertMessage:(NSString *)message;
/*
 *@param JXNoticeView
 */
- (void)showJXNoticeMessage:(NSString *)message;
/*
 *@param JXAlertView
 */
- (void)showJXAlertMessage:(NSString *)message;

- (void)pushMessage:(NSString *)msg;
- (void)pushWarnMessage:(NSString *)msg;
- (void)pushWarnMessage:(NSString *)msg complete:(void (^)())complete;

- (void)dismissMessage;
- (void)dismissMessage:(NSString *)msg;
- (void)dismissMessage:(NSString *)msg complete:(void (^)())complete;
- (void)dismissMessageWithComplete:(void (^)())complete;

/**
 *  警告框
 *  @param msg 警告内容
 */

- (void)alertMessage:(NSString *)msg;
- (void)alertActionWithMessage:(NSString *)msg;

- (void)onClickBack:(id)sender;

/*
 *@param data request, load and view show background show
 */
- (void)setPageType:(PageType)pageType image:(NSString *)imageStr content:(NSString *)contentStr;
- (void)basicBgViewEvent:(id)object;

- (void)requestData;
- (void)reloadData;

- (void)requestWithPage:(NSUInteger)page;

@end
