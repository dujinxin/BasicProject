//
//  GuideHomeViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/3.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GuideHomeViewController.h"
#import "ShopGuideDetailViewController.h"
#import "GeneralMarketController.h"
#import "RestaurantClassController.h"
#import "FilmClassController.h"
#import "ShopGuideTableViewCell.h"
#import "LBGuideDetailM.h"
#import "GJGBottomToolBar.h"
#import "AvatarBrowser.h"

@interface GuideHomeViewController () <UITableViewDelegate, UITableViewDataSource, GJGBottomToolBarDelegate> {
    
    UIView *statusBackView;
    UITableView *mainTableView;
    
    UIView *headerViewHolder;
    UIImageView *iconView;
    UILabel *nameLabel;
    UIButton *lvlButton;
    UIButton *lvlNameButton;
    UIButton *fansButton;
    NSInteger fansCountWithoutMe;
    
    UIImageView *headerBGImgView;
    
    UIView *serveShopView;
    UIView *headerIntroView;
    
    GJGBottomToolBar *bottomBar;
    
    NSInteger page;
}

/** 导购个人信息 */
@property (nonatomic, strong) LBGuideDetailM *guider;
@property (nonatomic, strong) NSMutableArray<LBGuideInfoM *> *dataSource;

@end

@implementation GuideHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
    [super viewWillAppear:animated];
    
