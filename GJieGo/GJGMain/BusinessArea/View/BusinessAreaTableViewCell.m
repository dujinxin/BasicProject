//
//  BusinessAreaTableViewCell.m
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BusinessAreaTableViewCell.h"

@implementation BusinessAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.firstClassButton.tag = 1;
    self.secondClassButton.tag = 2;
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
