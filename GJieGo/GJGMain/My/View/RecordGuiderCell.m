//
//  RecordGuiderCell.m
//  GJieGo
//
//  Created by dujinxin on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "RecordGuiderCell.h"

@implementation RecordGuiderCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
       
        [self addSubview:self.topContentView];
        [self addSubview:self.bottomContentView];
        [self addSubview:self.centerContentView];
        
        [self.topContentView addSubview:self.userImageView];
        [self.topContentView addSubview:self.nameLabel];
        [self.topContentView addSubview:self.timeLabel];
        [self.topContentView addSubview:self.levelView];
        
        //[self.bottomContentView addSubview:self.line];
        [self.bottomContentView addSubview:self.priseButton];
        [self.bottomContentView addSubview:self.commentButton];
        [self.bottomContentView addSubview:self.locationButton];
        
        [self.centerContentView addSubview:self.contentLabel];
        [self.centerContentView addSubview:self.leftImageView];
        [self.centerContentView addSubview:self.centerImageView];
        [self.centerContentView addSubview:self.rightImageView];
        [self.rightImageView addSubview:self.numLabel];
        
        [self autoLayoutSubViews];
        
    }
    return self;
}
- (void)setRecordCellInfo:(id)entity dateFormatter:(NSDateFormatter *)dateFormatter dateString:(NSString *)dateString indexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    RecordGuiderEntity * recordEntity = (RecordGuiderEntity *)entity;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[recordEntity.CreateTime doubleValue]/1000];
    NSString *dateString1 = [dateFormatter stringFromDate:date];
    CGFloat dateFloat = (dateString.doubleValue - [recordEntity.CreateTime doubleValue]/1000);
    //NSLog(@"interval = %f  date = %@",[recordEntity.CreateTime doubleValue],dateString);
    if (dateFloat / (3600*24*30) > 1 ) {
        _timeLabel.text = [dateString1 substringWithRange:NSMakeRange(0, 10)];
         //NSLog(@"interval = %f",dateFloat / (3600*24*30));
    }else{
        if (dateFloat / (3600*24) > 1 ){
            _timeLabel.text = [NSString stringWithFormat:@"%d天前",(int)dateFloat/(3600*24)];
            //NSLog(@"interval = %f",dateFloat / (3600*24));
        }else{
            if (dateFloat / 3600 > 1 ){
                _timeLabel.text = [NSString stringWithFormat:@"%d小时前",(int)dateFloat/3600];
                //NSLog(@"interval = %f",dateFloat / (3600));
            }else{
                if (dateFloat / 60 > 1 ){
                    _timeLabel.text = [NSString stringWithFormat:@"%d分钟前",(int)dateFloat/60];
                    //NSLog(@"interval = %f",dateFloat / (60));
                }else{
                    _timeLabel.text = [NSString stringWithFormat:@"刚刚"];
                    //NSLog(@"interval = %f",dateFloat);
                }
            }
        }
        
    }

   
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 7;
    //paragraphStyle.paragraphSpacing = 6;
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [recordEntity.Content boundingRectWithSize:CGSizeMake(kScreenWidth -30, 1000) options:option attributes:attributes context:nil];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:recordEntity.Content];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:recordEntity.User.HeadPortrait] placeholderImage:JXImageNamed(@"portrait_default")];
    _nameLabel.text = recordEntity.User.UserName;
    //_timeLabel.text = recordEntity.CreateTime;
    self.levelView.frame = CGRectMake(55, 38, 40, 12);
    [_levelView setLevelNum:[NSString stringWithFormat:@"V%@",recordEntity.User.UserLevel] levelTitle:recordEntity.User.UserLevelName];
    _contentLabel.attributedText = attStr;

    
    NSArray * imageArray = [recordEntity.Images componentsSeparatedByString:@","];
    int imageWidth = (kScreenWidth -30 -8*2)/3;
    if (imageArray.count >=3){
        _leftImageView.hidden = NO;
        _centerImageView.hidden = NO;
        _rightImageView.hidden = NO;
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%@w_1o",imageArray[0],@(imageWidth)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%@w_1o",imageArray[1],@(imageWidth)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%@w_1o",imageArray[2],@(imageWidth)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
        _numLabel.text = [NSString stringWithFormat:@"共%ld张",imageArray.count];
        if (imageArray.count ==3) {
            _numLabel.hidden = YES;
        }
    }else if (imageArray.count ==2){
        _leftImageView.hidden = NO;
        _centerImageView.hidden = NO;
        _rightImageView.hidden = YES;
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%@w_1o",imageArray[0],@(imageWidth)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%@w_1o",imageArray[1],@(imageWidth)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
    }else if (imageArray.count ==1){
        _leftImageView.hidden = NO;
        _centerImageView.hidden = YES;
        _rightImageView.hidden = YES;
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%@w_1o",imageArray[0],@(imageWidth)]] placeholderImage:JXImageNamed(@"default_portrait_normal")];
    }else{
        _leftImageView.hidden = YES;
        _centerImageView.hidden = YES;
        _rightImageView.hidden = YES;
    }
    
    
    [_priseButton setTitle:recordEntity.LikeNum forState:UIControlStateNormal];
    [_priseButton setImage:JXImageNamed(@"thumbup_default") forState:UIControlStateNormal];

    [_commentButton setTitle:recordEntity.ViewNum forState:UIControlStateNormal];
    [_commentButton setImage:JXImageNamed(@"Read_") forState:UIControlStateNormal];
