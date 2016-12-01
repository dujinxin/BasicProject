//
//  JXSelectView.m
//  JXView
//
//  Created by dujinxin on 15/11/17.
//  Copyright © 2015年 e-future. All rights reserved.
//

#import "JXSelectView.h"

static CGFloat  systemPickerViewHeight = 216.0;
static CGFloat  topBarHeight           = 40.0;

@interface JXSelectView (){
    UIWindow   *  _bgWindow;
    UIView     *  _bgView;
    UIView     *  _topBarView;
}

@property (nonatomic, strong)UIWindow  * bgWindow;
@property (nonatomic, strong)UIView    * bgView;
@property (nonatomic, strong)UIView    * topBarView;

@end
@implementation JXSelectView

#pragma mark - getter and setter method
-(UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgWindow.windowLevel = UIWindowLevelAlert + 1;
        _bgWindow.backgroundColor = [UIColor clearColor];
        _bgWindow.hidden = NO;
    }
    return _bgWindow;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.tag = kSelectBgViewTag;
        _bgView.alpha = 0.0;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:bgTap];
    }
    return _bgView;
}
-(UIView *)topBarView{
    if (!_topBarView) {
        _topBarView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, self.frame.size.width, topBarHeight)];
        _topBarView.backgroundColor = [UIColor lightTextColor];
    }
    return _topBarView;
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.tag = kSelectButtonTag;
    }
    return _cancelButton;
}
-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_confirmButton.backgroundColor = [UIColor redColor];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.tag = kSelectButtonTag +1;
    }
    return _confirmButton;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setRowHeight:44];
    }
    return _tableView;
}
-(UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc ]init];
        _pickView.backgroundColor = [UIColor lightGrayColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.showsSelectionIndicator = YES;
    }
    return _pickView;
}
-(void)setCustomView:(UIView *)customView{
    _customView = customView;
}
-(void)setUseTopButton:(BOOL)useTopButton{
    _useTopButton = useTopButton;
}
-(void)setSelectRow:(NSInteger)selectRow{
    _selectRow = selectRow;
}
-(void)setSelectViewStyle:(JXSelectViewStyle)selectViewStyle{
    _selectViewStyle = selectViewStyle;
}
-(void)setSelectViewPosition:(JXSelectViewShowPosition)selectViewPosition{
    _selectViewPosition = selectViewPosition;
}

