//
//  ShopGuideTableViewCell.m
//  Radar
//
//  Created by liubei on 16/4/27.
//  Copyright © 2016年 ABCoder. All rights reserved.
//

#import "ShopGuideTableViewCell.h"
#import "LBGuideInfoM.h"
#import "LBGuideDetailM.h"
#import "GuideHomeViewController.h"
#import "UserHomeViewController.h"
#import "JZAlbumViewController.h"
#import "MapOfMainViewController.h"
#import "UIView+Controller.h"
#import "LBTimeTool.h"
#import <UIImageView+WebCache.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "WebViewController.h"
//#import "AvatarBrowser.h"

@interface ShopGuideTableViewCell () {
    
    int colCount;
    CGFloat imgAndIntroMargin;
    CGFloat outMargin;
    CGFloat insideMargin;
    CGFloat imgWidth;
    
    NSInteger randomCount;
}

@property (weak, nonatomic) IBOutlet UIView *viewHolder;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lvlNameButton;
@property (weak, nonatomic) IBOutlet UIButton *lvlButton;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *msgButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *imgCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBotBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistanceCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistanceCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holderLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holderRightCons;

@property (nonatomic, strong) NSMutableArray *imgs;

@end

@implementation ShopGuideTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    colCount = 3;
    imgAndIntroMargin = 19.f;
    outMargin = 10.f;
    insideMargin = 8.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    _imgs = [NSMutableArray array];
    _lineCons.constant = 0.5;
    
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoClick:)];
    [_iconView addGestureRecognizer:iconTap];
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoClick:)];
    [_nameLabel addGestureRecognizer:nameTap];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    for (int i = 0; i < 9; i++) {
        UIImageView *img = [[UIImageView alloc] init];// [img setBackgroundColor:[UIColor blueColor]];
        img.tag = 233 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapThisImageView:)];
        [img addGestureRecognizer:tap];
        [img setUserInteractionEnabled:YES];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img setClipsToBounds:YES];
        [_imgs addObject:img];
    }
}

