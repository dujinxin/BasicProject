//
//  ShareActivityTableViewCell.m
//  GJieGo
//
//  Created by liubei on 2016/11/15.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShareActivityTableViewCell.h"

@interface ShareActivityTableViewCell () {
    
    UILabel *activityTitle;
    UILabel *timeLabel;
    UIView *botLine;
}

@end

@implementation ShareActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        activityTitle = [[UILabel alloc] init];
        [activityTitle setFont:[UIFont systemFontOfSize:14]];
        [activityTitle setTextAlignment:NSTextAlignmentLeft];
        [activityTitle setTextColor:GJGRGB16Color(0x333333)];
        [self.contentView addSubview:activityTitle];
        [activityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).with.offset(@10);
            make.left.equalTo(self.contentView.mas_left).with.offset(@15);
            make.right.equalTo(self.contentView.mas_right).with.offset(@(-15));
        }];
        
        timeLabel = [[UILabel alloc] init];
        [timeLabel setFont:[UIFont systemFontOfSize:11]];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTextColor:GJGRGB16Color(0x999999)];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(activityTitle.mas_bottom).with.offset(@10);
            make.left.equalTo(self.contentView.mas_left).with.offset(@15);
            make.right.equalTo(self.contentView.mas_right).with.offset(@(-15));
        }];
        
        botLine = [[UIView alloc] init];
        botLine.backgroundColor = GJGRGB16Color(0xd2d2d2);
        [self.contentView addSubview:botLine];
        [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setModel:(ShareActivityModel *)model {
    _model = model;
    
    activityTitle.text = model.ActivityName;
    timeLabel.text = model.AvailableDate;
}

@end
