//
//  PromotionDetailController.m
//  GJieGo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//  --- 新品详情 ---

#import "PromotionDetailController.h"
#import "BaseView.h"
#import "BrandCouponController.h"
#import "CouponListController.h"
#import "HotPushDetailsModel.h"
#import "SGDateUtil.h"

@interface PromotionDetailController ()<UIScrollViewDelegate, UIActionSheetDelegate>{
    UIView *statusBackView;
    NSArray *sourceArray;
    
    HotPushDetailsItem *_hotPushDetailItem;
}
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *infoLabel;
@property (nonatomic, strong)UIView * bottomView;
@property (nonatomic, strong)UIScrollView *detailScrollView;
@end

@implementation PromotionDetailController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    sourceArray = [[NSArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
}

//- (void)creatScrollView{
//    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 0)];
//    self.detailScrollView.delegate = self;
//    [self.view addSubview:self.detailScrollView];
//    self.detailScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self updateData];
//    }];
//}
- (void)creatUI{
    [self.view removeAllSubviews];
    CGFloat high = 0.0;
    
    self.detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 0)];
    self.detailScrollView.delegate = self;
    [self.view addSubview:self.detailScrollView];
    self.detailScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self updateData];
    }];
    
    self.titleLabel = [UILabel labelWithFrame:CGRectZero text:_hotPushDetailItem.Name tinkColor:GJGRGB16Color(0x333333) fontSize:16.0f];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel = [UILabel labelWithFrame:CGRectZero text:[SGDateUtil getDateDayFromTimeStamp:[NSString stringWithFormat:@"%lf", [_hotPushDetailItem.createDate doubleValue]]] tinkColor:GJGRGB16Color(0x666666) fontSize:12.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel = [UILabel labelWithFrame:CGRectZero text:_hotPushDetailItem.Description tinkColor:GJGRGB16Color(0x333333) fontSize:14.0f];
    self.infoLabel.numberOfLines = 0;
    
    sourceArray = [_hotPushDetailItem.Images componentsSeparatedByString:@","];
    [self.detailScrollView addSubview:self.titleLabel];
    [self.detailScrollView addSubview:self.timeLabel];
    [self.detailScrollView addSubview:self.infoLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.width.equalTo(ScreenWidth - 30);
        make.top.equalTo(13);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.width.equalTo(ScreenWidth - 30);//.size.equalTo(self.timeLabel);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.timeLabel);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.timeLabel.bottom).offset(18);
        make.size.equalTo(self.infoLabel);
    }];
    [self.detailScrollView layoutIfNeeded];
    CGFloat contentHeight = 0;
    for (int i = 0; i < sourceArray.count; i++) {
        UIImageView *infoImageView = [[UIImageView alloc] init];
        [infoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@%dW_1o", sourceArray[i], (int)(0.92 * ScreenWidth)]] placeholderImage:[UIImage imageNamed:@"default_portrait_less"]];
        CGFloat scale = infoImageView.image.size.height / infoImageView.image.size.width;
        infoImageView.frame = CGRectMake((ScreenWidth - 0.92 * ScreenWidth) / 2, (self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 30) + high, 0.92 * ScreenWidth, ScreenWidth * 0.92 * scale);
        high += (ScreenWidth * 0.92 * scale + 10);
        [self.detailScrollView addSubview:infoImageView];
        
        if (i == sourceArray.count - 1) {
            contentHeight = self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 30 + high + 64 + 49;
        }
    }
    self.detailScrollView.contentSize = CGSizeMake(ScreenWidth, contentHeight);
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, ScreenWidth, 49)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    UIView *lin1 = [[UIView alloc] init];
    lin1.backgroundColor = GJGRGB16Color(0xd2d2d2);
    UIView *lin2 = [[UIView alloc] init];
    lin2.backgroundColor = GJGRGB16Color(0xd2d2d2);
    
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom
                                                  tag:_hotPushDetailItem.HasLike
                                                title:@"点赞"
                                            titleSize:15.0f
                                                frame:CGRectMake(0, self.view.size.height - 49, ScreenWidth / 2, 49)
                                                Image:[UIImage imageNamed:@"thumbup_default"]
                                               target:self
                                               action:@selector(clickPraiseButtonAction:)];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom
                                                 tag:0
                                               title:@"分享"
                                           titleSize:15.0f
                                               frame:CGRectMake(praiseButton.frame.size.width,
                                                                praiseButton.frame.origin.y,
                                                                ScreenWidth / 2,
                                                                praiseButton.frame.size.height)
                                               Image:[UIImage imageNamed:@"share_default"]
                                              target:self
                                              action:@selector(clickShareButtonAction:)];
    [praiseButton setImage:[UIImage imageNamed:@"thumbup_selected"] forState:UIControlStateSelected];
    
    
    
    [self.bottomView addSubview:lin1];
    [self.bottomView addSubview:lin2];
    [self.bottomView addSubview:praiseButton];
    [self.bottomView addSubview:shareButton];
    [self.view addSubview:self.bottomView];
    praiseButton.selected = _hotPushDetailItem.HasLike;
    
    [lin1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView);
        make.height.equalTo(1);
    }];
    [lin2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(praiseButton.trailing).offset(-0.5);
        make.top.equalTo(self.bottomView).offset(12);
        make.width.equalTo(1);
        make.height.equalTo(30);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(49);
    }];
    [praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
        make.width.equalTo(ScreenWidth * 0.5 - 0.5);
        make.height.equalTo(self.bottomView);
    }];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(praiseButton.trailing).offset(1);
        make.bottom.equalTo(praiseButton);
        make.width.equalTo(praiseButton);
        make.height.equalTo(praiseButton);
    }];
}

