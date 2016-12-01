//
//  CollectionViewCell.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/5/3.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "CollectionViewCell.h"


@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.mainContentView];
        [self addSubview:self.mainImageView];
        
        [self addSubview:self.shadeView];
        
        [self addSubview:self.storeLabel];
        [self addSubview:self.locationLabel];
        [self addSubview:self.bottomContentView];
        
        [self.bottomContentView addSubview:self.leftButton];
        [self.bottomContentView addSubview:self.rightButton];
  
        [self autoLayoutSubViews];
        
    }
    return self;
}
- (void)setCollectionCellInfo:(id)entity indexPath:(NSIndexPath *)indexPath{
    CollectionEntity * collectionEntity = (CollectionEntity *)entity;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:collectionEntity.Image] placeholderImage:JXImageNamed(@"default_landscape_normal")];
    _storeLabel.text = collectionEntity.ShopName;
    if ([collectionEntity.Floor isKindOfClass:[NSString class]]) {
        if (collectionEntity.Floor.length) {
            _locationLabel.text = [NSString stringWithFormat:@"%@ %@",collectionEntity.MallName,collectionEntity.Floor];
        }else{
            _locationLabel.text = collectionEntity.MallName;
        }
    }else{
        _locationLabel.text = collectionEntity.MallName;
    }
    

    [_leftButton setTitle:collectionEntity.Collection forState:UIControlStateNormal];
    [_leftButton setImage:JXImageNamed(@"my_content_icon_focus_white_disabled") forState:UIControlStateNormal];
    [_rightButton setTitle:[NSString stringWithFormat:@"%@",collectionEntity.Distance] forState:UIControlStateNormal];
    [_rightButton setImage:JXImageNamed(@"my_content_icon_positioning_white_disabled") forState:UIControlStateNormal];
}
-(void)relayoutSubViews:(int)tag{

}

-(void)autoLayoutSubViews{
    [self.mainContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.top).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom).offset(0);
    }];
    
    [self.mainImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.top).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom).offset(0);
    }];
    [self.storeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.top).offset(41);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(17);
    }];
    [self.locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.storeLabel.bottom).offset(10);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(12);
    }];
    
    [self.bottomContentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.locationLabel.bottom).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.height.equalTo(31);
    }];
   
    [self.leftButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomContentView.centerX).offset(-20);
        make.width.equalTo(64);
        make.top.equalTo(_bottomContentView).offset(10);
        make.bottom.equalTo(_bottomContentView).offset(-10);
    }];
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomContentView.centerX).offset(20);
        make.width.equalTo(64);
        make.top.equalTo(_bottomContentView).offset(10);
        make.bottom.equalTo(_bottomContentView).offset(-10);
    }];
//    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_bottomContentView).offset(10);
//        make.top.equalTo(_bottomContentView).offset(10);
//        make.bottom.equalTo(_bottomContentView).offset(-10);
//        make.width.equalTo(_leftImageView.height);
//    }];
//    [self.leftNumLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_leftImageView.right).offset(5);
//        make.top.equalTo(_bottomContentView).offset(0);
//        make.bottom.equalTo(_bottomContentView).offset(0);
//        make.width.equalTo(100);
//    }];
//    
//    [self.rightNumLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomContentView).offset(0);
//        make.bottom.equalTo(_bottomContentView).offset(0);
//        make.right.equalTo(_bottomContentView.right).offset(-10);
//        make.width.equalTo(100);
//    }];
//    [self.rightImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomContentView).offset(10);
//        make.bottom.equalTo(_bottomContentView).offset(-10);
//        make.right.equalTo(_rightNumLabel.left).offset(-4);
//        make.height.equalTo(_rightImageView.width);
//    }];
    
    [self.shadeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(0);
        make.top.equalTo(self.top).offset(0);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom).offset(0);
    }];
}

#pragma mark - subview init
-(UIView *)mainContentView{
    if (!_mainContentView) {
        _mainContentView = [[UIView alloc]init ];
    }
    return _mainContentView;
}
-(UIImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc]init ];
    }
    return _mainImageView;
}
-(UILabel *)storeLabel{
    if (!_storeLabel) {
        _storeLabel = [[UILabel alloc]init] ;
        _storeLabel.backgroundColor = JXDebugColor;
        _storeLabel.textColor = JXFfffffColor;
        _storeLabel.textAlignment = NSTextAlignmentCenter;
        _storeLabel.font = JXFontForNormal(17);
        _storeLabel.numberOfLines = 1;
    }
    return _storeLabel;
}
-(UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init] ;
        _locationLabel.backgroundColor = JXDebugColor;
        _locationLabel.textColor = JXFfffffColor;
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.font = JXFontForNormal(12);
        _locationLabel.numberOfLines = 1;
    }
    return _locationLabel;
}
-(UIView *)bottomContentView{
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] init];
    }
    return _bottomContentView;
}
-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init ];
    }
    return _leftImageView;
}
-(UILabel *)leftNumLabel{
    if (!_leftNumLabel) {
        _leftNumLabel = [[UILabel alloc]init] ;
        _leftNumLabel.backgroundColor = JXDebugColor;
        _leftNumLabel.textColor = JXFfffffColor;
        _leftNumLabel.font = JXFontForNormal(11);
    }
    return _leftNumLabel;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init ];
    }
    return _rightImageView;
}
-(UILabel *)rightNumLabel{
    if (!_rightNumLabel) {
        _rightNumLabel = [[UILabel alloc]init] ;
        _rightNumLabel.backgroundColor = JXDebugColor;
        _rightNumLabel.textColor = JXFfffffColor;
        _rightNumLabel.font = JXFontForNormal(11);
    }
    return _rightNumLabel;
}
-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _leftButton.backgroundColor = JXDebugColor;
        [_leftButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
        _leftButton.titleLabel.font = JXFontForNormal(11);
    }
    return _leftButton;
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _rightButton.backgroundColor = JXDebugColor;
        [_rightButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
        _rightButton.titleLabel.font = JXFontForNormal(11);
    }
    return _rightButton;
}
-(UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc]init ];
        _shadeView.backgroundColor = [UIColor blackColor];
        _shadeView.alpha = 0.5;
    }
    return _shadeView;
}
@end
