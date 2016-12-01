//
//  PayCouponCell.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/27.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "PayCouponCell.h"

@interface PayCouponCell (){
    NSInteger   _selectRow;
}

@end

@implementation PayCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = JXF1f1f1Color;
        _selectRow = -1;
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.styleLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.limitLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.selectButton];
        [self autoLayoutSubviews];
    }
    return self;
}
- (void)autoLayoutSubviews{
    [_bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*kPercent);
        make.top.equalTo(self).offset(5*kPercent);
        make.right.equalTo(-15*kPercent);
        make.bottom.equalTo(-5*kPercent);
    }];
    [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15*kPercent);
        make.top.equalTo(self).offset((17+5)*kPercent);
        make.width.equalTo(75*kPercent);
        make.height.equalTo(25*kPercent);
    }];
    [_styleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*kPercent);
        make.top.equalTo(_moneyLabel.bottom).offset(24*kPercent);
        make.width.equalTo(_moneyLabel);
        make.height.equalTo(13*kPercent);
    }];
    [_selectButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5*kPercent);
        make.right.equalTo(self.right).offset(-15*kPercent);
        make.width.equalTo(40*kPercent);
        make.height.equalTo(40*kPercent);
    }];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyLabel.right).offset(14*kPercent);
        make.top.equalTo(self).offset((5+10)*kPercent);
        make.right.equalTo(_selectButton.left).offset(0);
        make.height.equalTo(13*kPercent);
    }];
    [_numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.left);
        make.top.equalTo(_nameLabel.bottom).offset(10*kPercent);
        make.width.equalTo(_nameLabel.width);
        make.height.equalTo(11*kPercent);
    }];
    [_limitLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.left);
        make.top.equalTo(_numberLabel.bottom).offset(5*kPercent);
        make.width.equalTo(_nameLabel.width);
        make.height.equalTo(11*kPercent);
    }];
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.left);
        make.bottom.equalTo(self.bottom).offset(-10*kPercent);
        make.right.equalTo(self.right).offset((-15-10)*kPercent);
        make.height.equalTo(_nameLabel.height);
    }];
}
- (void)setCouponContent:(id)object indexPath:(NSIndexPath *)indexPath{
    [self setCouponContent:object indexPath:indexPath selectedRow:-1 selectedBlock:nil];
}
- (void)setCouponContent:(id)object indexPath:(NSIndexPath *)indexPath selectedRow:(NSInteger)selectRow selectedBlock:(selectedBlock)block{
    CouponEntity * entity = (CouponEntity *)object;
    _indexPath = indexPath;
    _selectRow = selectRow;
    if (self.type == MyCouponListType) {
        
        [self.selectButton setHidden:YES];
        if (indexPath.row %3 ==0) {
            _bgImageView.image = JXImageNamed(@"coupons");
        }else if (indexPath.row %3 ==1){
            _bgImageView.image = JXImageNamed(@"coupons_overdue");
        }else{
            _bgImageView.image = JXImageNamed(@"coupons_used");
        }
    }else if (self.type == MyCouponDetailType){
        [self.selectButton setHidden:YES];
        _bgImageView.image = JXImageNamed(@"coupons");
    }else{
        [self.selectButton setHidden:NO];
        self.selectButton.tag = indexPath.row;
        if (indexPath.row == _selectRow) {
            [self.selectButton setImage:JXImageNamed(@"rb_selected") forState:UIControlStateNormal];
        }else{
            [self.selectButton setImage:JXImageNamed(@"rb_default") forState:UIControlStateNormal];
        }
        if (block) {
            _block = block;
        }
        _bgImageView.image = JXImageNamed(@"coupons");
    }
    _nameLabel.text = entity.CouponName;
    _numberLabel.text = [NSString stringWithFormat:@"券号:%@",entity.CouponID];
    _limitLabel.text = entity.DiscountDesc;
    _dateLabel.text = entity.AvailableTime;
    _styleLabel.text = entity.TypeName;
    if (entity.TypeID.integerValue == 2) {
        [_moneyLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(15*kPercent);
            make.top.equalTo(self).offset((17+5)*kPercent);
            make.width.equalTo(75*kPercent);
            make.height.equalTo(0.01);
        }];
        [_styleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15*kPercent);
            make.centerY.equalTo(self);
            make.width.equalTo(_moneyLabel);
            make.height.equalTo(13*kPercent);
        }];
        _moneyLabel.hidden = YES;
    }else{
        
        [_moneyLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(15*kPercent);
            make.top.equalTo(self).offset((17+5)*kPercent);
            make.width.equalTo(75*kPercent);
            make.height.equalTo(25*kPercent);
        }];
        [_styleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15*kPercent);
            make.top.equalTo(_moneyLabel.bottom).offset(24*kPercent);
            make.width.equalTo(_moneyLabel);
            make.height.equalTo(13*kPercent);
        }];
        NSString * str = @"元";
        //设置特殊颜色
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",entity.Discount]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0,entity.Discount.length-str.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(entity.Discount.length-str.length,str.length)];
        _moneyLabel.attributedText = attributedString;
        _moneyLabel.hidden = NO;
    }
}
#pragma mark - subView init 
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new ];
        _bgImageView.backgroundColor = [UIColor whiteColor];
    }
    return _bgImageView;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new ];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont systemFontOfSize:25];//25,14
        _moneyLabel.backgroundColor = JXDebugColor;
        _moneyLabel.textColor = JXFfffffColor;
        _moneyLabel.text = @"5元";
    }
    return _moneyLabel;
}
- (UILabel *)styleLabel{
    if (!_styleLabel) {
        _styleLabel = [UILabel new ];
        _styleLabel.textAlignment = NSTextAlignmentCenter;
        _styleLabel.font = [UIFont systemFontOfSize:13];
        _styleLabel.backgroundColor = JXDebugColor;
        _styleLabel.textColor = JXFfffffColor;
        _styleLabel.text = @"代金券";
    }
    return _styleLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new ];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.backgroundColor = JXDebugColor;
        _nameLabel.textColor = JX333333Color;
        _nameLabel.text = @"only夏季新快满减券";
    }
    return _nameLabel;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new ];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.font = [UIFont systemFontOfSize:11];
        _numberLabel.backgroundColor = JXDebugColor;
        _numberLabel.textColor = JX999999Color;
        _numberLabel.text = @"券号：234234234242423";
    }
    return _numberLabel;
}
- (UILabel *)limitLabel{
    if (!_limitLabel) {
        _limitLabel = [UILabel new ];
        _limitLabel.textAlignment = NSTextAlignmentLeft;
        _limitLabel.font = [UIFont systemFontOfSize:11];
        _limitLabel.backgroundColor = JXDebugColor;
        _limitLabel.textColor = JX999999Color;
        _limitLabel.text = @"满500-50";
    }
    return _limitLabel;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel new ];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.backgroundColor = JXDebugColor;
        _dateLabel.textColor = JX999999Color;
        _dateLabel.text = @"限时 2016-5-1 --- 2016-5-30";
    }
    return _dateLabel;
}
- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectedIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setImage:JXImageNamed(@"rb_default") forState:UIControlStateNormal];//rb_selected
//        _selectButton.imageView.backgroundColor = [UIColor redColor];
        _selectButton.backgroundColor = JXDebugColor;
        
    }
    return _selectButton;
}
#pragma mark - click events
- (void)selectedIndexPath:(UIButton *)button{
    if (_selectRow == button.tag) {
        _selectRow = -1;
    }else{
        _selectRow = button.tag;
    }
    if (_block) {
        self.block(_selectRow);
    }
    
}
@end
