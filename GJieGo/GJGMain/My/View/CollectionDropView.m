//
//  CollectionDropView.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "CollectionDropView.h"

static CGFloat  topBarHeight           = 44.0;
static CGFloat  listViewHeight         = 44.0;

static NSString  * const secondCellIdentifier = @"SecondViewCell";
static NSString  * const headerIdentifier = @"Header";


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CollectionDropView (){
    UIView     *  _bgView;
    UIView     *  _bottomLine;
    NSInteger     _rowNum;
}

@property (nonatomic, strong)UIView    * bgView;

@end
@implementation CollectionDropView

#pragma mark - getter and setter method

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.tag = kBgViewTag;
        _bgView.alpha = 0.0;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:bgTap];
    }
    return _bgView;
}
-(UIView *)topBarView{
    if (!_topBarView) {
        _topBarView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, self.frame.size.width, topBarHeight)];
        _topBarView.tag = kTopBarViewTag;
        _topBarView.backgroundColor = [UIColor whiteColor];
//        _topBarView.layer.borderColor = JXColorFromRGB(0xc3c3c3).CGColor;
//        _topBarView.layer.borderWidth = 0.5f;
//        _topBarView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//        _topBarView.layer.shadowOffset = CGSizeMake(0, 2);//阴影偏移量
//        _topBarView.layer.shadowOpacity = 0.3;//阴影透明度
//        _topBarView.layer.shadowRadius = 3;//阴影半径
        _topBarView.userInteractionEnabled = YES;
    }
    return _topBarView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = JXColorFromRGB(0xf6f6f6);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setRowHeight:listViewHeight];
    }
    return _tableView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
        flowLayout.minimumLineSpacing = 10.0;//行间距(最小值)
        flowLayout.minimumInteritemSpacing = 14.0;//item间距(最小值)
        flowLayout.itemSize = CGSizeMake((kScreenWidth -58)/3,33);//item的大小
        flowLayout.sectionInset = UIEdgeInsetsMake(24, 15, 24, 15);//设置section的边距,默认(0,0,0,0)
        //flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width -firstViewWidth, 30);
        //flowLayout.footerReferenceSize = CGSizeMake(320, 20);
        
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = JXF1f1f1Color;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //1 注册复用cell(cell的类型和标识符)(可以注册多个复用cell, 一定要保证重用标示符是不一样的)注册到了collectionView的复用池里
        [_collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:secondCellIdentifier];
    }
    return _collectionView;
}
-(void)setUseTopButton:(BOOL)useTopButton{
    _useTopButton = useTopButton;
}
-(void)setSelectRow:(NSInteger)selectRow{
    _selectRow = selectRow;
}

