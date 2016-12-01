//
//  RecordViewCell.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "RecordViewCell.h"

//static CGFloat imageViewWHPercent = 168/184;//图片宽高比

@implementation RecordViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
        _type = RecordDistributionType;
        [self addSubview:self.topContentView];
        [self addSubview:self.centerContentView];
        [self addSubview:self.bottomContentView];
        
        [self.topContentView addSubview:self.bigImageView];
        
        [self.centerContentView addSubview:self.guiderImageView];
        [self.centerContentView addSubview:self.guiderLabel];
        [self.centerContentView addSubview:self.infoLabel];
        
        [self.bottomContentView addSubview:self.commentButton];
        [self.bottomContentView addSubview:self.priseButton];
        
//        [self.bottomContentView addSubview:self.leftImageView];
//        [self.bottomContentView addSubview:self.leftNumLabel];
//        [self.bottomContentView addSubview:self.rightImageView];
//        [self.bottomContentView addSubview:self.rightNumLabel];
        
        [self autoLayoutSubViews];
        
    }
    return self;
}
- (void)setRecordCellInfo:(id)entity indexPath:(NSIndexPath *)indexPath{
    RecordEntity * recordEntity = (RecordEntity *)entity;
    NSArray * imageArray = [recordEntity.Img componentsSeparatedByString:@","];
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dw_1o",imageArray.firstObject,(int)((kScreenWidth -40)/2)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
    
//    _leftImageView.image = JXImageNamed(@"my_content_icon_comments_gray_disabled");
//    _rightImageView.image = JXImageNamed(@"thumbup_default");
//    _leftNumLabel.text = recordEntity.Comment;
//    _rightNumLabel.text = recordEntity.Like;
    
    //0xf31919
    if (recordEntity.ActivityInfo && [recordEntity.ActivityInfo isKindOfClass:[NSDictionary class]]) {
        NSString * activityName = recordEntity.ActivityInfo[@"ActivityName"];
        NSString * activityStr = @"";
        NSString * allStr = @"";
        if (activityName.length > 8) {
            activityStr = [NSString stringWithFormat:@"#%@#",[activityName stringByReplacingCharactersInRange:NSMakeRange(8, activityName.length -8) withString:@"..."]];
        }else{
            activityStr = [NSString stringWithFormat:@"#%@#",activityName];
        }
        allStr = [NSString stringWithFormat:@"%@%@",activityStr,recordEntity.Title];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc ]initWithString:allStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:JXColorFromRGB(0x368bff) range:NSMakeRange(0, activityStr.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:JX999999Color range:NSMakeRange(activityStr.length, recordEntity.Title.length)];
        _infoLabel.attributedText = attributedString;
        
    }else{
        _infoLabel.textColor = JX999999Color;
        _infoLabel.text = recordEntity.Title;
    }
    
    [_commentButton setTitle:recordEntity.ViewNum forState:UIControlStateNormal];
    [_commentButton setImage:JXImageNamed(@"Read_") forState:UIControlStateNormal];
    [_priseButton setTitle:recordEntity.Like forState:UIControlStateNormal];
    [_priseButton setImage:JXImageNamed(@"thumbup_default") forState:UIControlStateNormal];
    
    if (self.type == RecordDistributionType){
        [self setRecordDistributionType:indexPath];
        [self.guiderImageView setHidden:YES];
        [self.guiderLabel setHidden:YES];
    }else{
        [self setRecordCommentionType:indexPath];
        [self.guiderImageView setHidden:NO];
        [self.guiderLabel setHidden:NO];
        
        [_guiderImageView sd_setImageWithURL:[NSURL URLWithString:recordEntity.User.HeadPortrait] placeholderImage:JXImageNamed(@"portrait_default")];
        _guiderLabel.text = recordEntity.User.UserName;
    }

    [self setEditStyle:_isEditStyle indexPath:indexPath];
}

- (void)autoLayoutSubViews{
    [self.topContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.top).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(184*kPercent);
    }];
    [self.centerContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.topContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(42 +35);//10 +24 +8 +(14 +7 +14)
    }];
    [self.bottomContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.centerContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
//        make.height.equalTo(31);
        make.bottom.equalTo(self.bottom);
    }];
    
    [self.bigImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topContentView).offset(0);
        make.top.equalTo(_topContentView).offset(0);
        make.right.equalTo(_topContentView).offset(0);
        make.height.equalTo(184*kPercent);
    }];
    [self.guiderImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(10);
        make.top.equalTo(_centerContentView).offset(10);
        make.height.width.equalTo(24);
    }];
    [self.guiderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_guiderImageView.right).offset(9);
        make.top.equalTo(_centerContentView).offset(1);
        make.right.equalTo(_topContentView).offset(9);
        make.bottom.equalTo(_centerContentView).offset(-35);
    }];
    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(10);
        make.top.equalTo(_guiderImageView.bottom).offset(8);
        make.right.equalTo(_centerContentView).offset(-10);
        make.height.equalTo(35);
    }];
    
    [self.commentButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomContentView).offset(10);
        make.top.equalTo(_bottomContentView).offset(0);
        make.bottom.equalTo(_bottomContentView).offset(0);
//        make.width.equalTo(80);
    }];
    [self.priseButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentButton.right).offset(5);
        make.top.equalTo(_bottomContentView).offset(0);
        make.bottom.equalTo(_bottomContentView).offset(0);
        make.right.equalTo(_bottomContentView).offset(-10);
    }];
    
