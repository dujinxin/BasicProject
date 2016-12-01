//
//  CouponDetailViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/29.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "PayCouponCell.h"
#import "OrderGuiderView.h"

@interface CouponDetailViewController (){
    PayCouponCell     *    _cellView;
    UIView            *    _storeView;
    OrderGuiderView   *    _guiderView;
    UIView            *    _regulationView;
    
    UIButton          * locationButton;
    CouponDetailEntity *  _entity;
}

@end

@implementation CouponDetailViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    _guiderView.layer.cornerRadius = 0;
    
    
    [self showLoadView];
    [[UserRequest shareManager] couponDetail:kApiCouponDetail param:@{@"cid":self.cid} success:^(id object,NSString *msg) {
        [self hideLoadView];
        _entity = (CouponDetailEntity*)object;
        [_cellView setCouponContent:_entity indexPath:nil];
        _guiderView.nameLabel.text = _entity.ShopName;
        _guiderView.detailLabel.text = [NSString stringWithFormat:@"地址:%@",_entity.ShopAddress];
        [locationButton setTitle:[NSString stringWithFormat:@"%@",_entity.Distance] forState:UIControlStateNormal];
        
    } failure:^(id object,NSString *msg) {
        [self hideLoadView];
    }];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"详情";
    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(share:) image:JXImageNamed(@"title_btn_share") style:kSingleImage];
    
    _cellView = [[PayCouponCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _cellView.type = MyCouponDetailType;
    _storeView = [UIView new];
    _guiderView = [[OrderGuiderView alloc ]initWithStyle:OrderGuiderStyleSubtitle];
    _regulationView = [UIView new];
    
    [self.view addSubview:_cellView];
    [self.view addSubview:_guiderView];
    
    [self setStoreView];
    [self setGuiderView];
    
    [self layoutSubViews];
    [self setRegulationView];
}
- (void)setStoreView{
    _storeView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    _storeView.backgroundColor = JXColorFromRGB(0xfee330);
    
    UILabel * textView = [[UILabel alloc ]initWithFrame:CGRectMake(2, 0, kScreenWidth, 44*kPercent)];
    textView.text = @"  可用门店";
    textView.textColor = JX333333Color;
    textView.font = JXFontForNormal(13);
    textView.backgroundColor = [UIColor whiteColor];
    [_storeView addSubview:textView];
    [self.view addSubview:_storeView];
}
- (void)setGuiderView{
    JXWeakSelf(self);
    __unsafe_unretained CouponDetailEntity * entity = _entity;
    [_guiderView setClickEvents:^(id object) {
//        FilmClassController *controller = [[FilmClassController alloc] init];
//        controller.title = entity.ShopName;
//        controller.shopId = entity.ShopID;
//        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(kScreenWidth -95, 15, 80, 20);
    locationButton.backgroundColor = JXDebugColor;
//    [locationButton addTarget:self action:@selector(topTabAction:) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setTitleColor:JXColorFromRGB(0x333333) forState:UIControlStateNormal];
    [locationButton setTitle:@"230m" forState:UIControlStateNormal];
    locationButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [locationButton setImage:JXImageNamed(@"my_content_positioning") forState:UIControlStateNormal];
    locationButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_guiderView addSubview:locationButton];
}
- (void)setRegulationView{
    
    _regulationView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    _regulationView.backgroundColor = JXFfffffColor;
    [self.view addSubview:_regulationView];
    
    UILabel * titleView = [UILabel new];
    titleView.text = @"规则";
    titleView.textColor = JXff5252Color;
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.font = JXFontForNormal(14);
    titleView.backgroundColor = JXDebugColor;
    [_regulationView addSubview:titleView];
    
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_regulationView).offset(10);
        make.left.equalTo(_regulationView).offset(15);
        make.right.equalTo(_regulationView).offset(-15);
        make.height.mas_equalTo(14);
    }];
    NSArray * titleArray = @[@"公司法师法师松放松的方式松放放松的方式",@"公司法师法师打发士大夫似的放松放松的方式松放松的方式松放松的方式松松放松的方式松放放松的方式",@"公司法师法师打发士大夫似的放松放松的方式松放松的方式松放松的方式松松放松的方式松放放松的方式",@"公司法师法师打发士大夫似的放松放松的方式松放松的方式松放松的方式松松放松的方式松放放松的方式"];
    CGFloat contentViewHeight = 0;
    for (int i = 0 ; i < titleArray.count; i ++) {
        UIView * point = [UIView new];
        point.backgroundColor = [UIColor blackColor];
        point.layer.cornerRadius = 2;
        [_regulationView addSubview:point];
        
        UILabel * contentView = [UILabel new];
        contentView.textColor = JX333333Color;
        contentView.textAlignment = NSTextAlignmentLeft;
        contentView.font = JXFontForNormal(12);
        contentView.numberOfLines = 0;
        contentView.backgroundColor = JXDebugColor;
        [_regulationView addSubview:contentView];
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 6;
        //paragraphStyle.paragraphSpacing = 6;
        
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = @{NSFontAttributeName:contentView.font,NSParagraphStyleAttributeName:paragraphStyle};
        CGRect rect = [titleArray[i] boundingRectWithSize:CGSizeMake(kScreenWidth -44, 1000) options:option attributes:attributes context:nil];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:titleArray[i]];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        contentView.attributedText = attStr;
        
        
        [point makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.bottom).offset(16 *(i+1) +contentViewHeight);
            make.left.equalTo(_regulationView).offset(15);
            make.size.equalTo(CGSizeMake(4, 4));
        }];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(point.right).offset(10);
            make.top.equalTo(titleView.bottom).offset(12 *(i+1) +contentViewHeight);
            make.size.equalTo(rect.size);
        }];
        contentViewHeight += rect.size.height;
    }
    
    [_regulationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_guiderView.bottom).offset(1);
        make.right.equalTo(self.view);
        make.height.equalTo(34 +titleArray.count*12 +contentViewHeight);
    }];
}
- (void)layoutSubViews{
    [_cellView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavStatusHeight +5);
        make.right.equalTo(self.view);
        make.height.equalTo(107*kPercent);
    }];
    [_storeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_cellView.bottom).offset(5);
        make.right.equalTo(self.view);
        make.height.equalTo(44*kPercent);
    }];
    [_guiderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(_storeView.bottom).offset(5);
        make.right.equalTo(self.view);
        make.height.equalTo(75*kPercent);
    }];
    
}
#pragma mark - Click events
- (void)share:(UIButton *)button{
    [DJXRequest requestWithBlock:kApiShareInfo param:@{@"infoId":_entity.CouponID,@"infoType":@(UserCouponShareType)} success:^(id object,NSString *msg) {

        [[ShareManager shareManager] showCustomShareViewWithObject:object presentedController:self success:^(id object, UserShareSns sns) {
            NSLog(@"分享成功");
            [DJXRequest requestWithBlock:kApiShareSuccess param:@{@"InfoId":_entity.CouponID ,@"infoType":@(UserInviteShareType),@"ShareTo":@(sns)} success:^(id object,NSString *msg) {
                NSLog(@"记录分享成功");
                [self showJXNoticeMessage:msg];
            } failure:^(id object,NSString *msg) {
                NSLog(@"记录分享失败");
            } animated:NO];
        } failure:^(id object, UserShareSns sns) {
            NSLog(@"分享失败");
        }];
        
    } failure:^(id object,NSString *msg) {
        //
    } animated:NO];
}

@end