//    UIImage *img = [[UIImage imageNamed:@"white_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationController.navigationBar.backIndicatorImage = img;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = img;
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    [mainTableView setContentOffset:CGPointMake(0, -178) animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
//    UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationController.navigationBar.backIndicatorImage = img;
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = img;
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Lazy

- (NSMutableArray<LBGuideInfoM *> *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark - Init

- (void)initAttributes {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
    page = 1;
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    [self createNavBar];
}


#pragma mark - Load data

- (void)loadData {
    
    [self loadGuider];
}

- (void)loadGuider {

    [request requestUrl:kGJGRequestUrl(kApiGetGuideInfoDetails)
            requestType:RequestGetType
             parameters:@{@"gid" : [NSNumber numberWithInteger:self.gid]}
           requestblock:^(id responseobject, NSError *error)
     {
           if (!error) {
               if ([responseobject[@"status"] isEqualToNumber:@0]) {    NSLog(@"lb_guiderHome_detail:%@", responseobject);
                   if ([responseobject[@"data"] isKindOfClass:[NSNull class]]) {
                       [MBProgressHUD showError:@"网络异常" toView:self.view];
                       return ;
                   }
                   self.guider = [LBGuideDetailM modelWithDict:responseobject[@"data"]];
                   fansCountWithoutMe = self.guider.FollowNum - self.guider.HasFollow;
                   [self createUI];
                   [self loadPromotionsOfGuider];
               }
           }else {
               GJGLog(@"lb_guiderHome_detail_fail:%@", error);
           }
     }];
}

- (void)loadPromotionsOfGuider {
    
    [request requestUrl:kGJGRequestUrl(kApiGetPromotionsByGuide)
            requestType:RequestGetType
             parameters:@{@"guideId" : [NSNumber numberWithInteger:self.guider.UserId],
                          @"page" : @1}
           requestblock:^(id responseobject, NSError *error)
     {
          if (!error) {
              if ([responseobject[@"status"] isEqualToNumber:@0]) {//    NSLog(@"lb_guiderHome_infos:%@", responseobject);
                  if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                      page = 2;
                      [self.dataSource removeAllObjects];
                      [self.dataSource addObjectsFromArray:[LBGuideInfoM objectsWithArray:responseobject[@"data"]]];
                      [mainTableView reloadData];
                      if (self.dataSource.count < 10) {
                          [mainTableView.mj_footer endRefreshingWithNoMoreData];
                      }else {
                          [mainTableView.mj_footer endRefreshing];
                      }
                  }
              }
          }
     }];
}

- (void)loadMorePromotionsOfGuider {
    
    [request requestUrl:kGJGRequestUrl(kApiGetPromotionsByGuide)
            requestType:RequestGetType
             parameters:@{@"guideId" : [NSNumber numberWithInteger:self.guider.UserId],
                          @"page" : [NSNumber numberWithInteger:page]}
           requestblock:^(id responseobject, NSError *error) {
               if (!error) {
                   if ([responseobject[@"status"] isEqualToNumber:@0]) {//    NSLog(@"lb_guiderHome_infos:%@", responseobject);
                       if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                           page ++;
                           [self.dataSource addObjectsFromArray:[LBGuideInfoM objectsWithArray:responseobject[@"data"]]];
                           [mainTableView reloadData];
                           if (((NSArray *)responseobject[@"data"]).count < 10) {
                               [mainTableView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [mainTableView.mj_footer endRefreshing];
                           }
                       }
                   }
               }
           }];
}


#pragma mark - Create UI

- (void)createUI {
    
    [self createTableView];
    [self createHeaderView];
    [self createBottomBar];
}

- (void)createNavBar {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [titleLabel setText:@"详细资料"];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:COLOR(51, 51, 51, 1)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"title_btn_more"] forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightButton addTarget:self action:@selector(moreItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem= rightItem;
}
- (void)createTableView {
    
    mainTableView = [[UITableView alloc] init];
    mainTableView.contentInset = UIEdgeInsetsMake(178, 0, 49, 0);
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.rowHeight = UITableViewAutomaticDimension;
    mainTableView.estimatedRowHeight = 44.f;
    [mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopGuideTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"ShopGuideTableViewCell"];
    [self.view addSubview:mainTableView];
    [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.top.and.right.equalTo(self.view).with.offset(0);
    }];
    mainTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self loadMorePromotionsOfGuider];
    }];
}
- (void)createHeaderView {
    
    // <1> headerBG
    headerBGImgView = [[UIImageView alloc] init];
    [headerBGImgView sd_setImageWithURL:[NSURL URLWithString:self.guider.HeadPortrait]
                       placeholderImage:[UIImage imageNamed:@"image_four"]];
    [headerBGImgView setContentMode:UIViewContentModeScaleAspectFill];
    headerBGImgView.clipsToBounds = YES;
    headerBGImgView.frame = CGRectMake(0, -178, ScreenWidth, 178);
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [headerBGImgView addSubview:visualEffectView];
    [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.and.right.equalTo(headerBGImgView).with.offset(0);
    }];
    
    UIView *bgAlphaView = [[UIView alloc] init];
    [bgAlphaView setBackgroundColor:[UIColor darkGrayColor]];
    [bgAlphaView setAlpha:0.25f];
    [headerBGImgView addSubview:bgAlphaView];
    [bgAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.and.right.equalTo(headerBGImgView).with.offset(0);
    }];
    
    [mainTableView addSubview:headerBGImgView];
    
    // <2> headerView
    headerViewHolder = [[UIView alloc] init];
    headerViewHolder.backgroundColor = [UIColor clearColor];
    
    iconView = [[UIImageView alloc] init];
    iconView.userInteractionEnabled = YES;
    [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.guider.HeadPortrait]
                placeholderImage:[UIImage imageNamed:@"image_four"]];
    CGFloat iconW = 75;
    iconView.layer.cornerRadius = iconW * 0.5;
    iconView.layer.masksToBounds = YES;
    [headerViewHolder addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headerViewHolder.mas_left).with.offset(15);
        make.bottom.equalTo(headerViewHolder.mas_bottom).with.offset(-25);
        make.width.and.height.mas_equalTo(iconW);
    }];
    
    nameLabel = [[UILabel alloc] init];
    [nameLabel setText:self.guider.UserName ? self.guider.UserName : @""];
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [headerViewHolder addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconView.mas_top).with.offset(0);
        make.left.equalTo(iconView.mas_right).with.offset(12);
        make.height.mas_equalTo(@20);
    }];
    
    lvlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lvlButton setAdjustsImageWhenDisabled:NO];
    [lvlButton setAdjustsImageWhenHighlighted:NO];
    [lvlButton setBackgroundImage:[UIImage imageNamed:@"lavel_bg"] forState:UIControlStateNormal];
    [lvlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvlButton.titleLabel setFont:[UIFont fontWithName:@"Palatino-Bold" size:11]];
    lvlButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [lvlButton setTitle:[NSString stringWithFormat:@"V%lu", self.guider.UserLevel] forState:UIControlStateNormal];
    [headerViewHolder addSubview:lvlButton];
    [lvlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).with.offset(13);
        make.left.equalTo(iconView.mas_right).with.offset(14);
        make.width.mas_equalTo(@22);
        make.height.mas_equalTo(@12);
    }];
    
    lvlNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lvlNameButton.hidden = YES;
    [lvlNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvlNameButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [lvlNameButton setTitle:self.guider.UserLevelName forState:UIControlStateNormal];
    [headerViewHolder addSubview:lvlNameButton];
    [lvlNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).with.offset(13);
        make.left.equalTo(lvlButton.mas_right).with.offset(5);
        make.height.mas_equalTo(@12);
    }];
    
    fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fansButton setTitle:[NSString stringWithFormat:@"%lu关注", fansCountWithoutMe + self.guider.HasFollow]
                forState:UIControlStateNormal];
    fansButton.adjustsImageWhenHighlighted = NO;
    fansButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [fansButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [fansButton setImage:[UIImage imageNamed:@"focus_white_disabled"] forState:UIControlStateNormal];
    fansButton.imageView.tintColor = [UIColor whiteColor];
    [fansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fansButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [headerViewHolder addSubview:fansButton];
    [fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconView.mas_right).with.offset(24);
        make.top.equalTo(lvlNameButton.mas_bottom).with.offset(12);
        make.height.mas_equalTo(@12);
    }];
    
    headerViewHolder.frame = CGRectMake(0, -178, ScreenWidth, 178);
    [mainTableView addSubview:headerViewHolder];
    
    // <3> header - shop & intro
    serveShopView = [[UIView alloc] init];
    [serveShopView setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serveShopDidClick:)];
    [serveShopView addGestureRecognizer:tap];
    
    UILabel *shopName = [[UILabel alloc] init];
    [shopName setText:self.guider.ShopName ? self.guider.ShopName : @"无"];
    [shopName setBackgroundColor:[UIColor whiteColor]];
    [shopName setFont:[UIFont systemFontOfSize:15]];
    [shopName setTextColor:COLOR(51, 51, 51, 1)];
    [serveShopView addSubview:shopName];
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.bottom.equalTo(serveShopView).with.offset(0);
        make.left.equalTo(serveShopView.mas_left).with.offset(15);
    }];
    
    UIImageView *indImgView = [[UIImageView alloc] init];
    [indImgView setImage:[UIImage imageNamed:@"list_arrow"]];
    [indImgView setContentMode:UIViewContentModeScaleAspectFit];
    [serveShopView addSubview:indImgView];
    [indImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.bottom.equalTo(serveShopView).with.offset(0);
        make.right.equalTo(serveShopView.mas_right).with.offset(-10);
        make.width.mas_equalTo(@5);
    }];
    
    
    headerIntroView = [[UIView alloc] init];
    [headerIntroView setBackgroundColor:COLOR(241, 241, 241, 1)];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR(153, 153, 153, 1)];
    [headerIntroView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(headerIntroView).with.offset(0);
        make.top.equalTo(headerIntroView).with.offset(26);
        make.height.mas_equalTo(@0.5);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.text = @"发布信息";
    [intro setFont:[UIFont systemFontOfSize:12]];
    [intro setTextColor:COLOR(153, 153, 153, 1)];
    [intro setTextAlignment:NSTextAlignmentCenter];
    [intro setBackgroundColor:COLOR(241, 241, 241, 1)];
    [headerIntroView addSubview:intro];
    [intro mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headerIntroView).with.offset(10);
        make.centerX.equalTo(headerIntroView);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@60);
    }];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 76)];
    
    [tableHeaderView addSubview:serveShopView];
    [serveShopView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.top.equalTo(tableHeaderView).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    [tableHeaderView addSubview:headerIntroView];
    [headerIntroView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.bottom.equalTo(tableHeaderView).with.offset(0);
        make.top.mas_equalTo(serveShopView.mas_bottom).with.offset(0);
    }];
    mainTableView.tableHeaderView = tableHeaderView;
}
- (void)createBottomBar {
    
    NSArray *titles = @[@"关注", @"私聊", @"分享"];
    NSArray *imgs = @[@"focus_default", @"chat_default", @"share_default"];
    bottomBar = [GJGBottomToolBar bottomToolBarWithTitles:titles imgs:imgs hightLightImgs:@[@"focus_selected"]];
    bottomBar.delegate = self;
    [[bottomBar.btns firstObject] setSelected:self.guider.HasFollow];
    
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo([NSNumber numberWithDouble:49]);
    }];
}
- (void)bottomToolBarDidSelected:(NSInteger)index title:(NSString *)title {
    
    if ([title isEqualToString:@"关注"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self followOrUnFollow];
        }];
    }else if ([title isEqualToString:@"私聊"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self chat];
        }];
    }else if ([title isEqualToString:@"分享"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self share];
        }];
    }
}

