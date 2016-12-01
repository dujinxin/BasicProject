//
//  JXDropListView.m
//  JXView
//
//  Created by dujinxin on 15/12/5.
//  Copyright © 2015年 e-future. All rights reserved.
//

#import "JXDropListView.h"


static CGFloat  topBarHeight           = 40.0;
static CGFloat  firstListViewWidth     = 150;
static CGFloat  listViewHeight         = 44.0;

@interface JXDropListView (){
    UIView     *  _bgView;
    UIView     *  _bottomLine;
    NSArray    *  sortData;//特殊处理，不需要可自行删除
}

@property (nonatomic, strong)UIView    * bgView;

@end
@implementation JXDropListView

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
        _topBarView.layer.borderColor = JXColorFromRGB(0xc3c3c3).CGColor;
        _topBarView.layer.borderWidth = 0.5f;
        _topBarView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        _topBarView.layer.shadowOffset = CGSizeMake(0, 2);//阴影偏移量
        _topBarView.layer.shadowOpacity = 0.3;//阴影透明度
        _topBarView.layer.shadowRadius = 3;//阴影半径
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
-(UITableView *)secondTableView{
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _secondTableView.showsVerticalScrollIndicator = NO;
        _secondTableView.showsHorizontalScrollIndicator = NO;
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_secondTableView setRowHeight:listViewHeight];
    }
    return _secondTableView;
}

-(void)setUseTopButton:(BOOL)useTopButton{
    _useTopButton = useTopButton;
}
-(void)setSelectRow:(NSInteger)selectRow{
    _selectRow = selectRow;
}


