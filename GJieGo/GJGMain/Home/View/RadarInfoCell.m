//
//  GJGRadarInfoCell.m
//  Radar
//
//  Created by liubei on 16/4/21.
//  Copyright © 2016年 ABCoder. All rights reserved.
//

#import "RadarInfoCell.h"
#import "LBRadarM.h"
#import "LBTimeTool.h"
#import "NSString+Extension.h"

@interface RadarInfoCell () {
    
    UIImageView *imgView;
    //    UILabel *imgCountLabel;
    UIButton *lvButton;
    UILabel *titleLabel;
    UILabel *timeLabel;
//    UIImageView *iconView;
    UIView *line;
    UILabel *introLabel;
//    UIView *botLineView;
}

@end

@implementation RadarInfoCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath{
    
    RadarInfoCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[self alloc] initWithFrame:CGRectZero];
    }
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.cornerRadius = 3;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = GJGRGBAColor(255.f, 255.f, 255.f, 0.9);
        
        imgView = [[UIImageView alloc] init];
//        imgView.image = [UIImage imageNamed:@"image_four"];
        imgView.backgroundColor = [UIColor whiteColor];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.and.right.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo((ScreenWidth * 0.237));
        }];
        
//        iconView = [[UIImageView alloc] init]; iconView.image = [UIImage imageNamed:@"114"];
//        iconView.contentMode = UIViewContentModeScaleAspectFit;
//        iconView.layer.cornerRadius = 8.f;
//        iconView.layer.masksToBounds = YES;
//        iconView.layer.shouldRasterize = YES;
//        iconView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        [self.contentView addSubview:iconView];
//        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(imgView.mas_bottom).with.offset(5);
//            make.left.equalTo(self.contentView.mas_left).with.offset(6);
//            make.width.and.height.mas_equalTo(16.f);
//        }];
        
//        imgCountLabel = [[UILabel alloc] init];
//        imgCountLabel.font = [UIFont systemFontOfSize:9];
//        imgCountLabel.textColor = [UIColor whiteColor];
//        imgCountLabel.backgroundColor = GJGRGBAColor(0, 0, 0, 0.7);
//        imgCountLabel.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:imgCountLabel];
//        [imgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.top.and.left.equalTo(self.contentView).with.offset(0);
//        }];
        
        titleLabel = [[UILabel alloc] init];// titleLabel.text = @"陌生旗手";
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textColor = GJGRGB16Color(0x333333);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-4);
            make.top.equalTo(imgView.mas_bottom).with.offset(3);
            make.height.mas_equalTo(@16);
        }];
        
        line = [[UIView alloc] init];
        line.backgroundColor = GJGRGB16Color(0x999999);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).with.offset(6);
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(12);
            make.height.mas_equalTo(0.5);
        }];
        
        
        lvButton = [[UIButton alloc] init];
        [lvButton setEnabled:NO];
        [lvButton setAdjustsImageWhenDisabled:NO];
        [lvButton setBackgroundImage:[UIImage imageNamed:@"lavel_bg"] forState:UIControlStateNormal];
        lvButton.titleLabel.font = [UIFont fontWithName:@"Palatino" size:10];
        [self.contentView addSubview:lvButton];
        lvButton.layer.cornerRadius = 3;
        lvButton.layer.masksToBounds = YES;
        lvButton.layer.shouldRasterize = YES;
        lvButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [lvButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
        [lvButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(6);
            make.bottom.equalTo(line.mas_top).with.offset(-3);
            make.width.mas_equalTo(@16);
            make.height.mas_equalTo(@9);
        }];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.textColor = GJGBLACKCOLOR;
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.bottom.equalTo(line.mas_top).with.offset(-3);
        }];
        
//        botLineView = [[UIView alloc] init];
//        [self.contentView addSubview:botLineView];
//        [botLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.bottom.and.right.equalTo(self.contentView).with.offset(0);
//            make.height.mas_equalTo(3);
//        }];
        
        introLabel = [[UILabel alloc] init];
        introLabel.numberOfLines = 2;
        introLabel.font = [UIFont systemFontOfSize:10];
        introLabel.textColor = GJGRGB16Color(0x999999);
        [self.contentView addSubview:introLabel];
        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.contentView.mas_left).with.offset(6);
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.top.equalTo(line.mas_bottom).with.offset(5);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-3);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (CGSize)lb_getSize{
    return CGSizeMake(ScreenWidth * 0.32, ScreenWidth * 0.464);//ScreenWidth * 0.42);
}


#pragma mark - Setting

- (void)setRadarType:(RadarType)radarType {
    
    _radarType = radarType;
//    if (radarType == RadarTypeIsGuide) {
//        botLineView.backgroundColor = GJGRGB16Color(0x4e8df6);
//    }else if (radarType == RadarTypeIsSharedOrder) {
//        botLineView.backgroundColor = GJGRGB16Color(0xd13a5b);
//    }
}

//UIImageView *imgView;
//UIImageView *iconView;
//UILabel *titleLabel;
//UILabel *introLabel;
- (void)setRadarItem:(LBRadarItemM *)radarItem {
    
    _radarItem = radarItem;
    if ([radarItem.Image hasPrefix:@"http"]) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@300w_1o", radarItem.Image]]
                   placeholderImage:[UIImage imageNamed:@"image_four"]];
    }
//    imgCountLabel.text = [NSString stringWithFormat:@" %d张 ", radarItem.ImgCount];
    [lvButton setTitle:radarItem.Level forState:UIControlStateNormal];
    timeLabel.text = [[LBTimeTool sharedTimeTool] stringWithInteger:radarItem.CreateDate/1000];
    titleLabel.text = radarItem.Name;
    NSString *introNote;
    UIColor *introColor;
    if (radarItem.Type == RadarItemTypeIsSharedOrder) {
        if (radarItem.ActivityName) {
            introNote = radarItem.ActivityName;
            if (introNote.length > 8) {
                introNote = [NSString stringWithFormat:@"#%@..#", [introNote substringWithRange:NSMakeRange(0, 8)]];
            }else {
                introNote = [NSString stringWithFormat:@"#%@#", introNote];
            }
        }else {
            introNote = @"#晒单#";
        }
        introColor = GJGRGB16Color(0x368bff);
    }else if (radarItem.Type == RadarItemTypeIsGuideInfo) {
        introNote = @"#促销#";
        introColor = GJGRGB16Color(0xf31919);
    }
    NSString *showStr = [NSString stringWithFormat:@"%@ %@", introNote, radarItem.Description];
    [showStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:showStr];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:introColor, NSForegroundColorAttributeName, nil];
    [AttributedStr setAttributes:attributeDict range:NSMakeRange(0, introNote.length)];
    [introLabel setAttributedText:AttributedStr];
    
//    CGFloat height = [showStr lb_heightWithFont:introLabel.font width:[RadarInfoCell lb_getSize].width - 12];
//    if (height > 14) {
//        introLabel.numberOfLines = 2;
//        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).with.offset(6);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
//            make.top.equalTo(line.mas_bottom).with.offset(5);
//            make.height.mas_equalTo(@24);
//        }];
//    }else {
//        introLabel.numberOfLines = 1;
//        [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).with.offset(6);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
//            make.top.equalTo(line.mas_bottom).with.offset(5);
//            make.height.mas_equalTo(@12);
//        }];
//    }
}

@end