- (void)followOrUnFollow {
    
    static int isRequesing = 0;
    if (isRequesing) {
        return;
    }
    isRequesing = 1;
    NSDictionary *parameters = nil;
    if (self.guider.HasFollow) {
        parameters = @{@"followId" : [NSNumber numberWithInteger:self.guider.UserId],
                       @"cancel" : @"true"};
    }else {
        parameters = @{@"followId" : [NSNumber numberWithInteger:self.guider.UserId]};
    }
    
    [DJXRequest requestWithBlock:kApiFollowGuide
                           param:parameters
                         success:^(id object,NSString *msg)
     {
         self.guider.HasFollow = !self.guider.HasFollow;
         [fansButton setTitle:[NSString stringWithFormat:@"%lu关注", fansCountWithoutMe + self.guider.HasFollow]
                     forState:UIControlStateNormal];
         [[bottomBar.btns firstObject] setSelected:self.guider.HasFollow];
         isRequesing = 0;
         
     } failure:^(id object,NSString *msg) {
         isRequesing = 0;
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:object toView:self.view];
         }
     }];
    
//    [request requestPostTypeWithUrl:kGJGRequestUrl(kApiFollowGuide)
//                         parameters:parameters
//                       requestblock:^(id responseobject, NSError *error)
//     {
//         if (!error) {    //NSLog(@"lb_guider_followOrUnfollow_Respon:%@ status:%d", responseobject, self.guider.HasFollow);
//             if ([[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
//                 self.guider.HasFollow = !self.guider.HasFollow;
//                 [fansButton setTitle:[NSString stringWithFormat:@"%lu关注", fansCountWithoutMe + self.guider.HasFollow]
//                             forState:UIControlStateNormal];
//                 [[bottomBar.btns firstObject] setSelected:self.guider.HasFollow];
//             }else if ([[responseobject objectForKey:@"message"] rangeOfString:@"oken"].location != NSNotFound) {
//                 [self refreshToken];
//             }else {
//                 [MBProgressHUD showError:[responseobject objectForKey:@"message"] toView:self.view];
//             }
//         }else {
//             NSLog(@"lb_follow_guider_fail:%@", error);
//         }
//         isRequesing = 0;
//     }];
}
//- (void)refreshToken {
//    if (![UserDBManager shareManager].RefreshToken) {
//        return;
//    }
//    [request requestUrl:kGJGRequestUrl(kApiUserLongToken)
//            requestType:RequestPostType
//             parameters:@{@"RToken" : [UserDBManager shareManager].RefreshToken}
//           requestblock:^(id responseobject, NSError *error)
//     {
//         if ([responseobject[@"data"] isKindOfClass:[NSDictionary class]]) {
//             NSString *token = [responseobject[@"data"] objectForKey:@"Token"];
//             NSString *rToken = [responseobject[@"data"] objectForKey:@"RefreshToken"];
//             if (token && rToken) {
//                 [[UserDBManager shareManager] updateToken:token refreshToken:rToken];
//             }
//         }
//     }];
//}


