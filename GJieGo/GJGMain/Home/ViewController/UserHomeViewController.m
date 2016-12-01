//
//  UserHomeViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define HeaderViewHeight 178.f

#import "UserHomeViewController.h"
#import "ShopGuideDetailViewController.h"
#import "SharedOrderDetailViewController.h"
#import "SharedOrderInMainCell.h"
#import "LBSharedOrderM.h"
#import "LBUserM.h"
#import "GJGBottomToolBar.h"
#import "AppMacro.h"
#import "AvatarBrowser.h"

@interface UserHomeViewController ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
GJGBottomToolBarDelegate> {
    
    UIView *statusBackView;
    UICollectionView *collectionView;
    
    UIView *headerViewHolder;
    UIImageView *iconView;
    UILabel *nameLabel;
    UIButton *fansButton;
    NSInteger fansCountWithoutMe;
    UIButton *lvlButton;
    UIButton *lvlNameButton;
    UILabel *addressLabel;
    
    UIImageView *headerBGImgView;
    UIVisualEffectView *visualEffectView;
    
    GJGBottomToolBar *bottomBar;
    
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray<LBSharedOrderM *> *sharedOrderDataSource;
@property (nonatomic, strong) LBUserM *userDetail;
@end


@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self updateUserDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
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

- (NSMutableArray *)sharedOrderDataSource {
    
    if (!_sharedOrderDataSource) {
        
        _sharedOrderDataSource = [NSMutableArray array];
    }
    return _sharedOrderDataSource;
}


#pragma mark - update 

- (void)updateUserDetail {
    
    
    [request requestUrl:kGJGRequestUrl(kApiGetUserDetail)
            requestType:RequestGetType
             parameters:@{@"userId" : [NSNumber numberWithInteger:self.userId]}
           requestblock:^(id responseobject, NSError *error) {
               if (!error) {
                   if ([responseobject[@"status"] isEqualToNumber:@0]) {
                       if ([responseobject[@"data"] isKindOfClass:[NSDictionary class]]) {
                           self.userDetail = [LBUserM modelWithDict:responseobject[@"data"]];
                           fansCountWithoutMe = self.userDetail.FollowNum - self.userDetail.HasFollow;
                           [self createUI];
                           [self loadSharedOrdersOfUser];
                       }
                   }
               }else {
                   GJGLog(@"lb_userHome_detail_fail:%@", error);
               }
           }];
}

- (void)loadSharedOrdersOfUser {
    
    [request requestUrl:kGJGRequestUrl(kApiGetUser_UserShows)
            requestType:RequestGetType
             parameters:@{@"userId" : [NSNumber numberWithInteger:self.userId],
                          @"page"   : @1}
           requestblock:^(id responseobject, NSError *error) {
               if (!error) {
                   if ([responseobject[@"status"] isEqualToNumber:@0]) {
                       if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                           page = 2;
                           [self.sharedOrderDataSource removeAllObjects];
                           [self.sharedOrderDataSource addObjectsFromArray:[LBSharedOrderM objectsWithArray:responseobject[@"data"]]];
                           [collectionView reloadData];
                           if (self.sharedOrderDataSource.count < 20) {
                               [collectionView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [collectionView.mj_footer endRefreshing];
                           }
                       }
                   }
               }else {
                   GJGLog(@"lb_guiderHome_detail_fail:%@", error);
               }
           }];
}
- (void)loadMoreSharedOrdersOfUser {
    
    [request requestUrl:kGJGRequestUrl(kApiGetUser_UserShows)
            requestType:RequestGetType
             parameters:@{@"userId" : [NSNumber numberWithInteger:self.userId],
                          @"page"   : [NSNumber numberWithInteger:page]}
           requestblock:^(id responseobject, NSError *error) {
               if (!error) {
                   if ([responseobject[@"status"] isEqualToNumber:@0]) {
                       if ([responseobject[@"data"] isKindOfClass:[NSArray class]]) {
                           page ++;
                           [self.sharedOrderDataSource addObjectsFromArray:[LBSharedOrderM objectsWithArray:responseobject[@"data"]]];
                           [collectionView reloadData];
                           if (((NSArray *)responseobject[@"data"]).count < 20) {
                               [collectionView.mj_footer endRefreshingWithNoMoreData];
                           }else {
                               [collectionView.mj_footer endRefreshing];
                           }
                       }
                   }
               }else {
                   GJGLog(@"lb_guiderHome_detail_fail:%@", error);
               }
           }];
}


#pragma mark - Init

- (void)initAttributes {
    
    page = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    [self createNavBar];
}

- (void)createUI {
    
    [self createCollectionView];
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
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:[SharedOrderInMainCell class]
       forCellWithReuseIdentifier:@"SharedOrderInMainCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(HeaderViewHeight, 0, 49, 0);
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    collectionView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self loadMoreSharedOrdersOfUser];
    }];
}