- (void)setType:(ShopGuideCellType)type {
    
    _type = type;
    
    self.iconView.hidden = NO;
    self.nameLabel.hidden = NO;
    self.timeLabel.hidden = NO;
    self.rightBotBtn.hidden = YES;
    self.lvlButton.hidden = NO;
    self.lvlNameButton.hidden = NO;
    self.locationButton.hidden = NO;
    self.imgCountLabel.hidden = NO;
    self.viewButton.hidden = YES;
    
    self.holderLeftCons.constant = 0;
    self.holderRightCons.constant = 0;
    self.topDistanceCons.constant = 60;
    
    if (_type == ShopGuideCellTypeIsMain) {
        
        self.locationButton.hidden = NO;
        self.msgButton.hidden = YES;
        self.viewButton.hidden = NO;
        self.holderLeftCons.constant = 10;
        self.holderRightCons.constant = 10;
    }else if (_type == ShopGuideCellTypeIsDetail) {
        self.rightBotBtn.hidden = YES;
        self.imgCountLabel.hidden = YES;
        [self.locationButton addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else if (_type == ShopGuideCellTypeIsInBusinessArea) {
        self.imgCountLabel.hidden = YES;
        self.msgButton.hidden = YES;
        self.viewButton.hidden = NO;
        
    }else if (_type == ShopGuideCellTypeIsGuideHome) {
        
        self.iconView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.timeLabel.hidden = YES;
        self.rightBotBtn.hidden = NO;
        self.lvlButton.hidden = YES;
        self.lvlNameButton.hidden = YES;
        self.locationButton.hidden = YES;
        self.viewButton.hidden = NO;
        self.topDistanceCons.constant = 10;
    }else if (_type == ShopGuideCellTypeIsSharedOrderDetail) {
        
        self.locationButton.hidden = YES;
        self.imgCountLabel.hidden = YES;
    }else if (_type == ShopGuideCellTypeIsInMy) {
        
        self.viewButton.hidden = NO;
        self.locationButton.hidden = YES;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (type == ShopGuideCellTypeIsMain) {
        width -= 20;
    }
    imgWidth = (width - outMargin * 2 - insideMargin * (colCount - 1)) / colCount;
}

- (void)setGuideInfo:(LBGuideInfoM *)guideInfo {
    
    _guideInfo = guideInfo;
    
    LBGuideDetailM *guider = guideInfo.guider;
    // <2.1> name
    if (guider.ShopName) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@-%@", guider.UserName, guider.ShopName];
    }else {
        self.nameLabel.text = guider.UserName;
    }
    // <2.2> icon
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@120w_1o", guider.HeadPortrait]]
                     placeholderImage:[UIImage imageNamed:@"image_four"]
                            completed:nil];
    // <2.3> time
//    NSLog(@"服务器获得时间str:%@, 转化成doubleValue:%lf", guideInfo.CreateTime, guideInfo.CreateTime.doubleValue);
    self.timeLabel.text = [[LBTimeTool sharedTimeTool] stringWithInteger:guideInfo.CreateTime.doubleValue/1000];
    self.rightBotBtn.text = [[LBTimeTool sharedTimeTool] stringWithInteger:guideInfo.CreateTime.doubleValue/1000];
    // <2.4> lv & lv Name
    [self.lvlButton setTitle:[NSString stringWithFormat:@"V%lu", guider.UserLevel] forState:UIControlStateNormal];
//    [self.lvlNameButton setTitle:guider.UserLevelName forState:UIControlStateNormal];
    // <2.5> intro
    if (self.type == ShopGuideCellTypeIsDetail) {
        self.introLabel.text = guideInfo.Content;
    }else if (self.type == ShopGuideCellTypeIsSharedOrderDetail) {
        if (guideInfo.activityM) {
            // 点击富文本
            [self.introLabel sizeToFit];
            NSDictionary* tapDic = @{@"tap" : [WPAttributedStyleAction styledActionWithAction:^
                                               {[self activityClick];}],
                                     @"color": GJGRGB16Color(0x368bff)};
            self.introLabel.attributedText = [[NSString stringWithFormat:@"<color><tap>#%@#</tap></color> %@\n", guideInfo.activityM.ActivityName, guideInfo.Content] attributedStringWithStyleBook:tapDic];
        }else {
            self.introLabel.text = guideInfo.Content;
        }
    }else {
        NSString *contentStr = guideInfo.Content;
        BOOL needHidden = NO;
        if (guideInfo.Content.length > 48) {
            needHidden = YES;
            contentStr = [contentStr substringWithRange:NSMakeRange(0, 48)];
        }
        
        int spaceCount = 0;
        int secSpaceLoc = 0;
        for (int i = 0; i<contentStr.length; i++) {
            NSRange range = NSMakeRange(i, 1);
            NSString *temp = [contentStr substringWithRange:range];
            if ([temp isEqualToString:@"\n"]) {
                spaceCount ++;
                if (spaceCount == 2) {
                    secSpaceLoc = i;
                }
            }
        }
        if (spaceCount > 1) {
            needHidden = YES;
            contentStr = [contentStr substringToIndex:secSpaceLoc];
        }
        self.introLabel.text = [NSString stringWithFormat:@"%@%@", contentStr, needHidden ? @"..." : @""];
    }
    // <2.6> like & comment
    [self.loveButton setTitle:[NSString stringWithFormat:@"%lu", guideInfo.LikeNum >= 0 ? guideInfo.LikeNum : 0] forState:UIControlStateNormal];
    [self.msgButton setTitle:[NSString stringWithFormat:@"%lu", guideInfo.CommentNum >= 0 ? guideInfo.CommentNum : 0] forState:UIControlStateNormal];
    [self.viewButton setTitle:[NSString stringWithFormat:@"%lu", guideInfo.ViewNum >= 0 ? guideInfo.ViewNum : 0] forState:UIControlStateNormal];
    // <2.7> location
    [self.locationButton setTitle:[NSString stringWithFormat:@"%@", guideInfo.Distance] forState:UIControlStateNormal];
    
    // <1> 布局 clear
    [_imgs makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imgs makeObjectsPerformSelector:@selector(setImage:) withObject:nil];
    
    if (self.type == ShopGuideCellTypeIsSharedOrderDetail){
        
        _bottomDistanceCons.constant = 0;
        return;
    }

    NSInteger imgCount = guideInfo.imgUrls.count;
    NSInteger maxCount = imgCount;
    if (imgCount > colCount && self.type != ShopGuideCellTypeIsDetail && self.type != ShopGuideCellTypeIsInBusinessArea) {
        maxCount = colCount;
    }
    for (int i = 0; i < maxCount; i++) {
//        UIImage *img = [UIImage imageNamed:@"login_bg"];// 图片
        UIImageView *imgView = _imgs[i];
//        [imgView setImage:img];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@200w_1o", guideInfo.imgUrls[i]]]
                   placeholderImage:[UIImage imageNamed:@"default_portrait_less"]
                          completed:nil];
        [_viewHolder addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewHolder.mas_left).with.offset(outMargin + (imgWidth + insideMargin) * (i % 3));
            make.top.equalTo(_introLabel.mas_bottom).with.offset(imgAndIntroMargin + (imgWidth + insideMargin) * (i / 3));
            make.width.and.height.mas_equalTo([NSNumber numberWithDouble:imgWidth]);
        }];
    }

    if (imgCount > 0) {
        self.imgCountLabel.text = [NSString stringWithFormat:@"共%lu张", imgCount];
        if (imgCount < 4) {
            self.imgCountLabel.hidden = YES;
        }
        [self.viewHolder bringSubviewToFront:self.imgCountLabel];
        if (self.type == ShopGuideCellTypeIsDetail || self.type == ShopGuideCellTypeIsInBusinessArea) {
            int rowCount = (((int)(imgCount-1)/3) + 1);
            _bottomDistanceCons.constant = 19 + 10 + imgWidth *rowCount + insideMargin * (rowCount-1);
        }else {
            _bottomDistanceCons.constant = 19 + 10 + imgWidth;
        }
    }else {
        _bottomDistanceCons.constant = 19;
        self.imgCountLabel.hidden = YES;
    }
}