- (void)loadData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:@{@"hId": self.infoId}];
    [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_HotPushDetail) parameters:param requestblock:^(id responseobject, NSError *error) {
        NSLog(@" kGet_HotPushDetail   －－－－－－－－－－ %@", responseobject);
        if ([responseobject[@"status"] integerValue] == 0) {
            if (responseobject[@"data"] == nil || [responseobject[@"data"] isKindOfClass:[NSNull class]]) {
                self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
                UIImageView *errorImageView = [[UIImageView alloc] init];
                errorImageView.image = [UIImage imageNamed:@"cry"];
                [self.view addSubview:errorImageView];
                [errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view);
                    make.top.equalTo(130);
                }];
            }else{
                self.view.backgroundColor = [UIColor whiteColor];
                HotPushDetailsModel *hotModel = [[HotPushDetailsModel alloc] initWithDic:responseobject];
                _hotPushDetailItem = [[HotPushDetailsItem alloc] initWithDic:hotModel.Data];
                [self creatUI];
            }
        }else{
            [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - Update data

- (void)updateData {
    
        [self loadData];
        [_detailScrollView.mj_header endRefreshing];
}



- (void)clickPraiseButtonAction:(UIButton *)button{

        [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201020070002
                                                        andBCID:self.bcId
                                                      andMallID:self.mId
                                                      andShopID:self.shopId
                                                    andItemType:self.hType
                                                andBusinessType:self.typeKey
                                                      andItemID:[NSString stringWithFormat:@"%ld", _hotPushDetailItem.ID]
                                                    andItemText:nil
                                                    andOpUserID:[UserDBManager shareManager].UserID];
    
    [[LoginManager shareManager] checkUserLoginState:^{
        NSString *reqStr ;
        if (!_hotPushDetailItem.HasLike) {
            reqStr = kGJGRequestUrl(kGet_HotLike);
        }else{
            reqStr = kGJGRequestUrl(kGet_HotUnLike);
        }
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param addEntriesFromDictionary:@{@"infoId":self.infoId}];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [request requestPostTypeWithUrl:reqStr
                             parameters:param
                           requestblock:^(id responseobject, NSError *error)
        {

            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            if ([responseobject[@"status"] integerValue] == 0) {
                
                _hotPushDetailItem.HasLike = !_hotPushDetailItem.HasLike;
                button.selected = _hotPushDetailItem.HasLike;
            }else{
                [[UIApplication sharedApplication].keyWindow makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
            }
        }];
    }];
}

- (void)clickShareButtonAction:(UIButton *)button{
    
    [[LoginManager shareManager] checkUserLoginState:^{
        [[LBRequestManager sharedManager] getSharedInfoWithInfoId:[self.infoId integerValue]
                                                         infoType:GJGShareInfoTypeIsHot
                                                           result:^(id responseobject, NSError *error)
         {
             if (!error) {
                 GJGShareInfo *shareInfo = responseobject;
                 [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                       title:shareInfo.Title
                                                                    imageUrl:shareInfo.Images
                                                                         url:shareInfo.Url
                                                                 description:@""
                                                                      infoId:self.infoId
                                                                   shareType:UserHotPushShareType
                                                         presentedController:self
                                                                     success:^(id object, UserShareSns sns)
                  {  // 分享成功, 触发数据埋点
                      [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201020070003
                                                                      andBCID:self.bcId
                                                                    andMallID:self.mId
                                                                    andShopID:self.shopId
                                                                  andItemType:self.hType
                                                              andBusinessType:self.typeKey
                                                                    andItemID:[NSString stringWithFormat:@"%ld", _hotPushDetailItem.ID]
                                                                  andItemText:nil
                                                                  andOpUserID:[UserDBManager shareManager].UserID];
                  } failure:^(id object, UserShareSns sns) {
                      NSLog(@"分享失败.");
                  }];
//                 [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
//                                                                       title:shareInfo.Title
//                                                                    imageUrl:shareInfo.Images
//                                                                         url:shareInfo.Url
//                                                                 description:@""
//                                                         presentedController:self
//                                                                     success:^(id object, UserShareSns sns)
//                  {
//                      [MBProgressHUD showSuccess:@"分享成功!" toView:self.view];
//                  } failure:^(id object, UserShareSns sns){
//
//                  }];
             }
         }];
    }];
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (scrollView.contentOffset.y > ScreenHeight) {
        if(velocity.y > 0){
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
        }];
    }
    }
    
}

@end
