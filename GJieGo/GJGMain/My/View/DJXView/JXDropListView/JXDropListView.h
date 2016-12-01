//
//  JXDropListView.h
//  JXView
//
//  Created by dujinxin on 15/12/5.
//  Copyright © 2015年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kBgViewTag     = 9000,
    kTopBarViewTag = 9999,
    kTopBarItemTag = 10000,
}kDropListViewTag;

@class JXDropListView;
@protocol JXDropListViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)dropListView:(JXDropListView *)dropListView didSelectItem:(UIButton *)button index:(NSInteger)index;
- (void)dropListView:(JXDropListView *)dropListView didSelectFristList:(UIView *)firstListView row:(NSInteger)row;
- (void)dropListView:(JXDropListView *)dropListView didSelectSecondList:(UIView *)secondListView row:(NSInteger)row;
@end


@protocol JXDropListViewDataSource <NSObject>

@required
-(NSInteger)dropListView:(JXDropListView *)dropListView numberOfRowsInFirstView:(UIView *)view inSection:(NSInteger)section;
-(NSString *)dropListView:(JXDropListView *)dropListView contentForRow:(NSInteger)row section:(NSInteger)section inView:(UIView *)view;
-(NSInteger)numberOfComponentsInDropListView:(JXDropListView *)dropListView itemIndex:(NSInteger)index;
@optional
-(NSInteger)dropListView:(JXDropListView *)dropListView numberOfRowsInSecondView:(UIView *)view inSection:(NSInteger)section;


@end

@interface JXDropListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView              * _tableView;
    UITableView              * _secondTableView;
    UIView                   * _topBarView;
}

@property (nonatomic, strong)UITableView   * tableView;
@property (nonatomic, strong)UITableView   * secondTableView;
@property (nonatomic, strong)UIView        * topBarView;

@property (nonatomic, assign,getter=isUseTopButton)BOOL            useTopButton;
@property (nonatomic, assign,getter=isHiddenList)  BOOL            hiddenList;
@property (nonatomic, strong)NSMutableArray* dataArray;
@property (nonatomic, assign)NSInteger       selectItem;
@property (nonatomic, assign)NSInteger       selectRow;
@property (nonatomic, assign)NSInteger       selectSecondRow;
@property (nonatomic, strong)NSMutableArray* selectIndexs;

@property (nonatomic, assign)id<JXDropListViewDelegate>   delegate;
@property (nonatomic, assign)id<JXDropListViewDataSource> dataSource;

@property (nonatomic, assign)BOOL            isHaveTabBar;//界面中是否有babBar


- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles;
- (void)show;
- (void)show:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;
@end
