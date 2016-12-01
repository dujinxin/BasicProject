//
//  DetailMsgTableViewCell.m
//  GJieGo
//
//  Created by liubei on 16/4/28.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "DetailMsgTableViewCell.h"
#import "LBMsgM.h"
#import "LBUserM.h"
#import "AppMacro.h"
#import "LBTimeTool.h"
#import "UIView+Controller.h"
#import "GuideHomeViewController.h"
#import "UserHomeViewController.h"

@interface DetailMsgTableViewCell () {
    UIImageView *iconView;
    UIButton *lvButton;
    UILabel *timeLabel;
    UIButton *nameButton;
//    UIButton *beCalledButton;
//    UILabel *answerLabel;
    UILabel *msgLabel;
    
    UIView *bottomLineView;
}

@end

@implementation DetailMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        iconView = [[UIImageView alloc] init]; iconView.image = [UIImage imageNamed:@"image_four"];
        iconView.layer.cornerRadius = 20;
        iconView.layer.masksToBounds = YES;
        iconView.layer.shouldRasterize = YES;
        iconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self.contentView addSubview:iconView];
        iconView.userInteractionEnabled = YES;
        [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)]];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.and.height.mas_equalTo(@40);
        }];
        
        nameButton = [[UIButton alloc] init];   [nameButton setTitle:@" " forState:UIControlStateNormal];
        [nameButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [nameButton setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:nameButton];
        [nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(iconView.mas_right).with.offset(9);
            make.height.mas_equalTo(@20);
        }];
        
        lvButton = [[UIButton alloc] init];
        [lvButton setEnabled:NO];
        [lvButton setAdjustsImageWhenDisabled:NO];
        lvButton.layer.cornerRadius = 3;
        lvButton.layer.masksToBounds = YES;
        UIFont *lvFont = [UIFont fontWithName:@"Palatino-Bold" size:10];
        [lvButton setBackgroundImage:[UIImage imageNamed:@"lavel_bg"] forState:UIControlStateNormal];
        lvButton.titleLabel.font = lvFont;//[UIFont fontWithName:@"Palatino" size:10];
        [self.contentView addSubview:lvButton];
        [lvButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
        [lvButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameButton.centerY).with.offset(0);
            make.left.equalTo(nameButton.mas_right).with.offset(3);
            make.height.mas_equalTo(@12);
        }];
        
        timeLabel = [[UILabel alloc] init];     timeLabel.text = @" ";
        [timeLabel setFont:[UIFont systemFontOfSize:11]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setTextColor:COLOR(187, 187, 187, 1)];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.height.mas_equalTo(@16);
        }];
        
        msgLabel = [[UILabel alloc] init];  msgLabel.text = @" ";
        [msgLabel setTextColor:COLOR(51, 51, 51, 1)];
        [msgLabel setNumberOfLines:0];
        [msgLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:msgLabel];
        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).with.offset(9);
            make.right.equalTo(self.contentView.mas_right).with.offset(-60);
            make.top.equalTo(iconView.mas_bottom).with.offset(-15);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
        bottomLineView = [[UIView alloc] init];
        [bottomLineView setBackgroundColor:GJGRGB16Color(0xdadada)];
        [self.contentView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView).with.offset(0);
            make.bottom.equalTo(self.contentView).with.offset(-0.5);
            make.height.mas_equalTo(@0.5);
        }];
        
//        answerLabel = [[UILabel alloc] init]; answerLabel.text = @"回复";
//        [answerLabel setFont:[UIFont systemFontOfSize:13]];
//        [answerLabel setTextColor:COLOR(187, 187, 187, 1)];
//        [answerLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.contentView addSubview:answerLabel];
//        [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(nameButton.mas_right).with.offset(0);
//            make.top.equalTo(self.contentView.mas_top).with.offset(10);
//            make.height.mas_equalTo(@20);
//            make.width.mas_equalTo(@30);
//        }];
//        
//        beCalledButton = [[UIButton alloc] init];   [beCalledButton setTitle:@" " forState:UIControlStateNormal];//被回复的那个
//        [beCalledButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [beCalledButton setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
//        [self.contentView addSubview:beCalledButton];
//        [beCalledButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).with.offset(10);
//            make.left.equalTo(answerLabel.mas_right).with.offset(0);
//            make.height.mas_equalTo(@20);
//        }];
    }
    return self;
}

- (void)setMsg:(LBMsgM *)msg {
    
    _msg = msg;
    LBUserM *commentUser = msg.user;
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@90w_1o", commentUser.HeadPortrait]]
                placeholderImage:[UIImage imageNamed:@"image_four"]
                       completed:nil];
    [nameButton setTitle:commentUser.UserName forState:UIControlStateNormal];
    [lvButton setTitle:[NSString stringWithFormat:@"V%lu", commentUser.UserLevel] forState:UIControlStateNormal];
//    if (msg.BeRepliedUserId == 0) {
////        answerLabel.hidden = YES;
////        beCalledButton.hidden = YES;
//    }else {
////        answerLabel.hidden = NO;
////        beCalledButton.hidden = NO;
////        [beCalledButton setTitle:msg.BeRepliedUserName forState:UIControlStateNormal];
    //    }
    if (msg.CreateTimeOld) {
        timeLabel.text = msg.CreateTimeOld;
    }else {
        timeLabel.text = [[LBTimeTool sharedTimeTool] stringWithInteger:[msg.CreateTime doubleValue]/1000];
        msg.CreateTimeOld = timeLabel.text;
    }
    NSString *content;
    if (msg.BeRepliedUserId == 0) {
        content = msg.Content;
    }else {
        content = [NSString stringWithFormat:@"回复 %@: %@", msg.BeRepliedUserName, msg.Content];
    }
    msgLabel.text = content;//[msg.Content stringByRemovingPercentEncoding];
}

- (void)iconClick {
    UIViewController *superVC = [self.superview.superview viewController];
    
    if (self.msg.user.UserType == 1) {// 用户
        UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
        userHomeVC.userId = self.msg.user.UserId;
        [superVC.navigationController pushViewController:userHomeVC animated:YES];
    }else if (self.msg.user.UserType == 2) {    // 导购
        GuideHomeViewController *guiderHomeVC = [[GuideHomeViewController alloc] init];
        guiderHomeVC.gid = self.msg.user.UserId;
        [superVC.navigationController pushViewController:guiderHomeVC animated:YES];
    }
}

- (UINavigationController *)navigationViewController {
    
    static UINavigationController *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self.superview.superview viewController].navigationController;
    });
    return _instance;
}

@end
