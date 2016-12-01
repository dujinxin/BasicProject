//
//  JXThreeView.m
//  FJ_Project
//
//  Created by dujinxin on 15/11/26.
//  Copyright © 2015年 BLW. All rights reserved.
//

#import "JXThreeView.h"
#import "FirstViewCell.h"
#import "SecondViewCell.h"
#import "SecondViewReusableView.h"
//#import "CategoryListEntity.h"

static NSString  * const secondCellIdentifier = @"SecondViewCell";
static NSString  * const headerIdentifier = @"Header";

static NSInteger firstViewWidth = 80;

@implementation JXThreeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.firstView];
        [self addSubview:self.secondView];
    }
    return self;
}
-(void)layoutSubviews{
    [_firstView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, firstViewWidth, self.frame.size.height)];
    [_secondView setFrame:CGRectMake(_firstView.frame.size.width, self.frame.origin.y, self.frame.size.width -firstViewWidth, self.frame.size.height)];
}
#pragma mark - layz init
-(UITableView *)firstView{
    if (!_firstView) {
        _firstView = [[UITableView alloc]init];
        _firstView.backgroundColor = JXColorFromRGB(0xf6f6f6);
//        _firstView.layer.borderColor = JXColorFromRGB(0xdcdcdc).CGColor;
//        _firstView.layer.borderWidth = 1;
        _firstView.showsVerticalScrollIndicator = NO;
        _firstView.showsHorizontalScrollIndicator = NO;
        _firstView.separatorColor = JXColorFromRGB(0xdcdcdc);
        _firstView.delegate = self;
        _firstView.dataSource = self;
        _firstView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self viewDidLayoutSubviews];
    }
    return _firstView;
}
-(UICollectionView *)secondView{
    if (!_secondView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
        flowLayout.minimumLineSpacing = 23.0;//行间距(最小值)
        flowLayout.minimumInteritemSpacing = 10.0;//item间距(最小值)
        flowLayout.itemSize = CGSizeMake(60 *kPercent,78 *kPercent);//item的大小
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//设置section的边距,默认(0,0,0,0)
        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width -firstViewWidth, 30);
        //flowLayout.footerReferenceSize = CGSizeMake(320, 20);
        
        
        
        _secondView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _secondView.backgroundColor = [UIColor whiteColor];
        _secondView.delegate = self;
        _secondView.dataSource = self;
        //1 注册复用cell(cell的类型和标识符)(可以注册多个复用cell, 一定要保证重用标示符是不一样的)注册到了collectionView的复用池里
        [_secondView registerClass:[SecondViewCell class] forCellWithReuseIdentifier:secondCellIdentifier];
        //第一个参数:返回的View类型
        //第二个参数:设置View的种类(header, footer)
        //第三个参数:设置重用标识符
        [_secondView registerClass:[SecondViewReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        //    [collectionView registerClass:[FootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    }
    return _secondView;
}
-(void)reloadData{
    [_firstView reloadData];
    [_secondView reloadData];
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.delegate respondsToSelector:@selector()) {
//        <#statements#>
//    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectRow = indexPath.row;
    [self reloadData];
}
-(void)viewDidLayoutSubviews {
    
    if ([_firstView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_firstView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_firstView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_firstView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(threeView:firstView:numberOfRowsInSection:)]) {
        return [self.dataSource threeView:self firstView:_firstView numberOfRowsInSection:section];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellId";
    FirstViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[FirstViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.contentView.backgroundColor = JXColorFromRGB(0xf6f6f6);
        cell.backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = JXColorFromRGB(0xf6f6f6);
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
        cell.titleView.frame = CGRectMake(0, 0, firstViewWidth,50);
        cell.line.frame = CGRectMake(0, 50 -0.5, firstViewWidth, 0.5);
    }
    cell.titleView.textColor = JX333333Color;
    cell.titleView.backgroundColor = JXColorFromRGB(0xf6f6f6);
    if (_selectRow == indexPath.row) {
        cell.titleView.textColor = JXMainColor;
        cell.titleView.backgroundColor = [UIColor whiteColor];
    }
    if ([self.dataSource respondsToSelector:@selector(threeView:firstView:contentForRow:section:)]) {
        cell.titleView.text = [self.dataSource threeView:self firstView:_firstView contentForRow:indexPath.row section:indexPath.section];
    }
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.dataSource respondsToSelector:@selector(threeView:secondView:)]) {
        return [self.dataSource threeView:self secondView:nil];
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(threeView:thirdView:numberOfItemsInSection:)]) {
        return [self.dataSource threeView:self thirdView:nil numberOfItemsInSection:section];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SecondViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:secondCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SecondViewCell alloc]init ];
    }
    //13600128764 .. su123456

    if ([self.dataSource respondsToSelector:@selector(threeView:thirdView:contentForRow:section:)]) {
//        CategoryListEntity * thirdEntity = (CategoryListEntity *)[self.dataSource threeView:self thirdView:cell contentForRow:indexPath.row section:indexPath.section];
//        if (thirdEntity) {
//            cell.titleView.text = thirdEntity.category_name;
//            [cell.imageView setImageWithURL:[NSURL URLWithString:thirdEntity.icon] placeholderImage:JXImageNamed(@"category_goods")];
//        }
    }
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader ]){
        reuseIdentifier = headerIdentifier;
    }else{
        reuseIdentifier = nil;
    }
    
    SecondViewReusableView *headView =  [collectionView dequeueReusableSupplementaryViewOfKind :UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){

        if ([self.dataSource respondsToSelector:@selector(threeView:secondView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            headView.titleLabel.text = [self.dataSource threeView:self secondView:headView viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            
            [headView.titleLabel setClickEvent:^(id sender) {
                if ([self.delegate respondsToSelector:@selector(threeView:secondViewDidSelectItemAtIndexPath:)]) {
                    [self.delegate threeView:self secondViewDidSelectItemAtIndexPath:indexPath];
                }
            }];
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
    }
    return headView;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击：%ld",(long)indexPath.item);
    if ([self.delegate respondsToSelector:@selector(threeView:thirdViewDidSelectItemAtIndexPath:)]) {
        [self.delegate threeView:self thirdViewDidSelectItemAtIndexPath:indexPath];
    }
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