/*
 *  @pragma 填充模拟数据方法
 */
- (void)setSomeOne:(NSInteger)imgCount {
//    
//    // clear
//    [_imgs makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [_imgs makeObjectsPerformSelector:@selector(setImage:) withObject:nil];
//    
//    if (self.type == ShopGuideCellTypeIsSharedOrderDetail){
//        
//        _bottomDistanceCons.constant = 19;
//        return;
//    }
//    
//    //  弄数据
//    randomCount = imgCount;//arc4random_uniform(8);
//#warning 这里一定要判断好图片用不用多加载
//    
//    //    if (randomCount > 0) {// 如果有图片，那么计算约束高度
//    //        //  右下角 共几张.hidden = NO;
//    //        //  右下角 共几张.text = 共x张;
//    //        self.bottomDistanceCons.constant = 19 + 10 + imgWidth;
//    //
//    //        switch (self.type) {
//    //
//    //            case ShopGuideCellTypeIsMain:
//    //                break;
//    //            case ShopGuideCellTypeIsDetail:
//    //                break;
//    //            case ShopGuideCellTypeIsGuiderHome: {
//    //                //  右下角 共几张.hidden = YES;
//    //                int rowCount = (((int)(randomCount-1)/3) + 1);
//    //                self.bottomDistanceCons.constant = 19 + 10 + imgWidth *rowCount + insideMargin * (rowCount-1);
//    //            }
//    //                break;
//    //
//    //            default:
//    //                break;
//    //        }
//    //    }else { // 如果没有，那么默认高
//    //        _bottomDistanceCons.constant = 19;
//    //    }
//    
//    //    imgWidth = (_viewHolder.frame.size.width - outMargin * 2 - insideMargin * (colCount - 1)) / colCount;
//    
//    NSInteger maxCount = randomCount;
//    if (randomCount > colCount && self.type != ShopGuideCellTypeIsDetail) {
//        maxCount = colCount;
//    }
//    for (int i = 0; i < maxCount; i++) {
//        UIImage *img = [UIImage imageNamed:@"login_bg"];// 图片
//        UIImageView *imgView = _imgs[i];
//        [imgView setImage:img];
//        [_viewHolder addSubview:imgView];
//        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_viewHolder.mas_left).with.offset(outMargin + (imgWidth + insideMargin) * (i % 3));
//            make.top.equalTo(_introLabel.mas_bottom).with.offset(imgAndIntroMargin + (imgWidth + insideMargin) * (i / 3));
//            make.width.and.height.mas_equalTo([NSNumber numberWithDouble:imgWidth]);
//        }];
//    }
//    
//    if (randomCount > 0) {
//        
//        self.imgCountLabel.text = [NSString stringWithFormat:@"共%lu张", randomCount];
//        [self.viewHolder bringSubviewToFront:self.imgCountLabel];
//        
//        if (self.type == ShopGuideCellTypeIsDetail) {
//            int rowCount = (((int)(randomCount-1)/3) + 1);
//            _bottomDistanceCons.constant = 19 + 10 + imgWidth *rowCount + insideMargin * (rowCount-1);
//        }else {
//            _bottomDistanceCons.constant = 19 + 10 + imgWidth;
//        }
//    }else {
//        _bottomDistanceCons.constant = 19;
//        self.imgCountLabel.hidden =YES;
//    }
}

