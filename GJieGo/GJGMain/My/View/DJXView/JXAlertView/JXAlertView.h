//
//  JXAlertView.h
//  JXView
//
//  Created by dujinxin on 14-11-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLabel.h"

#ifndef JX_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define JX_INSTANCETYPE instancetype
#else
#define JX_INSTANCETYPE id
#endif
#endif

typedef NS_ENUM(NSInteger, JXAlertViewStyle) {
    kAlertViewMessage      =    1,
    kAlertViewCustomView         ,
};

typedef enum{
    kJXAlertBgViewTag = 9900,
    kJXAlertButtonTag = 10000,
}kJXAlertViewTag;

@class JXAlertView;
@protocol JXAlertViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(JXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(JXAlertView *)alertView;

- (void)willPresentAlertView:(JXAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(JXAlertView *)alertView;  // after animation

- (void)alertView:(JXAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(JXAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

@end

@interface JXAlertView : UIView
{
    @public
    id<JXAlertViewDelegate> delegate;
    
}
@property (nonatomic, assign)id<JXAlertViewDelegate> delegate;
@property (nonatomic, copy) NSString  * title;
@property (nonatomic, copy) NSString  * message;


@property (nonatomic, assign)BOOL       showSeparateLine;
@property (nonatomic, strong)UIView   * separateLine;


- (JX_INSTANCETYPE)initWithTitle:(NSString *)title message:(NSString *)message target:(id)target buttonTitles:(NSArray *)buttonTitles;
- (JX_INSTANCETYPE)initWithTitle:(NSString *)title customView:(UIView *)customView target:(id)target buttonTitles:(NSArray *)buttonTitles;
- (void)show;
- (void)showInView:(UIView *)view animate:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;
@end