-(instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles{
    self = [self initWithFrame:frame];
    if (self) {
        NSAssert(buttonTitles.count, @"ButtonTitles can not be nil or empty！");
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        _dataArray = [NSMutableArray arrayWithArray:buttonTitles];
        _hiddenList = YES;
        _selectItem = -1;
        _selectIndexs = [NSMutableArray arrayWithCapacity:buttonTitles.count];
        _selectIndexs = [NSMutableArray arrayWithArray:@[@[@(-1),@0],@[@0,@0],@[@0,@0],@[@0,@0]]];
        [self initTopItems];
        _selectRow = -1;
        _selectSecondRow = -1;
        sortData = @[@"默认排序",@"折扣从高到低",@"商品名称排序",@"最新上架产品"];
    }
    return self;
}
-(void)initTopItems{
    CGFloat width = kScreenWidth/_dataArray.count;
    CGFloat height = topBarHeight;
    
    _topBarView.frame = CGRectMake(0, 0, kScreenWidth, height);
    
    _bottomLine = [UITool createBackgroundViewWithColor:JXMainColor frame:CGRectMake(0, height -2, width, 2)];
    
    for (int i = 0; i< _dataArray.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width *i, 0, width, height);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = kTopBarItemTag +(_dataArray.count -1) -i;
        [btn addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 0) {
//            [btn setTitleColor:JXMainDarkColor forState:UIControlStateNormal];
//            [btn addSubview:_bottomLine];
//        }else{
            [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
//        }
        if (i <_dataArray.count -1) {
            UIView * xLine = [UITool createBackgroundViewWithColor:JXColorFromRGB(0xb7b7b7) frame:CGRectMake(width-0.5, 12, 0.5, 16)];
            [btn addSubview:xLine];
        }
        if (btn.tag -kTopBarItemTag != 2) {
            [self addArrow:btn];
        }
        [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.topBarView addSubview:btn];
    }
    [self addSubview:self.topBarView];
    
//    UIView *line_sep = [[UIView alloc]initWithFrame:CGRectMake(0, height- 1, self.frame.size.width, 1)];
//    line_sep.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:line_sep];
}
-(void)addArrow:(UIButton *)btn{
    NSInteger i = btn.tag - kTopBarItemTag;
    if (i == 0) {
        [btn setImage:JXImageNamed(@"pro_more_unselect") forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -6*2, 0, 11);
//        btn.titleLabel.backgroundColor = [UIColor redColor];
//        btn.imageView.backgroundColor = [UIColor yellowColor];
        btn.imageEdgeInsets = UIEdgeInsetsMake(17.5, btn.frame.size.width -13, 17.5, 5);
    }else if (i == 1){
        [btn setImage:JXImageNamed(@"pro_price_unselect") forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -6*2, 0, 0);
//        btn.titleLabel.backgroundColor = [UIColor redColor];
//        btn.imageView.backgroundColor = [UIColor yellowColor];
        btn.imageEdgeInsets = UIEdgeInsetsMake(14.5, btn.frame.size.width/2 +15 +2, 14.5, btn.frame.size.width/2 -(15 +6 +2));
    }else if (i == 3){
        [btn setImage:JXImageNamed(@"pro_more_unselect") forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -6*2, 0, 11);
//        btn.titleLabel.backgroundColor = [UIColor redColor];
//        btn.imageView.backgroundColor = [UIColor yellowColor];
        btn.imageEdgeInsets = UIEdgeInsetsMake(17.5, btn.frame.size.width -13, 17.5, 5);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
//    if (_useTopButton) {
//        [_topBarView setFrame:CGRectMake(0, 0, self.frame.size.width, topBarHeight)];
//        
//        if ([self.dataSource numberOfComponentsInDropListView:self itemIndex:_selectItem] ==2) {
//            [_tableView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width/3, self.frame.size.height -topBarHeight)];
//            [_secondTableView setFrame:CGRectMake(self.frame.size.width/3, topBarHeight, self.frame.size.width/3 *2, self.frame.size.height -topBarHeight)];
//        }else{
//            [_tableView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width, self.frame.size.height -topBarHeight)];
//        }
//        
//    }else{
//        if ([self.dataSource numberOfComponentsInDropListView:self itemIndex:_selectItem] ==2) {
//            [_tableView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width/3, self.frame.size.height -topBarHeight)];
//            [_secondTableView setFrame:CGRectMake(self.frame.size.width/3, topBarHeight, self.frame.size.width/3 *2, self.frame.size.height -topBarHeight)];
//        }else{
//            [_tableView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width, self.frame.size.height -topBarHeight)];
//        }
//        
//    }
    
}
#pragma mark -
- (void)topTabAction:(UIButton *)button{
    NSInteger selectItem = button.tag - kTopBarItemTag;
    for (UIView * view in button.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            if (button.tag == btn.tag) {
//                [UIView transitionFromView:_bottomLine toView:btn duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
                    if (_bottomLine.superview) {
                        [_bottomLine removeFromSuperview];
                    }
                    [btn addSubview:_bottomLine];
//                }];
                [btn setTitleColor:JXMainColor forState:UIControlStateNormal];
                if (button.tag -kTopBarItemTag == 2) {
                }else if (button.tag -kTopBarItemTag == 1){
                    btn.selected = !btn.selected;
                    if (btn.selected) {
                        [btn setImage:JXImageNamed(@"pro_price_rise") forState:UIControlStateNormal];
                    }else{
                        [btn setImage:JXImageNamed(@"pro_price_fall") forState:UIControlStateNormal];
                    }
                }
            }else{
                if (btn.tag != kTopBarItemTag +3 && button.tag -kTopBarItemTag != 3) {
                    [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
                }
                if(button.tag -kTopBarItemTag == 1){//点击价格
                    if (btn.tag == kTopBarItemTag +2) {
                    }else if(btn.tag == kTopBarItemTag){
                        [btn setImage:JXImageNamed(@"pro_more_unselect") forState:UIControlStateNormal];
                        [btn setTitle:_dataArray.lastObject forState:UIControlStateNormal];
                    }
                }else if (button.tag -kTopBarItemTag == 2){//点击销量
                    if (btn.tag == kTopBarItemTag +1) {
                        btn.selected = NO;
                        [btn setImage:JXImageNamed(@"pro_price_unselect") forState:UIControlStateNormal];
                    }else if (btn.tag == kTopBarItemTag){
                        [btn setImage:JXImageNamed(@"pro_more_unselect") forState:UIControlStateNormal];
                        [btn setTitle:_dataArray.lastObject forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(dropListView:didSelectItem:index:)]) {
        [self.delegate dropListView:self didSelectItem:button index:selectItem];
    }
    
    BOOL isHasContents = NO;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInDropListView:itemIndex:)]) {
        NSInteger num = [self.dataSource numberOfComponentsInDropListView:self itemIndex:selectItem];
        isHasContents = num >0 ? YES :NO;
    }
    
    if (isHasContents) {
        
        if (_selectItem == selectItem) {
            _hiddenList = !_hiddenList;
            [self dismiss];
        }else{
            
            _hiddenList = NO;
            _selectRow = [[_selectIndexs[selectItem] firstObject] integerValue];
            _selectItem = selectItem;
            if([self.dataSource respondsToSelector:@selector(dropListView:numberOfRowsInFirstView:inSection:)]){
                NSInteger i = [self.dataSource dropListView:self numberOfRowsInFirstView:_tableView inSection:0];
                if (i<=0) {
                    return;
                }
            }
            
            
//            currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
//            [UIView animateWithDuration:0.3 animations:^{
//                currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
//            }];
            
            [self show];
           
        }
        
        [_tableView reloadData];
        [_secondTableView reloadData];
    }else{
        if (_hiddenList ==NO) {
            [self dismiss];
        }
        _hiddenList = YES;
        [_selectIndexs replaceObjectAtIndex:0 withObject:@[@(-1),@0]];
    }
}
- (void)show{
    [self show:YES];
}
- (void)show:(BOOL)animated{
    
    [self.bgView setFrame:CGRectMake(0, topBarHeight +self.frame.origin.y, self.frame.size.width, self.superview.frame.size.height - topBarHeight -self.frame.origin.y)];
    
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInDropListView:itemIndex:)]) {
        number = [self.dataSource numberOfComponentsInDropListView:self itemIndex:_selectItem];
    }
    [self.superview addSubview:self.bgView];
    [self.superview addSubview:self.tableView];
    [self.superview addSubview:self.secondTableView];
    if (number == 1) {
        [self.tableView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y +topBarHeight, self.frame.size.width, 0)];
        self.secondTableView.hidden = YES;
    }else if (number == 2){
        [self.tableView setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y +topBarHeight, firstListViewWidth, 0)];
        [self.secondTableView setFrame:CGRectMake(firstListViewWidth, self.frame.origin.y +topBarHeight, self.frame.size.width -firstListViewWidth, 0)];
        self.secondTableView.hidden = NO;
    }
    
    CGRect rect1 = self.tableView.frame;
    CGRect rect2 = self.secondTableView.frame;
    //动画设置位置
    rect1.size.height = listViewHeight *5;
    rect2.size.height = listViewHeight *5;
    if (number ==2) {
//        rect1.size.height = listViewHeight *5;
//        rect2.size.height = listViewHeight *5;
        if (self.isHaveTabBar) {
            rect1.size.height = kScreenHeight - kNavStatusHeight - kTabBarHeight -topBarHeight;
            rect2.size.height = kScreenHeight - kNavStatusHeight - kTabBarHeight -topBarHeight;
        }else{
            rect1.size.height = kScreenHeight - kNavStatusHeight -topBarHeight;
            rect2.size.height = kScreenHeight - kNavStatusHeight -topBarHeight;
        }
        
        
    }else{
        rect1.size.height = listViewHeight *4;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.5;
        self.tableView.frame =  rect1;
        self.secondTableView.frame = rect2;
    }];
}

