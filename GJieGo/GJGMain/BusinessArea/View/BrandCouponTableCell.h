//
//  BrandCouponTableCell.h
//  GJieGo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BrandCouponTableCell : BaseTableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subTitleLabel;
@property (nonatomic, strong)UILabel *couponLabel;
@property (nonatomic, strong)UILabel *ruleLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *getButton;
@end