//    [_commentButton setTitle:recordEntity.CommentNum forState:UIControlStateNormal];
//    [_commentButton setImage:JXImageNamed(@"my_content_icon_comments_gray_disabled") forState:UIControlStateNormal];
    [_locationButton setTitle:recordEntity.Distance forState:UIControlStateNormal];
    [_locationButton setImage:JXImageNamed(@"content_icon_positioning_disabled") forState:UIControlStateNormal];
    
    
    //[self setDistributionForGuider:indexPath];
    
    
    [self.contentLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(15);
        make.top.equalTo(_centerContentView).offset(0);
        make.right.equalTo(_centerContentView).offset(-15);
        make.height.equalTo(rect.size.height);
    }];
}




-(void)autoLayoutSubViews{
    [self.topContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.top).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(60);
    }];
    [self.bottomContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(29.5);
        make.bottom.equalTo(self.bottom);
    }];
    [self.centerContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.topContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottomContentView.top);
    }];
    
    
    [self.userImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topContentView).offset(15);
        make.top.equalTo(_topContentView).offset(10);
        make.bottom.equalTo(_topContentView).offset(-10);
        make.width.equalTo(_userImageView.height);
    }];
//    [self.levelView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_topContentView).offset(10 +2);
//        make.right.equalTo(_topContentView.right).offset(-15);
//        make.height.equalTo(12);
//        make.width.equalTo(80);
//    }];
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topContentView).offset(10);
        //make.left.equalTo(_nameLabel.right).offset(10);
        make.right.equalTo(_topContentView).offset(-15);
        make.height.equalTo(20);
    }];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userImageView.right).offset(10);
        make.top.equalTo(_topContentView).offset(10);
        make.height.equalTo(20);
        make.right.equalTo(_timeLabel.left).offset(-10);
    }];
    self.levelView.frame = CGRectMake(55, 38, 40, 12);

    
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(15);
        make.top.equalTo(_centerContentView).offset(0);
        make.right.equalTo(_centerContentView).offset(-15);
        make.height.equalTo(60);
    }];
    CGFloat imageWidth = (kScreenWidth -30 -8*2)/3;
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerContentView).offset(15);
        make.bottom.equalTo(_centerContentView.bottom).offset(-10);
        make.width.equalTo(imageWidth);
        make.top.equalTo(_contentLabel.bottom).offset(10);
    }];
    [self.centerImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.right).offset(8);
        make.bottom.equalTo(_centerContentView.bottom).offset(-10);
        make.width.equalTo(imageWidth);
        make.top.equalTo(_contentLabel.bottom).offset(10);
    }];
    [self.rightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerImageView.right).offset(8);
        make.bottom.equalTo(_centerContentView.bottom).offset(-10);
        make.width.equalTo(imageWidth);
        make.top.equalTo(_contentLabel.bottom).offset(10);
    }];
    [self.numLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightImageView.right);
        make.bottom.equalTo(_rightImageView.bottom);
        make.width.equalTo(30);
        make.height.equalTo(13);
    }];
    
//    [self.line makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.top.and.right.equalTo(_bottomContentView).offset(0);
//        make.height.equalTo(0.5);
//    }];
    [self.priseButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomContentView).offset(15 +3);
        make.top.equalTo(_bottomContentView).offset(0.5);
        make.bottom.equalTo(_bottomContentView).offset(0);
        make.width.equalTo(80);
    }];
    [self.commentButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priseButton.right).offset(5);
        make.top.equalTo(_bottomContentView).offset(0.5);
        make.bottom.equalTo(_bottomContentView).offset(0);
        make.width.equalTo(80);
    }];
    [self.locationButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomContentView.right).offset(-15);
        make.top.equalTo(_bottomContentView).offset(0.5);
        make.bottom.equalTo(_bottomContentView).offset(0);
        make.width.equalTo(80);
    }];
}