-(instancetype)initWithFrame:(CGRect)frame style:(JXSelectViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, frame.size.width, systemPickerViewHeight + topBarHeight);
        self.backgroundColor = [UIColor whiteColor];
        _dataArray = [NSMutableArray array];
        _selectViewStyle = style;
        _selectRow = 0;
        if (style == JXSelectViewStyleList) {
            [self addSubview:self.tableView];
        }else if (style == JXSelectViewStylePick){
            [self addSubview:self.pickView];
        }
    }
    return self;
}
-(instancetype)initWithCustomView:(UIView *)customView{
    self = [super init];
    if (self) {
        NSAssert(customView, @"customView can not be nil!");
        self.frame = CGRectMake(0, 0, customView.frame.size.width, customView.frame.size.height);
        self.backgroundColor = [UIColor whiteColor];
        _selectViewStyle = JXSelectViewStyleCustom;
        _customView = customView;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_useTopButton) {
        [_topBarView setFrame:CGRectMake(0, 0, self.frame.size.width, topBarHeight)];
        [_cancelButton setFrame:CGRectMake(10, 0, 60, topBarHeight)];
        [_confirmButton setFrame:CGRectMake(self.frame.size.width - 70, 0, 60, topBarHeight)];
        [_tableView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width, self.frame.size.height -topBarHeight)];
        [_pickView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width, self.frame.size.height -topBarHeight)];
        [_customView setFrame:CGRectMake(0, topBarHeight, self.frame.size.width, self.frame.size.height -topBarHeight)];
    }else{
        [_tableView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_pickView setFrame:CGRectMake(0, 0, self.frame.size.width, systemPickerViewHeight)];
        [_customView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    //iPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    //CGSize pickerSize = [iPickerView sizeThatFits:CGSizeZero];
//    if (_selectViewStyle == JXSelectViewStyleList) {
//        <#statements#>
//    }
    
}
#pragma mark -
- (void)confirmButtonEvent:(UIButton *)btn{
    if (btn.tag == kSelectButtonTag) {//取消
        [self willIngDidDisappear:-1];
    }else{//确定
        [self willIngDidDisappear:_selectRow];
    }
    
}
- (void)show{
    [self showInView:nil animate:YES];
}
- (void)showInView:(UIView *)view animate:(BOOL)animated{
    if (_useTopButton) {
        [self addSubview:self.topBarView];
        [self.topBarView addSubview:self.cancelButton];
        [self.topBarView addSubview:self.confirmButton];
    }
    if (_selectViewStyle == JXSelectViewStyleCustom) {
        [self addSubview:_customView];
    }
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentSelectView:)]) {
        [_delegate willPresentSelectView:self];
    }
    //添加背景
    CGPoint center;
    if (view) {
        //动画暂时先不加了。。。
        [view addSubview:self.bgView];
        center = view.center;
        self.center = CGPointMake(center.x, center.y -64/2);
        [view addSubview:self];
        
    }else{
        if (_selectViewPosition == JXSelectViewShowPositionTop) {
            CGRect rect = self.frame;
            rect.origin.y = 0.0 -self.frame.size.height;
            self.frame = rect;
        }else if (_selectViewPosition == JXSelectViewShowPositionBottom){
            CGRect rect = self.frame;
            rect.origin.y = self.bgWindow.frame.size.height;
            self.frame = rect;
        }else{
            self.center = self.bgWindow.center;
        }
        [self.bgWindow addSubview:self.bgView];
        [self.bgWindow addSubview:self];
    }
    if (animated) {
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:0.35f];
//        [animation setType:kCATransitionReveal];
//        [animation setSubtype:kCATransitionFromBottom];
//        [animation setFillMode:kCAFillModeForwards];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//        [self.layer addAnimation:animation forKey:nil];
        
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            //self.transform = CGAffineTransformMakeTranslation(0.8, 0.8);
            //self.transform = CGAffineTransformMakeRotation(0.5);
            
            self.bgView.alpha = 0.5;
            if (_selectViewPosition == JXSelectViewShowPositionTop) {
                CGRect rect = self.frame;
                rect.origin.y = 0.0;
                self.frame = rect;
            }else if (_selectViewPosition == JXSelectViewShowPositionBottom){
                CGRect rect = self.frame;
                rect.origin.y = self.bgWindow.frame.size.height - self.frame.size.height;
                self.frame = rect;
            }else{
                self.center = self.bgWindow.center;
            }
            
            
        } completion:^(BOOL finished) {
            if (_selectViewStyle == JXSelectViewStyleList) {
                [self.tableView reloadData];
            }else if(_selectViewStyle == JXSelectViewStylePick){
                [self.pickView reloadAllComponents];
                if (_selectRow >=0) {
                    [self.pickView selectRow:_selectRow inComponent:0 animated:YES];
                }
            }
        }];
    }
    //已经出现
    if ([_delegate respondsToSelector:@selector(didPresentSelectView:)]) {
        [_delegate didPresentSelectView:self];
    }
}
-(void)willIngDidDisappear:(NSInteger)row{
    //将要
    if ([self.delegate respondsToSelector:@selector(selectView:didSelectRow:)]) {
        //没有选择，直接取消，则不调用
        if (row >= 0) {
            [self.delegate selectView:self didSelectRow:row];
        }
    }
    [self dismiss:YES];
    //已经
}
- (void)dismiss
{
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animated
{
    UIView * bgView = [self.superview viewWithTag:kSelectBgViewTag];
    [bgView removeFromSuperview];
    if (animated) {
        [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (_selectViewPosition == JXSelectViewShowPositionTop) {
                CGRect rect = self.frame;
                rect.origin.y = 0.0 -self.frame.size.height;
                self.frame = rect;
            }else if (_selectViewPosition == JXSelectViewShowPositionBottom){
                CGRect rect = self.frame;
                rect.origin.y = self.bgWindow.frame.size.height;
                self.frame = rect;
            }else{
                self.center = self.bgWindow.center;
            }
            self.bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self clearInfo];
        }];
    }else{
        [self clearInfo];
    }
}
- (void)clearInfo{
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    if (_topBarView) {
        [_topBarView removeAllSubviews];
        [_topBarView removeFromSuperview];
    }
    [self removeFromSuperview];
    if (_bgWindow) {
        _bgWindow.hidden = YES;
        _bgWindow = nil;
    }
}
#pragma mark ----------------- JXSelectViewStyleCustom
#pragma mark ----------------- JXSelectViewStyleList
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(selectView:numberOfRowsInSection:)]) {
        return [self.dataSource selectView:self numberOfRowsInSection:section];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([self.dataSource respondsToSelector:@selector(selectView:contentForRow:section:)]) {
        cell.textLabel.text = [self.dataSource selectView:self contentForRow:indexPath.row section:indexPath.section];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_useTopButton) {
        _selectRow = indexPath.row;
    }else{
        [self willIngDidDisappear:indexPath.row];
    }
    
}
#pragma mark ----------------- JXSelectViewStylePick
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([self.dataSource respondsToSelector:@selector(selectView:numberOfRowsInSection:)]) {
        return [self.dataSource selectView:self numberOfRowsInSection:component];
    }
    return 0;
}
#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([self.dataSource respondsToSelector:@selector(selectView:contentForRow:section:)]) {
        return [self.dataSource selectView:self contentForRow:row section:component];
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_useTopButton) {
        _selectRow = row;
    }else{
        [self willIngDidDisappear:row];
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
