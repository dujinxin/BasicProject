//
//  JXHorizontalView.m
//  JXView
//
//  Created by dujinxin on 15-5-7.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "JXHorizontalView.h"

@interface JXHorizontalView()<UITableViewDelegate,UITableViewDataSource>
{
    CGSize _size;
}
@end

@implementation JXHorizontalView


-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:JXHorizontalViewDefault];
}
-(instancetype)initWithFrame:(CGRect)frame style:(JXHorizontalViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        if (style) {
            _style = style;
        }else{
            _style = JXHorizontalViewDefault;
        }
        [self initDataWithFrame:frame];
    }
    return self;
}

-(void)initDataWithFrame:(CGRect)frame{
    _size = frame.size;
    self.backgroundColor = [UIColor blueColor];
    
    self.containerView = [[UITableView alloc]initWithFrame:frame];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.showsHorizontalScrollIndicator = NO;
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.bounces = NO;
    self.containerView.pagingEnabled = YES;
    self.containerView.delegate = self;
    self.containerView.dataSource = self;
    self.containerView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    
    [self addSubview:self.containerView];
}
-(UIView *)initSubviewsWithFrame:(CGRect)frame contentView:(UIView *)contentView titles:(NSArray *)titles{
    
    
//    self.contentView = contentView;
    
    return nil;
}

-(void)reloadData{
    _size = self.frame.size;
    self.containerView.frame = CGRectMake(0, 0, _size.width, _size.height);
//    [self.containerView reloadData];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray * array = [NSArray arrayWithObjects:indexPath, nil];
    [self.containerView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(horizontalView:widthForPageAtIndex:)]) {
       return [self.delegate horizontalView:self widthForPageAtIndex:indexPath.row];
    }
    return 0.0f;
}
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(horizontalView:contentView:numberOfPagesInSection:)]) {
        return [self.dataSource horizontalView:self contentView:nil numberOfPagesInSection:section];
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * viewController = nil;
    if (self.style == JXHorizontalViewVariable) {
        viewController = [NSString stringWithFormat:@"vc%ld",(long)indexPath.row];
    }else{
        viewController = @"vc";
    }
    UITableViewCell * vcCell = [tableView dequeueReusableCellWithIdentifier:viewController];
    if (vcCell == nil) {
        vcCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:viewController];
        vcCell.frame = CGRectMake(0, 0, _size.width, _size.height);
        vcCell.contentView.frame = vcCell.bounds;
        
//        if (self.containerArray) {
//            id object = [self.containerArray objectAtIndex:indexPath.row];
//            if ([object isKindOfClass:[UIViewController class]]) {
//                UIViewController * vc = [[UIViewController alloc] init];
//                
//            }else if([object isKindOfClass:[UIView class]]){
//                UIView * view = [self.containerArray objectAtIndex:indexPath.row];
//                view.frame = vcCell.contentView.bounds;
//                view.transform = CGAffineTransformMakeRotation(M_PI/2);
//                view.frame = CGRectMake(0, 0, vcCell.contentView.size.height, vcCell.contentView.size.width);
//                view.tag = 1000;
//                [vcCell.contentView addSubview:view];
//                
//                if ([object isKindOfClass:[UITableView class]]) {
//                    
//                }
//            }
//
//        }
//        if (self.contentView) {
//            UIView * view = [self.containerArray objectAtIndex:indexPath.row];
//            view.frame = vcCell.contentView.bounds;
//            view.transform = CGAffineTransformMakeRotation(M_PI/2);
//            view.frame = CGRectMake(0, 0, vcCell.contentView.size.height, vcCell.contentView.size.width);
//            view.tag = 1000;
//            [vcCell.contentView addSubview:view];
//        }
        
        UIView * contentView = nil;
        if ([self.dataSource respondsToSelector:@selector(horizontalView:contentView:frame:viewForPageAtIndex:)]) {
            contentView = [self.dataSource horizontalView:self contentView:nil  frame:vcCell.contentView.bounds viewForPageAtIndex:indexPath.row];
        }
        if (nil == contentView) {
            contentView = [[UIView alloc]initWithFrame:vcCell.contentView.bounds];
        }
        contentView.frame = vcCell.contentView.bounds;
        contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
        contentView.frame = CGRectMake(0, 0, vcCell.contentView.frame.size.height, vcCell.contentView.frame.size.width);
        contentView.tag = 1000;
        [vcCell.contentView addSubview:contentView];
        vcCell.backgroundColor = [UIColor greenColor];
        
    }
    
    UIView * contentView = [vcCell.contentView viewWithTag:1000];
    if ([self.dataSource respondsToSelector:@selector(horizontalView:contentView:contentForPageAtIndex:)]) {
        [self.dataSource horizontalView:self contentView:contentView contentForPageAtIndex:indexPath.row];
    }
    
    return vcCell;
}


#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.pagingEnabled) {
//        CGFloat pageWidth = scrollView.frame.size.width;
//        int currentPage = floor((scrollView.contentOffset.y - pageWidth/2)/pageWidth)+1;
//        if (self.currentIndex != currentPage) {
//            if ([self.delegate respondsToSelector:@selector(QFTableView:scrollToIndex:)]) {
//                [self.delegate QFTableView:self scrollToIndex:currentPage];
//            }
//            self.currentIndex = currentPage;
//        }
//    }
//    if ([self.delegate respondsToSelector:@selector(scrollToRefreshView)]) {
//        [self.delegate scrollToRefreshView];
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if ([self.delegate respondsToSelector:@selector(QFTableViewDidEndDragging:)]) {
//        [self.delegate QFTableViewDidEndDragging:_tableView];
//    }
//}
@end