- (void)createHeaderView {
    
    // <1> headerBG
    headerBGImgView = [[UIImageView alloc] init];
    [headerBGImgView sd_setImageWithURL:[NSURL URLWithString:self.userDetail.HeadPortrait]
                       placeholderImage:[UIImage imageNamed:@"image_four"]];
    [headerBGImgView setContentMode:UIViewContentModeScaleToFill];
    headerBGImgView.clipsToBounds = YES;
    headerBGImgView.frame = CGRectMake(0, -HeaderViewHeight, ScreenWidth, HeaderViewHeight);
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, HeaderViewHeight);
    [headerBGImgView addSubview:visualEffectView];
//    [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.left.bottom.and.right.equalTo(headerBGImgView).with.offset(0);
//    }];
    
//    UIView *bgAlphaView = [[UIView alloc] init];
//    [bgAlphaView setBackgroundColor:[UIColor darkGrayColor]];
//    [bgAlphaView setAlpha:0.25f];
//    [headerBGImgView addSubview:bgAlphaView];
//    [bgAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.left.bottom.and.right.equalTo(headerBGImgView).with.offset(0);
//    }];
    
    [collectionView addSubview:headerBGImgView];
    
    // <2> headerView
    headerViewHolder = [[UIView alloc] init];
    headerViewHolder.backgroundColor = [UIColor clearColor];
    
    iconView = [[UIImageView alloc] init];
    iconView.userInteractionEnabled = YES;
    [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.userDetail.HeadPortrait]
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
    nameLabel.text = self.userDetail.UserName;
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [headerViewHolder addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconView.mas_top).with.offset(0);
        make.left.equalTo(iconView.mas_right).with.offset(13);
        make.height.mas_equalTo(@20);
    }];
    
    fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fansButton setTitle:[NSString stringWithFormat:@"%lu关注", fansCountWithoutMe + self.userDetail.HasFollow]
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
        
        make.left.equalTo(iconView.mas_right).with.offset(13);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(12);
        make.height.mas_equalTo(@12);
    }];
    
    lvlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lvlButton setAdjustsImageWhenDisabled:NO];
    [lvlButton setAdjustsImageWhenHighlighted:NO];
    [lvlButton setBackgroundImage:[UIImage imageNamed:@"lavel_bg"] forState:UIControlStateNormal];
    [lvlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvlButton.titleLabel setFont:[UIFont fontWithName:@"Palatino-Bold" size:11]];
    lvlButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [lvlButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, -1, 0)];
    [lvlButton setTitle:[NSString stringWithFormat:@"V%lu", self.userDetail.UserLevel] forState:UIControlStateNormal];
    [headerViewHolder addSubview:lvlButton];
    [lvlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(fansButton.mas_right).with.offset(20);
        make.centerY.equalTo(fansButton.mas_centerY).with.offset(0);
        make.width.mas_equalTo(@22);
        make.height.mas_equalTo(@12);
    }];
    
    lvlNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lvlNameButton.hidden = YES;
    [lvlNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvlNameButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [lvlNameButton setTitle:self.userDetail.UserLevelName forState:UIControlStateNormal];
    [headerViewHolder addSubview:lvlNameButton];
    [lvlNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(lvlButton.centerY).with.offset(0);
        make.left.equalTo(lvlButton.mas_right).with.offset(5);
        make.height.mas_equalTo(@12);
    }];
    
//    addressLabel = [[UILabel alloc] init];      addressLabel.text = @"地址：东城区广渠门内大街121号";
//    [addressLabel setFont:[UIFont systemFontOfSize:12]];
//    [addressLabel setTextColor:[UIColor whiteColor]];
//    [headerViewHolder addSubview:addressLabel];
//    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(iconView.mas_right).with.offset(13);
//        make.top.equalTo(fansButton.mas_bottom).with.offset(13);
//    }];
    
    headerViewHolder.frame = CGRectMake(0, -HeaderViewHeight, ScreenWidth, HeaderViewHeight);
    [collectionView addSubview:headerViewHolder];
}

