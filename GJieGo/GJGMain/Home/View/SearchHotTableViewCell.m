//
//  SearchHotTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SearchHotTableViewCell.h"
#import "AppMacro.h"
#import "NSString+Extension.h"

@interface SearchHotTableViewCell () {
    
    
}

@end

@implementation SearchHotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setHots:(NSArray *)hots {
    
//    if (_hots.count == hots.count)
//        return;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _hots = hots;
    
    NSInteger row = 0;
    UIButton *lastBtn = nil;
    
    for (int i = 0; i < hots.count; i++) {
        
        NSString *title = hots[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)    lastBtn = btn;
        [btn setBackgroundColor:[UIColor whiteColor]];
        UIImage *bgImg = [UIImage imageNamed:@"search_lebalbox"];
        bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width * 0.5 topCapHeight:bgImg.size.height * 0.5];
        [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
        [btn setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];

        CGFloat btnW = [title lb_widthWithFont:[UIFont systemFontOfSize:12]] + 30;
        CGFloat btnH = 25;
        CGFloat btnX = CGRectGetMaxX(lastBtn.frame) + 12;
        if ((btnX + btnW) > ScreenWidth) {
            btnX = 12;
            if (i != 0)
                row ++;
        }
        CGFloat btnY = 15 + (btnH + 14) * row;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [self.contentView addSubview:btn];
        
        lastBtn = btn;
    }
    CGFloat cellHeight = (row + 1) * 25 + 14 * row + 30;
    self.lb_rowHeight = cellHeight;
}

- (void)btnClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(searchHotTableViewCellDidSelected:)]) {
        [self.delegate searchHotTableViewCellDidSelected:[button titleForState:UIControlStateNormal]];
    }
}

@end
