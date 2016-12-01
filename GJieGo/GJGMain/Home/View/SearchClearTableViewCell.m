//
//  SearchClearTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "SearchClearTableViewCell.h"
#import "AppMacro.h"

@implementation SearchClearTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearBtn setUserInteractionEnabled:NO];
        [clearBtn setBackgroundColor:[UIColor whiteColor]];
        [clearBtn setImage:[[UIImage imageNamed:@"search_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [clearBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
        [clearBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [clearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
        [clearBtn setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.bottom.and.right.equalTo(self.contentView).with.offset(0);
        }];
    }
    return self;
}

@end
