//
//  ShopActivityListCell.h
//  GJieGo
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ShopActivityListCell : BaseTableViewCell

@property (nonatomic, strong)UIImageView *activityImage;
@property (nonatomic, strong)UILabel *activityName;
@property (nonatomic, strong)UILabel *activityTime;
@property (nonatomic, strong)UILabel *activityStow;
@end