- (void)chat {
    
    [[ChatManager shareManager] getConversation:self.guider.ChatUser/*@"ca23ceb97307942fd"*/
                                          title:[NSString stringWithFormat:@"%@-%@",self.guider.UserName,self.guider.ShopName]
                                      headImage:self.guider.HeadPortrait
                                           type:EMConversationTypeChat
                           parentViewController:self];
    if (self.statisticChatOfHome.length) {
        [[GJGStatisticManager sharedManager] statisticByEventID:self.statisticChatOfHome
                                                        andBCID:nil
                                                      andMallID:nil
                                                      andShopID:[NSString stringWithFormat:@"%lu", self.guider.ShopId]
                                                andBusinessType:self.guider.BusinessFormat
                                                      andItemID:[NSString stringWithFormat:@"%lu", self.guider.UserId]
                                                    andItemText:nil
                                                    andOpUserID:[NSString stringWithFormat:@"%lu", self.guider.UserId]];
    }
}

- (void)share {
    [[LBRequestManager sharedManager] getSharedInfoWithInfoId:self.guider.UserId
                                                     infoType:GJGShareInfoTypeIsGuiderDetail
                                                       result:^(id responseobject, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (!error) {
             GJGShareInfo *shareInfo = responseobject;
             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                   title:shareInfo.Title
                                                                imageUrl:shareInfo.Images
                                                                     url:shareInfo.Url
                                                             description:@""
                                                                  infoId:[NSString stringWithFormat:@"%ld", self.guider.UserId]
                                                               shareType:UserGuiderDetailShareType
                                                     presentedController:self
                                                                 success:^(id object, UserShareSns sns)
              {
                  NSLog(@"分享成功.");
              } failure:^(id object, UserShareSns sns) {
                  NSLog(@"分享失败.");
              }];
//             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
//                                                                   title:shareInfo.Title
//                                                                imageUrl:shareInfo.Images
//                                                                     url:shareInfo.Url
//                                                             description:@""
//                                                     presentedController:self
//                                                                 success:^(id object, UserShareSns sns)
//              {
//                  [DJXRequest requestWithBlock:kApiShareSuccess
//                                         param:@{@"InfoId" : @(self.guider.UserId),
//                                                 @"infoType" : @(GJGShareInfoTypeIsGuiderDetail),
//                                                 @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]}
//                                       success:^(id object)
//                   {
//                       if ([object isKindOfClass:[NSString class]]) {
//                           [MBProgressHUD showSuccess:object toView:self.view];
//                       }
//                       NSLog(@"记录分享行为成功.");
//                   }
//                                        failure:^(id object){}];
//              } failure:^(id object, UserShareSns sns){}];
         }else {
             [MBProgressHUD showError:@"获取分享内容失败, 请检查网络." toView:self.view];
         }
     }];
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
    cell.type = ShopGuideCellTypeIsGuideHome;
    cell.guideInfo = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopGuideDetailViewController *detailVC = [[ShopGuideDetailViewController alloc] init];
    detailVC.infoid = [self.dataSource objectAtIndex:indexPath.row].InfoId;
    detailVC.statisticSendMsg = ID_0201030130002;
    detailVC.statisticLike = ID_0201030110003;
    detailVC.statisticShare = ID_0201030120004;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetY = scrollView.contentOffset.y;
    
    if (offSetY < -150) {
        CGRect frame = headerBGImgView.frame;
        frame.origin.y = offSetY;
        frame.size.height = -offSetY;
        headerBGImgView.frame = frame;
    }
}