-(NSMutableArray *)topItems{
    if (!_topItems || !_topItems.count) {
        _topItems = [NSMutableArray array];
        
        CGFloat width = kScreenWidth/_dataArray.count;
        CGFloat height = topBarHeight;

        _bottomLine = [UITool createBackgroundViewWithColor:JXMainColor frame:CGRectMake(0, height -1, width, 1)];
        
        for (int i = 0; i< _dataArray.count; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(width *i, 0, width, height);
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = kTopBarItemTag +i;
            [btn addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
            [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            CGFloat titleWidth = btn.currentTitle.length * 15 +2.5;
            CGFloat imageWidth = 15 +2.5;
            [btn setImage:JXImageNamed(@"tab_cbb_down_default") forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
            if (i <_dataArray.count -1) {
                UIView * xLine = [UITool createBackgroundViewWithColor:JXColorFromRGB(0xb7b7b7) frame:CGRectMake(width-0.5, 12, 0.5, 20)];
                [btn addSubview:xLine];
            }
            
            [self.topBarView addSubview:btn];
            [_topItems addObject:btn];
        }
        [self addSubview:self.topBarView];
        
    }
    return _topItems;
}

-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles{
    self = [self initWithFrame:frame];
    if (self) {
        NSAssert(buttonTitles.count, @"ButtonTitles can not be nil or empty！");
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        self.dataSource = delegate;
        self.style = DropListTable;
        self.animation = DropListAnimationOptionRotation;
        
        _dataArray = [NSMutableArray arrayWithArray:buttonTitles];
        _selectTab = -1;
        _selectIndexs = [NSMutableArray arrayWithCapacity:buttonTitles.count];
        _selectIndexs = [NSMutableArray arrayWithArray:@[@[@0,@0],@[@0,@0]]];
        
        if ([self.dataSource respondsToSelector:@selector(topItemsForDropListView:)]) {
            [self addTopItems:[self.dataSource topItemsForDropListView:self]];
        }else{
            //[self addTopItems:nil];
            [self initTopItems];
        }
        _selectItem = 0;
        _selectRow = -1;
    }
    return self;
}
-(void)addTopItems:(NSArray<UIView *>*)array{
    NSAssert(array.count, @"Items can not be nil or empty！");
    [self.topBarView removeAllSubviews];
    
    CGFloat width = kScreenWidth/_dataArray.count;
    CGFloat height = topBarHeight;
  
    _bottomLine = [UITool createBackgroundViewWithColor:JXMainColor frame:CGRectMake(0, height -1, width, 1)];
    
    for (int i = 0; i< array.count; i++) {
        NSAssert([array[i] isKindOfClass:[UIView class]], @"Item must be a view！");
        UIView * v = array[i];
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)v;
            [button addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
        }
//        if (i <array.count -1) {
//            UIView * xLine = [UITool createBackgroundViewWithColor:JXColorFromRGB(0xb7b7b7) frame:CGRectMake(width-0.5, 12, 0.5, 20)];
//            [v addSubview:xLine];
//        }
        
        [self.topBarView addSubview:v];
    }
    [self addSubview:self.topBarView];
    
}
-(void)initTopItems{
    CGFloat width = kScreenWidth/_dataArray.count;
    CGFloat height = topBarHeight;
    
    _topBarView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    _bottomLine = [UITool createBackgroundViewWithColor:JXMainColor frame:CGRectMake(0, height -1, width, 1)];
    
    for (int i = 0; i< _dataArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width *i, 0, width, height);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = kTopBarItemTag +i;
        [btn addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:JX999999Color forState:UIControlStateNormal];
        [btn setTitleColor:JXMainColor forState:UIControlStateSelected];
        [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGFloat titleWidth = btn.currentTitle.length * 15 +2.5;
        CGFloat imageWidth = 15 +2.5;
        [btn setImage:JXImageNamed(@"tab_cbb_down_default") forState:UIControlStateNormal];
        [btn setImage:JXImageNamed(@"tab_cbb_up_selected") forState:UIControlStateSelected];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        if (i <_dataArray.count -1) {
            UIView * xLine = [UITool createBackgroundViewWithColor:JXColorFromRGB(0xb7b7b7) frame:CGRectMake(width-0.5, 12, 0.5, 20)];
            [btn addSubview:xLine];
        }
        
        [self.topBarView addSubview:btn];
    }
    [self addSubview:self.topBarView];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
#pragma mark -
- (void)topTabAction:(UIButton *)button{
    NSInteger selectTab = button.tag - kTopBarItemTag;
    [self animation:_animation view:button];
    
    if ([self.delegate respondsToSelector:@selector(dropListView:didSelectTab:index:)]) {
        [self.delegate dropListView:self didSelectTab:button index:selectTab];
    }
    if ([self.dataSource respondsToSelector:@selector(dropListView:styleForItemIndex:)]) {
        self.style = [self.dataSource dropListView:self styleForItemIndex:selectTab];
    }
    
    if (_selectTab == selectTab) {
        [self dismiss];
    }else{
        _selectTab = selectTab;
        if([self.dataSource respondsToSelector:@selector(dropListView:numberOfRowsInFirstView:inSection:)]){
            if (self.style == DropListCollection) {
                NSInteger i = [self.dataSource dropListView:self numberOfRowsInFirstView:_collectionView inSection:0];
                if (i<=0) {
                    return;
                }
                if (i%3 == 0) {
                    _rowNum = i/3;
                }else{
                    _rowNum = i/3 +1;
                }
                
            }
            
        }
        [self show];
    }
    if (self.style == DropListTable) {
        [self.tableView reloadData];
    }else{
        [self.collectionView reloadData];
    }
}
-(void)animation:(DropListAnimation)animation view:(UIView *)view{
    NSInteger selectTab = view.tag - kTopBarItemTag;
    
    if (animation == DropListAnimationOptionChange) {
        for (UIView * v in view.superview.subviews) {
            if ([v isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)v;
                if (view.tag == btn.tag) {
                    btn.selected = !btn.selected;
                }else{
                    [btn setSelected:NO];
                }
            }
        }
    }else{
        if ([view.superview viewWithTag:self.selectTab +kTopBarItemTag] && self.selectTab != -1) {
            UIButton * btn =(UIButton *)[view.superview viewWithTag:self.selectTab +kTopBarItemTag];
            [UIView animateWithDuration:0.3 animations:^{
                btn.imageView.transform = CGAffineTransformRotate(btn.imageView.transform, DEGREES_TO_RADIANS(180));
            }];
        }
        if (self.selectTab != selectTab){
            UIButton * btn =(UIButton *)[view.superview viewWithTag:selectTab +kTopBarItemTag];
            [UIView animateWithDuration:0.3 animations:^{
                btn.imageView.transform = CGAffineTransformRotate(btn.imageView.transform, DEGREES_TO_RADIANS(180));
            }];
        }
    }
}
- (void)resetTabState{
    for (UIView * view in self.topBarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            [btn setSelected:NO];
        }
    }
}
- (void)show{
    [self show:YES];
}
- (void)show:(BOOL)animated{
    [self clearInfo];
    
    [self.bgView setFrame:CGRectMake(0, topBarHeight +self.frame.origin.y, self.frame.size.width, self.superview.frame.size.height - topBarHeight -self.frame.origin.y)];
    
    [self.superview addSubview:self.bgView];
    
    CGRect rect1 = CGRectZero;
    CGRect rect2 = CGRectZero;
    if (self.style == DropListTable) {
        [self.tableView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y +topBarHeight, self.frame.size.width, 0)];
        [self.superview addSubview:self.tableView];
        
        rect1 = self.tableView.frame;
        rect1.size.height = listViewHeight *[self.dataSource dropListView:self numberOfRowsInFirstView:_tableView inSection:0];
    }else{
        [self.collectionView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y +topBarHeight, self.frame.size.width, 0)];
        [self.superview addSubview:self.collectionView];
        
        rect2 = self.collectionView.frame;
        if (self.isHaveTabBar) {
            rect2.size.height = kScreenHeight - kNavStatusHeight - kTabBarHeight -topBarHeight;
        }else{
            rect2.size.height = kScreenHeight - kNavStatusHeight -topBarHeight;
            rect2.size.height = 48 +33 *_rowNum +10 *(_rowNum -1);
        }
    }
    //动画设置
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.5;
        self.tableView.frame =  rect1;
        self.collectionView.frame = rect2;
    }];
}

