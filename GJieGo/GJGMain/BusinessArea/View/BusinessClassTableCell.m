//
//  BusinessClassTableCell.m
//  GJieGo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BusinessClassTableCell.h"
#define btnX ScreenWidth/4
#define btnY 100/2
@implementation BusinessClassTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeBusinessClassUI];
    }
    return self;
}

- (void)makeBusinessClassUI{
    for (int i = 0; i < 8; i++) {
        int j = i % 4;
        int k = i / 4;
        self.classButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.classButton.frame = CGRectMake(j * btnX, k * btnY, btnX, btnY);
        self.classButton.backgroundColor = [UIColor greenColor];
        //    [centerButton addTarget:self action:@selector(chooseBusinessArea:) forControlEvents:UIControlEventTouchUpInside];
        self.classButton.tag = 1000 + i;
        [self.classButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [self.classButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self addSubview:self.classButton];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
