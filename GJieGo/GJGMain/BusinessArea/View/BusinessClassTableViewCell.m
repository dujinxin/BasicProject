//
//  BusinessClassTableViewCell.m
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BusinessClassTableViewCell.h"

@implementation BusinessClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.borderView.layer.borderWidth = 1.5;
    self.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tBorderView.layer.borderWidth = 1.5;
    self.tBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.firstClassButton.tag = 11;
    self.secondClassButton.tag = 22;
    
}
- (IBAction)clickButton:(id)sender {
    [self.cellDelegate clickMoreButton:sender];
}

@end