- (void)dismiss{
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animated{
    if (_selectTab != -1) {
        _selectTab = -1;
        if (animated) {
            CGRect rect1 = self.tableView.frame;
            CGRect rect2 = self.collectionView.frame;
            rect1.size.height = 0;
            rect2.size.height = 0;
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.alpha = 0.0f;
                self.tableView.frame = rect1;
                self.collectionView.frame = rect2;
            }completion:^(BOOL finished) {
                [self clearInfo];
            }];
        }else{
            [self clearInfo];
        }
    }
}
- (void)clearInfo{
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    if (_tableView) {
        [_tableView removeFromSuperview];
    }
    if (_collectionView) {
        [_collectionView removeFromSuperview];
    }
}
#pragma mark ----------------- JXDropListViewStyleList
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(dropListView:numberOfRowsInFirstView:inSection:)]) {
        return [self.dataSource dropListView:self numberOfRowsInFirstView:_tableView inSection:section];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor  = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
    }
    cell.backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.backgroundView.backgroundColor = JXFfffffColor;
    
    if ([self.dataSource respondsToSelector:@selector(dropListView:contentForRow:section:inView:)]) {

        if (indexPath.row == [[_selectIndexs[_selectTab] lastObject] integerValue]) {
            cell.backgroundView.backgroundColor = JXF1f1f1Color;
        }
        cell.textLabel.text = [self.dataSource dropListView:self contentForRow:indexPath.row section:indexPath.section inView:_tableView];
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectRow = indexPath.row;
    [_selectIndexs replaceObjectAtIndex:_selectTab withObject:@[@(indexPath.section),@(indexPath.row)]];
    [self resetTabState];
    
    if ([self.delegate respondsToSelector:@selector(dropListView:didSelectItemAtIndexPath:)]) {
        [self.delegate dropListView:self didSelectItemAtIndexPath:indexPath];
    }
    [self dismiss:YES];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //    if ([self.dataSource respondsToSelector:@selector(threeView:secondView:)]) {
    //        return [self.dataSource threeView:self secondView:nil];
    //    }   
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(dropListView:numberOfRowsInFirstView:inSection:)]) {
        return [self.dataSource dropListView:self numberOfRowsInFirstView:_collectionView inSection:section];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:secondCellIdentifier forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(dropListView:contentForRow:section:inView:)]) {
        [cell.titleView setTitle:[self.dataSource dropListView:self contentForRow:indexPath.item section:indexPath.section inView:_collectionView] forState:UIControlStateNormal];
        if (_selectItem == indexPath.item) {
            cell.titleView.backgroundColor = JXMainColor;
        }else{
            cell.titleView.backgroundColor = JXFfffffColor;
        }

    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击：%ld",(long)indexPath.item);
    _selectItem = indexPath.item;
    [_selectIndexs replaceObjectAtIndex:_selectTab withObject:@[@(indexPath.section),@(indexPath.item)]];
    [self resetTabState];
    [_collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(dropListView:didSelectItemAtIndexPath:)]) {
        [self.delegate dropListView:self didSelectItemAtIndexPath:indexPath];
    }
    [self dismiss];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


