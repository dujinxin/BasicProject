//
//  BusinessAreaTableViewCell.h
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//  购物中心cell

#import "BaseTableViewCell.h"

@interface BusinessAreaTableViewCell : BaseTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *className;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *FNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;

@property (strong, nonatomic) IBOutlet UILabel *kNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *kFNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *kAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *kTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *kBackImageView;

@property (strong, nonatomic) IBOutlet UIButton *firstClassButton;
@property (strong, nonatomic) IBOutlet UIButton *secondClassButton;

@end
