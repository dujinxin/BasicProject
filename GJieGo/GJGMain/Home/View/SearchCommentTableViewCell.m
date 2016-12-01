//
//  SearchCommentTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SearchCommentTableViewCell.h"
#import "AppMacro.h"

@interface SearchCommentTableViewCell () <UIScrollViewDelegate> {
    
    UIScrollView *scrollView;
    UIPageControl *page;
}

@end

@implementation SearchCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.bottom.and.right.equalTo(self.contentView).with.offset(0);
        }];
        
        page = [[UIPageControl alloc] init];
        page.pageIndicatorTintColor = COLOR(153, 153, 153, 1);
        page.currentPageIndicatorTintColor = COLOR(254, 227, 28, 1);
        [self.contentView addSubview:page];
        [page mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
            make.centerX.equalTo(self.contentView.mas_centerX).with.offset(0);
            make.height.equalTo(@22);
        }];
    }
    return self;
}


#pragma mark - Set

- (void)setItems:(NSMutableArray<SearchOftenM *> *)items {
//    
//    if (_items == items) {
//        return;
//    }
    _items = items;
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    static NSInteger row = 2;
    static NSInteger col = 4;
    
    CGFloat holderW = ScreenWidth * 0.232;
    CGFloat holderH = ScreenWidth * 0.232;
    CGFloat holderMag = (ScreenWidth - holderW * col) / (col - 1);
//    CGFloat midMargin = 9.f;
//    CGFloat labelH = 15.f;
    
//    CGFloat itemW = holderW;
//    CGFloat itemH = holderW + midMargin + labelH;
//    
//    CGFloat itemTopMargin = 15.f;
//    CGFloat itemOutMag = 15.f;
//    CGFloat itemHorMargin = (ScreenWidth - itemTopMargin * 2 - itemW * col) / (col - 1);
//    CGFloat itemVerMargin = 23.f;
//    
    for (int i = 0 ; i < items.count; i ++) {
        
        SearchOftenM *often = items[i];
        
        UIView *holder = [[UIView alloc] init];
        holder.tag = i + 772;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
        holder.userInteractionEnabled = YES;
        [holder addGestureRecognizer:tap];
        holder.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.layer.cornerRadius = 22.f;
        iconView.layer.masksToBounds = YES;
//        NSLog(@"search_item_img: %@", often.DicExt);
        [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@132w_1o", often.DicExt]]
                    placeholderImage:[UIImage imageNamed:@"image_four"]];
        [holder addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.and.height.mas_equalTo(@44);
            make.centerX.equalTo(holder.mas_centerX).with.offset(0);
            make.centerY.equalTo(holder.mas_centerY).with.offset(-4);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = COLOR(51, 51, 51, 1);
        nameLabel.textAlignment = NSTextAlignmentCenter;//    nameLabel.backgroundColor = [UIColor redColor];
        nameLabel.text = often.DicName;//NSLog(@"nameLabel:%@", nameLabel.text);
        [holder addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.equalTo(holder).with.offset(0);
            make.top.equalTo(iconView.mas_bottom).with.offset(0);
            make.bottom.equalTo(holder.mas_bottom).with.offset(0);
        }];
        
        [scrollView addSubview:holder];
        CGFloat itemX = ScreenWidth * ( i / (row * col)) + (holderW + holderMag) * (i % col);
        CGFloat itemY = ((i % (row * col)) / col) * holderH;
        [holder mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(scrollView).with.offset(itemX);
            make.top.equalTo(scrollView).with.offset(itemY);
            make.width.mas_equalTo(holderW);
            make.height.mas_equalTo(holderH);
        }];
    }
//    NSInteger currentRow = (items.count > col ? row : 1);
    NSInteger pageNum = (items.count > 0 ? ((items.count -1)/(row * col) + 1) : 1);
    CGFloat contentW = ScreenWidth * pageNum;
    CGFloat contentH = scrollView.frame.size.height;// itemTopMargin + itemVerMargin * (currentRow - 1)  + itemH * currentRow;
    scrollView.contentSize = CGSizeMake(contentW, contentH);
    
    page.numberOfPages = pageNum;
    [scrollView setContentOffset:CGPointZero];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self calculateNumOfPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self calculateNumOfPage];
}

- (void)calculateNumOfPage {
    
    page.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.size.width);
}


#pragma mark - Getting

+ (CGFloat)lb_rowHeight {
    
    return ScreenWidth * 0.541f;
}

- (void)itemClick:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(searchCommentTableViewCellDidSelected:)]) {
        [self.delegate searchCommentTableViewCellDidSelected:(tap.view.tag - 772)];
    }
}

@end


@implementation SearchOftenM

- (NSString *)DicExt {
    
    if (_DicExt == nil) {
        _DicExt = @"";
    }
    return _DicExt;
}

- (NSDictionary *)backToDict {
    
    return @{@"DicExt" : self.DicExt ? self.DicExt : @" ",
             @"DicID" : self.DicID ? [NSNumber numberWithInteger:self.DicID] : @0,
             @"DicName" : self.DicName ? self.DicName : @"",
             @"DicKey" : self.DicKey ? self.DicKey : @""};
}

@end