@end


@implementation CategoryCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleView];
    }
    return self;
}

//- (UILabel *)titleView{
//    if (!_titleView) {
//        _titleView = [[UILabel alloc ]initWithFrame:self.bounds];
//        _titleView.backgroundColor = JXFfffffColor;
//        _titleView.layer.cornerRadius = 8.f;
//        _titleView.layer.masksToBounds = YES;
//        //_titleView.clipsToBounds = YES;
//        _titleView.textColor = JX333333Color;
//        _titleView.font = JXFontForNormal(13);
//        _titleView.textAlignment = NSTextAlignmentCenter;
//        
//    }
//    return _titleView;
//}

- (UIButton *)titleView{
    if (!_titleView) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.frame = self.bounds;
        _titleView.backgroundColor = JXFfffffColor;
        _titleView.layer.cornerRadius = 7.5f;
        _titleView.layer.masksToBounds = YES;
        //_titleView.clipsToBounds = YES;
        [_titleView setTitleColor:JX333333Color forState:UIControlStateNormal];
        _titleView.titleLabel.font = JXFontForNormal(13);
        _titleView.userInteractionEnabled = NO;
    }
    return _titleView;
}

@end

@implementation TopAttributes

- (instancetype)init{
    if (self == [super init]) {
        self.normalColor = JX999999Color;
        self.highlightedColor = JX333333Color;
        self.separatorColor = JXSeparatorColor;
    }
    return self;
}

@end