- (void)createBottomBar {
    
    NSArray *titles = @[@"关注", @"分享"];
    NSArray *imgs = @[@"focus_default", @"share_default"];
    bottomBar = [GJGBottomToolBar bottomToolBarWithTitles:titles imgs:imgs hightLightImgs:@[@"focus_selected"]];
    [bottomBar.btns firstObject].selected = self.userDetail.HasFollow;
    [bottomBar.btns firstObject].enabled = !([UserDBManager shareManager].UserID.integerValue == self.userId);
//    NSLog(@"lb_log:本地用户id:%ld, 用户中心id:%ld %d", [UserDBManager shareManager].UserID.integerValue, self.userId, !([UserDBManager shareManager].UserID.integerValue == self.userId));
    bottomBar.delegate = self;
    
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
    if (self.userDetail.HasFollow) {
        parameters = @{@"followId" : [NSNumber numberWithInteger:self.userDetail.UserId],
                        @"cancel" : @"true"};
    }else {
        parameters = @{@"followId" : [NSNumber numberWithInteger:self.userDetail.UserId]};
    }
    [DJXRequest requestWithBlock:kApiFollowUser
                           param:parameters
                         success:^(id object,NSString *msg)
     {
         self.userDetail.HasFollow = !self.userDetail.HasFollow;
         [fansButton setTitle:[NSString stringWithFormat:@"%lu关注", fansCountWithoutMe + self.userDetail.HasFollow]
                     forState:UIControlStateNormal];
         [[bottomBar.btns firstObject] setSelected:self.userDetail.HasFollow];
         isRequesing = 0;
         
     } failure:^(id object,NSString *msg) {
         isRequesing = 0;
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:object toView:self.view];
         }
     }];
}

- (void)share {
    [[LBRequestManager sharedManager] getSharedInfoWithInfoId:self.userDetail.UserId
                                                     infoType:GJGShareInfoTypeIsUserDetail
                                                       result:^(id responseobject, NSError *error)
     {
         if (!error) {
             GJGShareInfo *shareInfo = responseobject;
             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                   title:shareInfo.Title
                                                                imageUrl:shareInfo.Images
                                                                     url:shareInfo.Url
                                                             description:@""
                                                                  infoId:[NSString stringWithFormat:@"%ld", self.userDetail.UserId]
                                                               shareType:UserUserDetailShareType
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
//                                         param:@{@"InfoId" : @(self.userDetail.UserId),
//                                                 @"infoType" : @(GJGShareInfoTypeIsUserDetail),
//                                                 @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]}
//                                       success:^(id object)
//                   {
//                       if ([object isKindOfClass:[NSString class]]) {
//                           [MBProgressHUD showSuccess:object toView:self.view];
//                       }
//                      NSLog(@"记录分享行为成功.");
//                   }
//                                failure:^(id object){}];
//              } failure:^(id object, UserShareSns sns){}];
         }else {
             [MBProgressHUD showError:@"获取分享内容失败, 请检查网络." toView:self.view];
         }
     }];
}


#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.sharedOrderDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionV
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SharedOrderInMainCell *cell = [SharedOrderInMainCell cellWithCollectionView:collectionV
                                                                   andIndexPath:indexPath];
    cell.sharedOrderType = SharedOrderCellTypeIsUserHome;
    cell.sharedOrder = self.sharedOrderDataSource[indexPath.row];
    return cell;
    
}

#pragma mark - Collection view flow layout delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SharedOrderDetailViewController *detailVC = [[SharedOrderDetailViewController alloc] init];
    detailVC.infoId = self.sharedOrderDataSource[indexPath.row].Id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return [SharedOrderInMainCell getEdgeInsets];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [SharedOrderInMainCell getSizeWithType:SharedOrderCellTypeIsUserHome];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetY = scrollView.contentOffset.y;
    static CGFloat lastY;
    if (offSetY < 0) {
        if (fabs(lastY - offSetY) > 1) {
            lastY = offSetY;
            CGRect frame = headerBGImgView.frame;
            frame.origin.y = offSetY;
            frame.size.height = -offSetY - 10;
            headerBGImgView.frame = frame;
            visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, -offSetY);
        }
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
    GJGLog(@"click shop !");
}

@end