#pragma mark - Button click event

- (void)userInfoClick:(id)sender {
    
    UIViewController *superVC = [self.superview.superview viewController];
    
    if (self.type == ShopGuideCellTypeIsSharedOrderDetail) {
        UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
        userHomeVC.userId = self.guideInfo.guider.UserId;   // 这里用的数据模型是导购模型, 但内部已经被封装成用户模型.u
        [superVC.navigationController pushViewController:userHomeVC animated:YES];
    }else {
        GuideHomeViewController *guiderHomeVC = [[GuideHomeViewController alloc] init];
        guiderHomeVC.gid = self.guideInfo.guider.UserId;
        guiderHomeVC.statisticChatOfHome = self.guideInfo.statisticChat.length > 0 ? self.guideInfo.statisticChat : ID_0201030180013;
        [superVC.navigationController pushViewController:guiderHomeVC animated:YES];
    }
}

- (void)locationBtnClick:(UIButton *)sender {
    
    MapOfMainViewController *mapVC = [[MapOfMainViewController alloc] init];
//    mapVC.shopId = self.guideInfo.guider.ShopId;
    mapVC.shopName = self.guideInfo.guider.ShopName;
    mapVC.shopAddress = self.guideInfo.guider.ShopAddr;
    mapVC.shopLocation = [[CLLocation alloc] initWithLatitude:self.guideInfo.latitude longitude:self.guideInfo.longitude];
//    mapVC.shopLocation = [[CLLocation alloc] initWithLatitude:39.85 longitude:116.36];
    [[self navigationViewController] pushViewController:mapVC animated:YES];
}

- (void)tapThisImageView:(UITapGestureRecognizer *)tap {
    
    JZAlbumViewController *imgVC = [[JZAlbumViewController alloc] init];
    imgVC.currentIndex = tap.view.tag - 233;
    imgVC.imgArr = self.guideInfo.imgUrls;
    [[self.superview.superview viewController] presentViewController:imgVC animated:YES completion:nil];
}

- (void)activityClick {
    WebViewController *acVc = [[WebViewController alloc] init];
    acVc.webUrl = self.guideInfo.activityM.ActivityUrl;
    [[self navigationViewController] pushViewController:acVc animated:YES];
}


#pragma mark - func

- (UINavigationController *)navigationViewController {
    
//    static UINavigationController *_instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        _instance = [self.superview.superview viewController].navigationController;
//    });
    UINavigationController *_instance = [self.superview.superview viewController].navigationController;
    return _instance;
}

@end
