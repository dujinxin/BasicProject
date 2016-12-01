//
//  DJXHorizontalView.h
//  GJieGo
//
//  Created by dujinxin on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DJXHorizontalViewStyle) {
    DJXHorizontalViewDefault = 0,//单层
    DJXHorizontalViewNest        //嵌套
};

@class DJXHorizontalView;
@protocol DJXHorizontalViewDelegate <NSObject>

/*
 *set width
 */
-(CGFloat)horizontalView:(DJXHorizontalView *)horizontalView widthForPageAtIndex:(NSUInteger)index;
/*
 *
 */
-(void)horizontalView:(DJXHorizontalView *)horizontalView didScrollToItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol DJXHorizontalViewDataSource <NSObject>

@optional
/*
 *set pages
 */
-(NSInteger)horizontalView:(DJXHorizontalView *)horizontalView contentView:(UIView *)contentView numberOfPagesInSection:(NSInteger)section;
/*
 *set view
 */
-(UIView *)horizontalView:(DJXHorizontalView *)horizontalView contentView:(UIView *)contentView frame:(CGRect)frame viewForPageAtIndex:(NSUInteger)index;
/*
 *set content
 */
-(void)horizontalView:(DJXHorizontalView *)horizontalView contentView:(UIView *)contentView contentForPageAtIndex:(NSUInteger)index;

@end

@interface DJXHorizontalView : UIView

// 父类 用于处理添加子控制器  使用weak避免循环引用
@property (weak, nonatomic) UIViewController      * parentViewController;
@property (nonatomic, strong) UICollectionView    * containerView;
@property (nonatomic, strong) NSMutableArray      * containerArray;
@property (nonatomic, strong) NSMutableArray      * titleArray;

@property (nonatomic, strong) UIView              * contentView;
@property (nonatomic, assign) DJXHorizontalViewStyle          style;
@property (nonatomic, assign) id <DJXHorizontalViewDelegate>  delegate;
@property (nonatomic, assign) id<DJXHorizontalViewDataSource> dataSource;

-(instancetype)initWithFrame:(CGRect)frame style:(DJXHorizontalViewStyle)style containers:(NSArray *)containers parentViewController:(UIViewController *)parentViewController;
-(void)reloadData;

@end
