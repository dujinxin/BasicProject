//
//  CollectionDropView.h
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kBgViewTag     = 9000,
    kTopBarViewTag = 9999,
    kTopBarItemTag = 10000,
}kDropListViewTag;

@class CollectionDropView;
@protocol CollectionDropViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)dropListView:(CollectionDropView *)dropListView didSelectTab:(UIButton *)button index:(NSInteger)index;
- (void)dropListView:(CollectionDropView *)dropListView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol CollectionDropViewDataSource <NSObject>

@required
-(NSInteger)dropListView:(CollectionDropView *)dropListView numberOfRowsInFirstView:(UIView *)view inSection:(NSInteger)section;
-(NSString *)dropListView:(CollectionDropView *)dropListView contentForRow:(NSInteger)row section:(NSInteger)section inView:(UIView *)view;


@end

@interface CollectionDropView : UIView<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITableView              * _tableView;
    UICollectionView         * _collectionView;
    UIView                   * _topBarView;
}

@property (nonatomic, strong)UITableView        * tableView;
@property (nonatomic, strong)UICollectionView   * collectionView;
@property (nonatomic, strong)UIView        * topBarView;

@property (nonatomic, assign,getter=isUseTopButton)BOOL            useTopButton;
@property (nonatomic, assign,getter=isHiddenList)  BOOL            hiddenList;
@property (nonatomic, strong)NSMutableArray* dataArray;
@property (nonatomic, assign)NSInteger       selectTab;
@property (nonatomic, assign)NSInteger       selectRow;
@property (nonatomic, assign)NSInteger       selectItem;
@property (nonatomic, strong)NSMutableArray* selectIndexs;

@property (nonatomic, assign)id<CollectionDropViewDelegate>   delegate;
@property (nonatomic, assign)id<CollectionDropViewDataSource> dataSource;

@property (nonatomic, assign)BOOL            isHaveTabBar;//界面中是否有babBar


- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles;
- (void)show;
- (void)show:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;

@end


@interface CategoryCell : UICollectionViewCell

//@property (nonatomic, strong) UILabel * titleView;
@property (nonatomic, strong) UIButton * titleView;

@end
