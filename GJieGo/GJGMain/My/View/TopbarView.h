//
//  TopbarView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBarAttribute;
@class TopbarView;

@protocol TopBarViewDelegate <NSObject>

- (void)topBarView:(TopbarView *)topView clickItemIndex:(NSInteger)index;

@end
@interface TopbarView : UIView{
    UIView  *  _bottomLine;
}

@property (nonatomic, weak) id<TopBarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger            selectIndex;
@property (nonatomic, strong) NSString           * currentTitle;
@property (nonatomic, assign) BOOL                 bottomLineEnabled;
@property (nonatomic, strong) UIView             * bottomLine;
@property (nonatomic, strong) NSMutableArray     * titles;
@property (nonatomic, strong) TopBarAttribute    * attribute;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles attribute:(TopBarAttribute *)attribute;

- (void)setBottomLineEnabled:(BOOL)bottomLineEnabled;
- (void)setBottomLineSize:(CGSize)size;
- (void)setBottomLineColor:(UIColor *)color;

@end


@interface TopBarAttribute : NSObject

@property (nonatomic, strong) UIColor  * separatorColor;
@property (nonatomic, strong) UIColor  * normalColor;
@property (nonatomic, strong) UIColor  * highlightedColor;
@property (nonatomic, assign) BOOL       bottomLineEnabled;

//- (void)setBottomLineEnabled:(BOOL)bottomLineEnabled;
//- (void)setBottomLineSize:(CGSize)size;
//- (void)setBottomLineColor:(UIColor *)color;

@end
