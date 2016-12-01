//
//  BusinessAreaTableCell.m
//  GJieGo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BusinessAreaTableCell.h"

@implementation BusinessAreaTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeShopingUI];
    }
    return self;
}

- (void)makeShopingUI{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, ScreenWidth, 60);
    firstButton.backgroundColor = [UIColor greenColor];
//    [centerButton addTarget:self action:@selector(chooseBusinessArea:) forControlEvents:UIControlEventTouchUpInside];
    [firstButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(0, 60, ScreenWidth, 60);
    secondButton.backgroundColor = [UIColor brownColor];
    //    [centerButton addTarget:self action:@selector(chooseBusinessArea:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self addSubview:firstButton];
    [self addSubview:secondButton];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
