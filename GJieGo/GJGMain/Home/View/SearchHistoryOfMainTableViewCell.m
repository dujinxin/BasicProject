//
//  SearchHistoryOfMainTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SearchHistoryOfMainTableViewCell.h"
#import "AppMacro.h"

@interface SearchHistoryOfMainTableViewCell () {
    
    UILabel *historyLabel;
}

@end

@implementation SearchHistoryOfMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        historyLabel = [[UILabel alloc] init];
        [historyLabel setFont:[UIFont systemFontOfSize:13]];
        [historyLabel setTextColor:COLOR(51, 51, 51, 1)];
        [self.contentView addSubview:historyLabel];
        [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.left).with.offset(15);
            make.top.equalTo(self.contentView.top).with.offset(10);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

@end