#pragma mark - Click event

- (void)showImage:(UITapGestureRecognizer *)imgTap {
    [AvatarBrowser showImage:(UIImageView *)imgTap.view];
}

- (void)moreItemDidClick:(id)sender {
    NSLog(@"more!");
}

- (void)serveShopDidClick:(id)sender {
    
    NSString *typeKey = self.guider.BusinessFormat;
    NSString *shopName = self.guider.ShopName;
    NSString *shopId = [NSString stringWithFormat:@"%lu", self.guider.ShopId];
    
    if ([typeKey isEqualToString:@"supermarket"]) {//超市    ②③
        GeneralMarketController *controller = [[GeneralMarketController alloc] init];
        controller.title = shopName;
        controller.shopId = shopId;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([typeKey isEqualToString:@"cafe"] ||
              [typeKey isEqualToString:@"hotel"] ||
              [typeKey isEqualToString:@"ktv"] ||
              [typeKey isEqualToString:@"restaurant"]){//咖啡店、酒店、KTV、美食  ①②
        RestaurantClassController *controller = [[RestaurantClassController alloc] init];
        controller.title = shopName;
        controller.shopId = shopId;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{//影院、亲子、甜点饮品、美业、酒吧、健身、培训、足疗按摩、宠物店 ②
        //        SpecialtyStoreClassController *controller = [[SpecialtyStoreClassController alloc] init];
        FilmClassController *controller = [[FilmClassController alloc] init];
        controller.title = shopName;
        controller.shopId = shopId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
