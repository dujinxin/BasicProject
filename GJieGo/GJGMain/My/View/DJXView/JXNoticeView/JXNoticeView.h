//
//  JXNoticeView.h
//  JXView
//
//  Created by dujinxin on 15/11/19.
//  Copyright © 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLabel.h"

typedef NS_ENUM(NSInteger, JXNoticeViewType) {
    JXNoticeViewTypeNotice       =    1,
    JXNoticeViewTypeWarning ,
    JXNoticeViewTypeInfo,
    JXNoticeViewTypeError
};
typedef NS_ENUM(NSInteger,JXNoticeViewDuration) {
    JXNoticeViewDurationLong    = 3,
    JXNoticeViewDurationShort   = 1,
    JXNoticeViewDurationNormal  = 2
};
typedef NS_ENUM(NSInteger, JXNoticeViewShowPosition) {
    JXNoticeViewShowPositionTop,
    JXNoticeViewShowPositionMiddle,
    JXNoticeViewShowPositionBottom
};

@interface JXNoticeView : UIView

@property (nonatomic, copy)  NSString  * message;
@property (nonatomic, strong)UIFont    * font;
@property (nonatomic, assign)JXNoticeViewShowPosition noticeViewPosition;
@property (nonatomic, assign)JXNoticeViewDuration     noticeViewDuration;


- (instancetype)initWithText:(NSString *)text;

- (void)show;
- (void)showInView:(UIView *)view animate:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end
