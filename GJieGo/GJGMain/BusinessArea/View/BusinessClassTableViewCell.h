//
//  BusinessClassTableViewCell.h
//  GJieGo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol businessClassTableViewCellDelegate <NSObject>

- (void)clickMoreButton:(UIButton *)button;

@end

@interface BusinessClassTableViewCell : BaseTableViewCell
@property (assign, nonatomic) id<businessClassTableViewCellDelegate> cellDelegate;
@property (strong, nonatomic) IBOutlet UILabel *className;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *FNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;

@property (strong, nonatomic) IBOutlet UILabel *kNameLabel;
//@property (strong, nonatomic) IBOutlet UILabel *kFNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *kAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *kTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *kBackImageView;

@property (strong, nonatomic) IBOutlet UIButton *firstClassButton;
@property (strong, nonatomic) IBOutlet UIButton *secondClassButton;
@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UIView *tBorderView;

@end
