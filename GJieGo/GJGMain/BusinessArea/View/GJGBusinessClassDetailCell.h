//
//  GJGBusinessClassDetailCell.h
//  GJieGo
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 商品分类详情cell ---

#import "BaseTableViewCell.h"

@interface GJGBusinessClassDetailCell : BaseTableViewCell
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UILabel *floorAddressLabel;
@property (nonatomic, strong)UILabel *strowLabel;
@property (nonatomic, strong)UILabel *distanceLabel;
@end
