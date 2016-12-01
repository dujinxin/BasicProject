//
//  JXSelectView.h
//  JXView
//
//  Created by dujinxin on 15/11/17.
//  Copyright © 2015年 e-future. All rights reserved.
//


/*
 *弹出选择视图
 *目前支持列表和选择器两种风格
 *然后又分为带有选择按钮和不带选择按钮两种
 *支持上、中、低部三种位置
 *
 */

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JXSelectViewStyle) {
    JXSelectViewStyleList       =    1,
    JXSelectViewStylePick ,
    JXSelectViewStyleCustom
};
typedef NS_ENUM(NSInteger, JXSelectViewShowPosition) {
    JXSelectViewShowPositionTop,
    JXSelectViewShowPositionMiddle,
    JXSelectViewShowPositionBottom,
};

typedef enum{
    kSelectBgViewTag = 9000,
    kSelectButtonTag = 10000,
}kSelectViewTag;

@class JXSelectView;
@protocol JXSelectViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)selectView:(JXSelectView *)selectView didSelectRow:(NSInteger)row;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)selectViewCancel:(JXSelectView *)alertView;

- (void)willPresentSelectView:(JXSelectView *)alertView;  // before animation and showing view
- (void)didPresentSelectView:(JXSelectView *)alertView;  // after animation

- (void)selectView:(JXSelectView *)selectView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)selectView:(JXSelectView *)selectView didDismissWithButtonIndex:(NSInteger)buttonIndex; // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)selectViewShouldEnableFirstOtherButton:(UIAlertView *)selectView;

@end


@protocol JXSelectViewDataSource <NSObject>

@required
-(NSInteger)selectView:(JXSelectView *)selectView numberOfRowsInSection:(NSInteger)section;
-(NSString *)selectView:(JXSelectView *)selectView contentForRow:(NSInteger)row section:(NSInteger)section;

@end

@interface JXSelectView : UIView<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView              * _tableView;
    UIPickerView             * _pickView;
    UIView                   * _customView;
}
@property (nonatomic, strong)UITableView   * tableView;
@property (nonatomic, strong)UIPickerView  * pickView;
@property (nonatomic, strong)UIView        * customView;
@property (nonatomic, strong)UIButton      * cancelButton;
@property (nonatomic, strong)UIButton      * confirmButton;
@property (nonatomic, assign,getter=isUseTopButton)BOOL            useTopButton;
@property (nonatomic, strong)NSMutableArray* dataArray;
@property (nonatomic, assign)NSInteger       selectRow;
@property (nonatomic, assign)JXSelectViewStyle          selectViewStyle;
@property (nonatomic, assign)JXSelectViewShowPosition   selectViewPosition;
@property (nonatomic, assign)id<JXSelectViewDelegate>   delegate;
@property (nonatomic, assign)id<JXSelectViewDataSource> dataSource;


- (instancetype)initWithFrame:(CGRect)frame style:(JXSelectViewStyle)style;
- (instancetype)initWithCustomView:(UIView *)customView;
- (void)show;
- (void)showInView:(UIView *)view animate:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end