-(void)willIngDidDisappear:(NSInteger)row{
    if ([self.delegate respondsToSelector:@selector(dropListView:didSelectFristList:row:)]) {
        [self.delegate dropListView:self didSelectFristList:_tableView row:row];
    }
    [self dismiss:YES];
}
- (void)dismiss
{
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animated
{
    if (_selectItem != -1) {
        _selectItem = -1;
        _selectRow = -1;
        _selectSecondRow = -1;
        _hiddenList = YES;
        if (animated) {
            CGRect rect1 = self.tableView.frame;
            CGRect rect2 = self.secondTableView.frame;
            rect1.size.height = 0;
            rect2.size.height = 0;
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.alpha = 0.0f;
                self.tableView.frame = rect1;
                self.secondTableView.frame = rect2;
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
    if (_secondTableView) {
        [_secondTableView removeFromSuperview];
    }
}
-(void)resTopBarItem:(id)object index:(NSInteger)index{
    //NSInteger selectItem = button.tag - kTopBarItemTag;
    for (UIView * view in _topBarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            if (btn.tag == kTopBarItemTag +_selectItem) {
                [btn setTitleColor:JXMainColor forState:UIControlStateNormal];
                [btn setTitle:object forState:UIControlStateNormal];
                if (index == 3) {
                    if ([btn.currentTitle isEqualToString:@"全部商品"]) {
//                        [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
//                        [btn setImage:JXImageNamed(@"pro_more_unselect") forState:UIControlStateNormal];
                        [btn setImage:JXImageNamed(@"pro_more_select") forState:UIControlStateNormal];
                    }else{
                        [btn setImage:JXImageNamed(@"pro_more_select") forState:UIControlStateNormal];
                    }
                }else if (index == 0){
                    if ([btn.currentTitle isEqualToString:@"更多排序"]) {
                        [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
                        [btn setImage:JXImageNamed(@"pro_more_unselect") forState:UIControlStateNormal];
                    }else{
                        [btn setImage:JXImageNamed(@"pro_more_select") forState:UIControlStateNormal];
                    }
                }
            }else{
                if (index == 0) {
                    if (btn.tag -kTopBarItemTag != 3) {
                        [btn setTitleColor:JXColorFromRGB(0x777777) forState:UIControlStateNormal];
                    }
                    if (btn.tag == kTopBarItemTag +1){
                        btn.selected = NO;
                        [btn setImage:JXImageNamed(@"pro_price_unselect") forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}
#pragma mark ----------------- JXDropListViewStyleList
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(dropListView:numberOfRowsInFirstView:inSection:)]) {
        if (tableView == _tableView) {
            return [self.dataSource dropListView:self numberOfRowsInFirstView:_tableView inSection:section];
        }
    }
    if ([self.dataSource respondsToSelector:@selector(dropListView:numberOfRowsInSecondView:inSection:)]) {
        if (tableView == _secondTableView){
            return [self.dataSource dropListView:self numberOfRowsInSecondView:_secondTableView inSection:section];
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
//        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:[UITool createBackgroundViewWithColor:JXEeeeeeColor frame:CGRectMake(0, 44-1, kScreenWidth, 1)]];
    }
    cell.backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.backgroundView.backgroundColor = JXColorFromRGB(0xf6f6f6);
    cell.textLabel.textColor = JXTextColor;
    if ([self.dataSource respondsToSelector:@selector(dropListView:contentForRow:section:inView:)]) {
        if (tableView == _tableView) {
            cell.backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
            cell.backgroundView.backgroundColor = JXColorFromRGB(0xf6f6f6);
            if (_selectRow >= 0) {
                if (_selectRow == indexPath.row) {
                    cell.textLabel.textColor = JXMainColor;
                    cell.backgroundView.backgroundColor = [UIColor whiteColor];
                }
            }else{
                if (indexPath.row == [[_selectIndexs[_selectItem] firstObject] integerValue]) {
                    cell.textLabel.textColor = JXMainColor;
                    cell.backgroundView.backgroundColor = [UIColor whiteColor];
                }
            }
            
            if (_selectItem == 0) {
                cell.textLabel.text = sortData[indexPath.row];
            }else if (_selectItem == 3){
                cell.textLabel.text = [self.dataSource dropListView:self contentForRow:indexPath.row section:indexPath.section inView:_tableView];
            }
        }
        else if (tableView == _secondTableView) {
            if (indexPath.row == [[_selectIndexs[_selectItem] lastObject] integerValue] && _selectRow == [[_selectIndexs[_selectItem] firstObject] integerValue]) {
                cell.textLabel.textColor = JXMainColor;
                cell.backgroundView.backgroundColor = [UIColor whiteColor];
            }
            cell.textLabel.text = [self.dataSource dropListView:self contentForRow:indexPath.row section:indexPath.section inView:_secondTableView];
        }
    }
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource numberOfComponentsInDropListView:self itemIndex:_selectItem] == 2) {
        if (tableView == _tableView) {
            _selectRow = indexPath.row;
            if (indexPath.row == 0) {
                [_selectIndexs replaceObjectAtIndex:_selectItem withObject:@[@(_selectRow),@0]];
                UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                [self resTopBarItem:cell.textLabel.text index:3];
                if ([self.delegate respondsToSelector:@selector(dropListView:didSelectFristList:row:)]) {
                    [self.delegate dropListView:self didSelectFristList:_tableView row:indexPath.row];
                }
                [self dismiss:YES];
            }else{
                [_tableView reloadData];
                [_secondTableView reloadData];
            }
        }else{
            _selectSecondRow = indexPath.row;
            [_selectIndexs replaceObjectAtIndex:_selectItem withObject:@[@(_selectRow),@(_selectSecondRow)]];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            [self resTopBarItem:cell.textLabel.text index:3];
            if ([self.delegate respondsToSelector:@selector(dropListView:didSelectSecondList:row:)]) {
                [self.delegate dropListView:self didSelectSecondList:_secondTableView row:indexPath.row];
            }
            [self dismiss:YES];
        }
    }else{
        _selectRow = indexPath.row;
        [_selectIndexs replaceObjectAtIndex:_selectItem withObject:@[@(_selectRow),@0]];
//        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        [self resTopBarItem:cell.textLabel.text index:0];
        [self resTopBarItem:[self.dataSource dropListView:self contentForRow:indexPath.row section:indexPath.section inView:_tableView] index:0];
        if ([self.delegate respondsToSelector:@selector(dropListView:didSelectFristList:row:)]) {
            [self.delegate dropListView:self didSelectFristList:_tableView row:indexPath.row];
        }
        [self dismiss:YES];
    }
    
    
}

@end
