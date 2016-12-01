//
//  JXThreeView.h
//  FJ_Project
//
//  Created by dujinxin on 15/11/26.
//  Copyright © 2015年 BLW. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JXThreeView;
@protocol JXThreeViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)threeView:(JXThreeView *)selectView secondViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)threeView:(JXThreeView *)selectView thirdViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol JXThreeViewDataSource <NSObject>

@required
-(NSInteger)threeView:(JXThreeView *)threeView firstView:(UIView *)firstView numberOfRowsInSection:(NSInteger)section;
-(NSInteger)threeView:(JXThreeView *)threeView secondView:(UIView *)secondView;
-(NSInteger)threeView:(JXThreeView *)threeView thirdView:(UIView *)thirdView numberOfItemsInSection:(NSInteger)section;

-(id)threeView:(JXThreeView *)threeView firstView:(UIView *)firstView contentForRow:(NSInteger)row section:(NSInteger)section;
-(id)threeView:(JXThreeView *)threeView thirdView:(UIView *)thirdView contentForRow:(NSInteger)row section:(NSInteger)section;
-(id)threeView:(JXThreeView *)threeView secondView:(UIView *)secondView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;


@end

@interface JXThreeView : UIView<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITableView              * _firstView;
    UICollectionView         * _secondView;
}
@property (nonatomic, strong)UITableView       * firstView;
@property (nonatomic, strong)UICollectionView  * secondView;
@property (nonatomic, strong)NSMutableArray    * dataArray;
@property (nonatomic, assign)NSInteger           selectRow;
@property (nonatomic, assign)id<JXThreeViewDelegate>   delegate;
@property (nonatomic, assign)id<JXThreeViewDataSource> dataSource;


//- (instancetype)initWithFrame:(CGRect)frame;


- (void)reloadData;
@end
