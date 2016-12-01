//
//  BaseTableViewCell.h
//  GJieGo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppMacro.h"

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView;

- (void)configureDataForCellWithModel:(id)model;

+ (CGFloat)rowHeightForCellWithModel:(id)model;

@end
