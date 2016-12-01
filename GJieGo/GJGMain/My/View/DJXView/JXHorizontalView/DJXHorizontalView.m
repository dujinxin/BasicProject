//
//  DJXHorizontalView.m
//  GJieGo
//
//  Created by dujinxin on 16/5/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DJXHorizontalView.h"


static NSString  * const firstCellIdentifier = @"FirstViewCell";
static NSString  * const secondCellIdentifier = @"SecondViewCell";
static NSString  * const headerIdentifier = @"Header";

@interface DJXHorizontalView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CGSize _size;
}

@end

@implementation DJXHorizontalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:DJXHorizontalViewDefault];
}
-(instancetype)initWithFrame:(CGRect)frame style:(DJXHorizontalViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        if (style) {
            _style = style;
        }else{
            _style = DJXHorizontalViewDefault;
        }
        [self initDataWithFrame:frame];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(DJXHorizontalViewStyle)style containers:(NSArray *)containers parentViewController:(UIViewController *)parentViewController{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        _containerArray = [NSMutableArray arrayWithArray:containers];
        _parentViewController = parentViewController;
        for (UIViewController *childVc in _containerArray) {
            if ([childVc isKindOfClass:[UINavigationController class]]) {
                NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
                
            }
            if (self.parentViewController) {
                [self.parentViewController addChildViewController:childVc];
            }
        }
        
        [self initDataWithFrame:frame];
    }
    return self;
}
-(void)initDataWithFrame:(CGRect)frame{
    _size = frame.size;
    self.backgroundColor = [UIColor blueColor];
    
    //创建流布局
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    //设置大小
    flowlayout.itemSize = _size;
    //设置滚动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置最小间距
    flowlayout.minimumLineSpacing = 0;
    
    //赋值
    self.containerView = ({
        //布局
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height) collectionViewLayout:flowlayout];
        //翻页效果
        collectionView.pagingEnabled = YES;
        //collectionView.scrollEnabled = NO;
        //水平滚动
        collectionView.showsHorizontalScrollIndicator = NO;
        //关闭弹簧效果
        collectionView.bounces = NO;
        //注册
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:firstCellIdentifier];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:secondCellIdentifier];
        //设置代理
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView;
    });
    [self addSubview:_containerView];
}
-(void)reloadData{
    _size = self.frame.size;
    self.containerView.frame = CGRectMake(0, 0, _size.width, _size.height);
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    NSArray * array = [NSArray arrayWithObjects:indexPath, nil];
    [self.containerView reloadItemsAtIndexPaths:array];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_containerArray.count) {
        return _containerArray.count;
    }
    if ([self.dataSource respondsToSelector:@selector(horizontalView:contentView:numberOfPagesInSection:)]) {
        return [self.dataSource horizontalView:self contentView:nil numberOfPagesInSection:section];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc ]init ];
    }
//    cell.backgroundColor = [UIColor redColor];
//    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (self.containerArray.count) {
        id object = [self.containerArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)object;
            vc.view.frame = self.bounds;
            [cell.contentView addSubview:vc.view];
            [vc didMoveToParentViewController:self.parentViewController];

        }else if([object isKindOfClass:[UIView class]]){
            UIView * view = (UIView *)object;
            view.frame = cell.contentView.bounds;
            view.tag = 1000;
            [cell.contentView addSubview:view];
        }
    }else{
        UIView * contentView = nil;
        if ([self.dataSource respondsToSelector:@selector(horizontalView:contentView:frame:viewForPageAtIndex:)]) {
            contentView = [self.dataSource horizontalView:self contentView:nil frame:cell.contentView.bounds viewForPageAtIndex:indexPath.item];
        }
        if (nil == contentView) {
            contentView = [[UIView alloc]initWithFrame:cell.contentView.bounds];
            contentView.backgroundColor = [UIColor purpleColor];
        }
        contentView.frame = cell.contentView.bounds;
        contentView.tag = 1000;
        [cell.contentView addSubview:contentView];
        
        if ([self.dataSource respondsToSelector:@selector(horizontalView:contentView:contentForPageAtIndex:)]) {
            [self.dataSource horizontalView:self contentView:contentView contentForPageAtIndex:indexPath.item];
        }
    }
    
    return cell;
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger page = offset/self.frame.size.width;
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    [self.containerView reloadItemsAtIndexPaths:@[indexPath]];
    if ([self.delegate respondsToSelector:@selector(horizontalView:didScrollToItemAtIndexPath:)]) {
        [self.delegate horizontalView:self didScrollToItemAtIndexPath:indexPath];
    }
}




//切换视图
- (void)segmentClick{
    
//    CGPoint offsetPoint = CGPointMake(self.segment.selectedSegmentIndex * KScreenWith, -(KStatusHeight+KNavBarHeight));
//    NSLog(@"%zd",offsetPoint);
//    [self.collectionView setContentOffset:offsetPoint];
}

@end
