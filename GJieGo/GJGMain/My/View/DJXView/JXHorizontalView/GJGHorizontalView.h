//
//  GJGHorizontalView.h
//  GJieGo
//
//  Created by dujinxin on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GJGHorizontalViewStyle) {
    GJGHorizontalViewDefault = 0,//单层
    GJGHorizontalViewNest        //嵌套
};

@class GJGHorizontalView;
@protocol GJGHorizontalViewDelegate <NSObject>

/*
 *set width
 */
-(CGFloat)horizontalView:(GJGHorizontalView *)horizontalView widthForPageAtIndex:(NSUInteger)index;
/*
 *
 */
-(void)horizontalView:(GJGHorizontalView *)horizontalView didScrollToItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol GJGHorizontalViewDataSource <NSObject>

@required
/*
 *set pages
 */
-(NSInteger)horizontalView:(GJGHorizontalView *)horizontalView contentView:(UIView *)contentView numberOfPagesInSection:(NSInteger)section;
/*
 *set view
 */
-(UIView *)horizontalView:(GJGHorizontalView *)horizontalView contentView:(UIView *)contentView frame:(CGRect)frame viewForPageAtIndex:(NSUInteger)index;
/*
 *set content
 */
-(void)horizontalView:(GJGHorizontalView *)horizontalView contentView:(UIView *)contentView contentForPageAtIndex:(NSUInteger)index;

@end

@interface GJGHorizontalView : UIView

@property (nonatomic, strong) UICollectionView    * containerView;
@property (nonatomic, strong) NSMutableArray      * containerArray;
@property (nonatomic, strong) NSMutableArray      * titleArray;

@property (nonatomic, strong) UIView              * contentView;
@property (nonatomic, assign) GJGHorizontalViewStyle          style;
@property (nonatomic, assign) id <GJGHorizontalViewDelegate>  delegate;
@property (nonatomic, assign) id<GJGHorizontalViewDataSource> dataSource;

-(void)reloadData;

@end