- (void)setDistributionForGuider:(NSIndexPath *)indexPath{
    
    [self.bottomContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.topContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        //        make.height.equalTo(31);
        make.bottom.equalTo(self.bottom);
    }];
    
    [self.leftImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomContentView).offset(10);
        make.top.equalTo(_bottomContentView.top).offset(10);
        make.bottom.equalTo(_bottomContentView.bottom).offset(-10);
        make.width.equalTo(_leftImageView.height);
    }];

    
}
- (void)setDistributionForComment:(NSIndexPath *)indexPath{
    [self.bottomContentView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.topContentView.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        //        make.height.equalTo(50);
        make.bottom.equalTo(self.bottom);
    }];
    
    [self.leftImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomContentView).offset(10);
        make.top.equalTo(_bottomContentView).offset(10);
        make.bottom.equalTo(_bottomContentView).offset(-10);
        make.width.equalTo(_leftImageView.height);
    }];

}
- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    }
    return _tap;
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    UIImageView * iv = (UIImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(guiderViewCell:indexPath:index:)]) {
        [self.delegate guiderViewCell:self indexPath:self.indexPath index:iv.tag];
    }
}
#pragma mark - subview init
-(UIView *)topContentView{
    if (!_topContentView) {
        _topContentView = [[UIView alloc]init ];
    }
    return _topContentView;
}
-(UIView *)centerContentView{
    if (!_centerContentView) {
        _centerContentView = [[UIView alloc] init];
    }
    return _centerContentView;
}
-(UIView *)bottomContentView{
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] init];
    }
    return _bottomContentView;
}

-(UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init ];
        _userImageView.backgroundColor = JXDebugColor;
        _userImageView.layer.cornerRadius = 20.f;
        _userImageView.layer.masksToBounds = YES;
    }
    return _userImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init] ;
        _nameLabel.backgroundColor = JXDebugColor;
        _nameLabel.textColor = JX333333Color;
        _nameLabel.font = JXFontForNormal(14);
    }
    return _nameLabel;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init] ;
        _timeLabel.backgroundColor = JXDebugColor;
        _timeLabel.textColor = JX999999Color;
        _timeLabel.font = JXFontForNormal(14);
    }
    return _timeLabel;
}
-(LevelView *)levelView{
    if (!_levelView) {
        _levelView = [[LevelView alloc ]init ];
        _levelView.backgroundColor = JXDebugColor;
    }
    return _levelView;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init] ;
        _contentLabel.backgroundColor = JXDebugColor;
        _contentLabel.textColor = JX333333Color;
        _contentLabel.font = JXFontForNormal(14);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init ];
        _leftImageView.backgroundColor = JXDebugColor;
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.tag = 0;
        //_leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_leftImageView addGestureRecognizer:tap];
    }
    return _leftImageView;
}
-(UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]init ];
        _centerImageView.backgroundColor = JXDebugColor;
        _centerImageView.userInteractionEnabled = YES;
        _centerImageView.tag = 1;
        //_centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_centerImageView addGestureRecognizer:tap];
    }
    return _centerImageView;
}
-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init ];
        _rightImageView.backgroundColor = JXDebugColor;
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.tag = 2;
        //_rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_rightImageView addGestureRecognizer:tap];
    }
    return _rightImageView;
}
-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init] ;
        _numLabel.backgroundColor = [UIColor blackColor];
        _numLabel.alpha = 0.6;
        _numLabel.textColor = JX999999Color;
        _numLabel.font = JXFontForNormal(11);
    }
    return _numLabel;
}
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = JXSeparatorColor;
    }
    return _line;
}

-(UIButton *)priseButton{
    if (!_priseButton) {
        _priseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _priseButton.backgroundColor = JXDebugColor;
        _priseButton.titleLabel.font = JXFontForNormal(11);
        [_priseButton setTitleColor:JX333333Color forState:UIControlStateNormal];
        _priseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_priseButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, -3)];
        
    }
    return _priseButton;
}
-(UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = JXDebugColor;
        _commentButton.titleLabel.font = JXFontForNormal(11);
        [_commentButton setTitleColor:JX333333Color forState:UIControlStateNormal];
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, -3)];
    }
    return _commentButton;
}
-(UIButton *)locationButton{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.backgroundColor = JXDebugColor;
        _locationButton.titleLabel.font = JXFontForNormal(11);
        [_locationButton setTitleColor:JX333333Color forState:UIControlStateNormal];
        _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, -3)];
    }
    return _locationButton;
}
@end
