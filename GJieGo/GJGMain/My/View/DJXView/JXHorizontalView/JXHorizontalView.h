//
//  JXHorizontalView.h
//  JXView
//
//  Created by dujinxin on 15-5-7.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXHorizontalViewStyle) {
    JXHorizontalViewDefault = 0,
    JXHorizontalViewVariable,
};

@class JXHorizontalView;
@protocol JXHorizontalViewDelegate <NSObject>

/*
 *set width
 */
-(CGFloat)horizontalView:(JXHorizontalView *)horizontalView widthForPageAtIndex:(NSUInteger)index;


@end

@protocol JXHorizontalViewDataSource <NSObject>

@required
/*
 *set pages
 */
-(NSInteger)horizontalView:(JXHorizontalView *)horizontalView contentView:(UIView *)contentView numberOfPagesInSection:(NSInteger)section;
/*
 *set view
 */
-(UIView *)horizontalView:(JXHorizontalView *)horizontalView contentView:(UIView *)contentView frame:(CGRect)frame viewForPageAtIndex:(NSUInteger)index;
/*
 *set content
 */
-(void)horizontalView:(JXHorizontalView *)horizontalView contentView:(UIView *)contentView contentForPageAtIndex:(NSUInteger)index;

@end




@interface JXHorizontalView : UIView


@property (nonatomic, strong) UITableView    * containerView;
@property (nonatomic, strong) NSMutableArray * containerArray;
@property (nonatomic, strong) NSMutableArray * titleArray;

@property (nonatomic, strong) UIView         * contentView;
@property (nonatomic, assign) JXHorizontalViewStyle          style;
@property (nonatomic, assign) id <JXHorizontalViewDelegate>  delegate;
@property (nonatomic, assign) id<JXHorizontalViewDataSource> dataSource;



-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame style:(JXHorizontalViewStyle)style;
//-(instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView titles:(NSArray *)titles;
//-(instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView views:(NSArray *)views titles:(NSArray *)titles;

-(void)reloadData;

@end