//    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_bottomContentView).offset(10);
//        make.top.equalTo(_bottomContentView).offset(10);
//        make.bottom.equalTo(_bottomContentView).offset(-10);
//        make.width.equalTo(_leftImageView.height);
//    }];
//    
//    [self.rightNumLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomContentView).offset(0);
//        make.bottom.equalTo(_bottomContentView).offset(0);
//        make.right.equalTo(_bottomContentView.right).offset(-10);
//        make.width.equalTo(26);
//    }];
//    [self.rightImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomContentView).offset(10);
//        make.bottom.equalTo(_bottomContentView).offset(-10);
//        make.right.equalTo(_rightNumLabel.left).offset(-4);
//        make.height.equalTo(_rightImageView.width);
//    }];
//    [self.leftNumLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_leftImageView.right).offset(5);
//        make.top.equalTo(_bottomContentView).offset(0);
//        make.bottom.equalTo(_bottomContentView).offset(0);
////        make.width.equalTo(60);
//        make.right.equalTo(_rightImageView.left).offset(-4);
//    }];
   
}

- (void)setRecordDistributionType:(NSIndexPath *)indexPath{
    [self.centerContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.topContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(10 +35);//10 +(14 +7 +14)
    }];
    [self.guiderImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(10);
        make.top.equalTo(_centerContentView).offset(10);
        make.height.width.equalTo(0.1);
    }];
}
- (void)setRecordCommentionType:(NSIndexPath *)indexPath{
    [self.centerContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.topContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(42 +35);//10 +24 +8 +(14 +7 +14)
    }];

    [self.guiderImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(10);
        make.top.equalTo(_centerContentView).offset(10);
        make.height.width.equalTo(24);
    }];
}
- (void)setEditStyle:(BOOL)isEdit indexPath:(NSIndexPath *)indexPath{
    if (isEdit) {
        [self addSubview:self.shadowView];
        [self.shadowView addSubview:self.deleteButton];
        self.deleteButton.tag = indexPath.item;
        
        [self.shadowView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.height.and.width.equalTo(self);
        }];
        [self.deleteButton remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.right);
            make.height.and.width.equalTo(40);
        }];
    }else{
        if (_shadowView) {
            [_shadowView removeFromSuperview];
        }
    }
}
#pragma mark - subview init
- (UIView *)topContentView{
    if (!_topContentView) {
        _topContentView = [[UIView alloc]init ];
        _topContentView.layer.cornerRadius = 3.f;
        _topContentView.clipsToBounds = YES;
    }
    return _topContentView;
}
- (UIView *)centerContentView{
    if (!_centerContentView) {
        _centerContentView = [[UIView alloc] init];
    }
    return _centerContentView;
}
- (UIView *)bottomContentView{
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] init];
    }
    return _bottomContentView;
}
- (UIImageView *)bigImageView{
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc]init ];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bigImageView.clipsToBounds = YES;
    }
    return _bigImageView;
}
- (UIImageView *)guiderImageView{
    if (!_guiderImageView) {
        _guiderImageView = [[UIImageView alloc]init ];
        _guiderImageView.layer.cornerRadius = 12.f;
        _guiderImageView.layer.masksToBounds = YES;
    }
    return _guiderImageView;
}
- (UILabel *)guiderLabel{
    if (!_guiderLabel) {
        _guiderLabel = [[UILabel alloc]init] ;
        _guiderLabel.backgroundColor = JXDebugColor;
        _guiderLabel.textColor = JX333333Color;
        _guiderLabel.font = JXFontForNormal(13);
        _guiderLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _guiderLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init] ;
        _infoLabel.backgroundColor = JXDebugColor;
        _infoLabel.textColor = JX999999Color;
        _infoLabel.font = JXFontForNormal(14);
        _infoLabel.numberOfLines = 2;
    }
    return _infoLabel;
}

- (UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = JXDebugColor;
        _commentButton.titleLabel.font = JXFontForNormal(11);
        [_commentButton setTitleColor:JX999999Color forState:UIControlStateNormal];
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, -3)];
    }
    return _commentButton;
}
- (UIButton *)priseButton{
    if (!_priseButton) {
        _priseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _priseButton.backgroundColor = JXDebugColor;
        _priseButton.titleLabel.font = JXFontForNormal(11);
        [_priseButton setTitleColor:JX999999Color forState:UIControlStateNormal];
        _priseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_priseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, -3)];
        
    }
    return _priseButton;
}
- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init ];
    }
    return _leftImageView;
}
- (UILabel *)leftNumLabel{
    if (!_leftNumLabel) {
        _leftNumLabel = [[UILabel alloc]init] ;
        _leftNumLabel.backgroundColor = JXDebugColor;
        _leftNumLabel.textColor = JX999999Color;
        _leftNumLabel.font = JXFontForNormal(11);
    }
    return _leftNumLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init ];
    }
    return _rightImageView;
}
- (UILabel *)rightNumLabel{
    if (!_rightNumLabel) {
        _rightNumLabel = [[UILabel alloc]init] ;
        _rightNumLabel.backgroundColor = JXDebugColor;
        _rightNumLabel.textColor = JX999999Color;
        _rightNumLabel.font = JXFontForNormal(11);
    }
    return _rightNumLabel;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init ];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.5f;
        _shadowView.layer.cornerRadius = 3.f;
        _shadowView.clipsToBounds = YES;
    }
    return _shadowView;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = JXDebugColor;
        [_deleteButton setImage:JXImageNamed(@"icon_delete") forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
#pragma mark - click method
- (void)deleteRecord:(UIButton *)button{
    if (_block) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:button.tag inSection:0];
        self.block(indexPath);
    }
}
@end
