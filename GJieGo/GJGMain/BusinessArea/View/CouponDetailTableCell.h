//
//  CouponDetailTableCell.h
//  GJieGo
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CouponDetailTableCell : BaseTableViewCell
@property (nonatomic, strong)UIImageView *CouponImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UILabel *distanceLabel;
@property (nonatomic, strong)UILabel *ruleLabel;
@property (nonatomic, strong)UIButton *distanceButton;
@end
