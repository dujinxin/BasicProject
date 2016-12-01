//
//  SharedOrderDetailViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/9.
//  Copyright © 2016年 yangzx. All rights reserved.
//


#import "SharedOrderDetailViewController.h"
#import "ShopGuideTableViewCell.h"
#import "DetailMsgTableViewCell.h"
#import "LBSharedOrderDetailM.h"
#import "LBMsgM.h"
#import "LBCycleScrollView.h"
#import "GJGBottomToolBar.h"
#import "JZAlbumViewController.h"
#import "AppMacro.h"

#define CommentViewHeigth 46.f

#define TextViewVerticalMargin 6.f
#define TextViewLeftMargin 20.f
#define TextViewRightMargin -64.f

#define TextViewHolderViewHorMargin 6.f
#define TextViewHolderViewVerMargin 8.f

@interface SharedOrderDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
GJGBottomToolBarDelegate,
UITextViewDelegate> {
    
    UITableView *detailTableView;
    UIView *statusBackView;
    
    UIView *headerViewHolder;
    LBCycleScrollView *cycleScrollView;
    UIView *labelViewHolder;
    
    UILabel *goodsLabel;
    UILabel *brandLabel;
    UILabel *priceLabel;
    UILabel *buyPlaceLabel;
    NSMutableArray *detailLabelTitles;
    
    GJGBottomToolBar *bottomBar;
    
    UITextView *textView;
    UILabel *textViewHolder;
    NSString *textViewHolderString;
    
    UIView *soAlphaView;
    
    CGFloat keyboardHeight;
    CGFloat textViewBaseContentHeight;
    
    NSInteger page;
    NSInteger commentIndex;
}

@property (nonatomic, strong) LBSharedOrderDetailM *sharedOrderDetail;
@property (nonatomic, strong) NSMutableArray<LBMsgM *> *commentDataSource;

@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIView *labelsDetailView;
@property (nonatomic, weak) id answerer;
@property (nonatomic, assign, getter=isAnswerToOthers) BOOL answerToOthers;

@end

@implementation SharedOrderDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initAttributes];
    [self updateDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:COLOR(254, 227, 48, 1)];
    [self.navigationController.navigationBar addSubview:statusBackView];
//    [detailTableView setContentOffset:CGPointMake(0, -64) animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [statusBackView removeFromSuperview];
    [self hiddenCommentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - Lazy

- (UIView *)commentView {
    
    if (!_commentView) {
        
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, CommentViewHeigth)];
        [_commentView setBackgroundColor:COLOR(241, 241, 241, 1)];
        
        textView = [[UITextView alloc] init];
        [textView setDelegate:self];
        [textView.layer setCornerRadius:4.f];
        [textView.layer setMasksToBounds:YES];
        [textView setFont:[UIFont systemFontOfSize:15]];
        [textView setBackgroundColor:[UIColor whiteColor]];
        [textView setShowsVerticalScrollIndicator:NO];
        [textView setBounces:NO];
        textViewHolder = [[UILabel alloc] init];
        [textViewHolder setFont:[UIFont systemFontOfSize:15]];
        [textViewHolder setTextColor:COLOR(153, 153, 153, 1)];
        [textView addSubview:textViewHolder];
        [textViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(textView).with.offset(TextViewHolderViewVerMargin);
            make.left.equalTo(textView).with.offset(TextViewHolderViewHorMargin);
        }];
        
        [_commentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_commentView).with.offset(TextViewVerticalMargin-1);
            make.left.equalTo(_commentView.left).with.offset(TextViewLeftMargin);
            make.bottom.equalTo(_commentView).with.offset(-TextViewVerticalMargin);
            make.right.equalTo(_commentView.right).with.offset(TextViewRightMargin);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(sendClick)
         forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5.f;
        button.layer.masksToBounds = YES;
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setBackgroundColor:GJGRGB16Color(0x688de3)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_commentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_commentView.mas_right).with.offset(-10);
            make.centerY.equalTo(_commentView.mas_centerY).with.offset(0);
            make.height.mas_equalTo(@34);
            make.width.mas_equalTo(@44);
        }];
        
        textViewBaseContentHeight = 36.f;
        [self.view addSubview:_commentView];
    }
    return _commentView;
}

- (UIView *)labelsDetailView {
    
    if (!_labelsDetailView) {
        
        CGFloat mag = 16.f;
        CGFloat height = 44.f;
        CGFloat corW = height * 0.5;
        CGFloat font = 14;
        CGFloat borderW = 1.f;
        CGFloat topMag = kScreenHeight * 0.5 - (detailLabelTitles.count * height + (detailLabelTitles.count - 1) * mag) * 0.5;
        
        _labelsDetailView = [[UIView alloc] init];
        _labelsDetailView.backgroundColor = GJGRGBAColor(0, 0, 0, 0.86);
        _labelsDetailView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offLabelsView)];
        [_labelsDetailView addGestureRecognizer:tap];
        
        for (int i = 0; i < detailLabelTitles.count; i ++) {
            
            UILabel *detailLabel = [[UILabel alloc] init];
            detailLabel.text = detailLabelTitles[i];
            detailLabel.textAlignment = NSTextAlignmentCenter;
            detailLabel.font = [UIFont systemFontOfSize:font];
            detailLabel.textColor = [UIColor whiteColor];
            detailLabel.layer.cornerRadius = corW;
            detailLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            detailLabel.layer.borderWidth = borderW;
            [_labelsDetailView addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_labelsDetailView.mas_left).with.offset(mag);
                make.right.equalTo(_labelsDetailView.mas_right).with.offset(-mag);
                make.height.mas_equalTo(height);
                CGFloat labelTopMag = topMag + i * (height + mag);
                make.top.equalTo(_labelsDetailView.mas_top).with.offset(@(labelTopMag));
//                make.bottom.equalTo(_labelsDetailView.centerY).with.offset(-(height + mag * 1.5));
            }];
        }
        
//        goodsLabel = [[UILabel alloc] init];
//        goodsLabel.text = [NSString stringWithFormat:@"商品名: %@", self.sharedOrderDetail.ProductName.length > 0 ? self.sharedOrderDetail.ProductName : @" "];
//        goodsLabel.textAlignment = NSTextAlignmentCenter;
//        goodsLabel.font = [UIFont systemFontOfSize:font];
//        goodsLabel.textColor = [UIColor whiteColor];
//        goodsLabel.layer.cornerRadius = corW;
//        goodsLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//        goodsLabel.layer.borderWidth = borderW;
//        [_labelsDetailView addSubview:goodsLabel];
//        [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.equalTo(_labelsDetailView.mas_left).with.offset(mag);
//            make.right.equalTo(_labelsDetailView.mas_right).with.offset(-mag);
//            make.height.mas_equalTo(height);
//            make.bottom.equalTo(_labelsDetailView.centerY).with.offset(-(height + mag * 1.5));
//        }];
//        
//        brandLabel = [[UILabel alloc] init];
//        brandLabel.text = [NSString stringWithFormat:@"品牌: %@", self.sharedOrderDetail.Brand.length > 0 ? self.sharedOrderDetail.Brand : @" "];
//        brandLabel.textAlignment = NSTextAlignmentCenter;
//        brandLabel.font = [UIFont systemFontOfSize:font];
//        brandLabel.textColor = [UIColor whiteColor];
//        brandLabel.layer.cornerRadius = corW;
//        brandLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//        brandLabel.layer.borderWidth = borderW;
//        [_labelsDetailView addSubview:brandLabel];
//        [brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(_labelsDetailView.mas_left).with.offset(mag);
//            make.right.equalTo(_labelsDetailView.mas_right).with.offset(-mag);
//            make.height.mas_equalTo(height);
//            make.bottom.equalTo(_labelsDetailView.centerY).with.offset(-(mag * 0.5));
//        }];
//        
//        priceLabel = [[UILabel alloc] init];
//        priceLabel.text = [NSString stringWithFormat:@"价格: %lu", self.sharedOrderDetail.Price >=0 ? self.sharedOrderDetail.Price : 0];
//        priceLabel.textAlignment = NSTextAlignmentCenter;
//        priceLabel.font = [UIFont systemFontOfSize:font];
//        priceLabel.textColor = [UIColor whiteColor];
//        priceLabel.layer.cornerRadius = corW;
//        priceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//        priceLabel.layer.borderWidth = borderW;
//        [_labelsDetailView addSubview:priceLabel];
//        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(_labelsDetailView.mas_left).with.offset(mag);
//            make.right.equalTo(_labelsDetailView.mas_right).with.offset(-mag);
//            make.height.mas_equalTo(height);
//            make.top.equalTo(_labelsDetailView.centerY).with.offset((mag * 0.5));
//        }];
//        
//        buyPlaceLabel = [[UILabel alloc] init];
//        buyPlaceLabel.text = [NSString stringWithFormat:@"购买地: %@", self.sharedOrderDetail.BuyFrom.length > 0 ? self.sharedOrderDetail.BuyFrom : @" "];
//        buyPlaceLabel.textAlignment = NSTextAlignmentCenter;
//        buyPlaceLabel.font = [UIFont systemFontOfSize:font];
//        buyPlaceLabel.textColor = [UIColor whiteColor];
//        buyPlaceLabel.layer.cornerRadius = corW;
//        buyPlaceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
//        buyPlaceLabel.layer.borderWidth = borderW;
//        [_labelsDetailView addSubview:buyPlaceLabel];
//        [buyPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(_labelsDetailView.mas_left).with.offset(mag);
//            make.right.equalTo(_labelsDetailView.mas_right).with.offset(-mag);
//            make.height.mas_equalTo(height);
//            make.top.equalTo(_labelsDetailView.centerY).with.offset((height + mag * 1.5));
//        }];
    }
    return _labelsDetailView;
}

- (NSMutableArray<LBMsgM *> *)commentDataSource {
    
    if (!_commentDataSource) {
        
        _commentDataSource = [NSMutableArray array];
    }
    return _commentDataSource;
}


#pragma mark - Init

- (void)initAttributes {
    
    page = 1;
    commentIndex = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
    
    UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorImage = img;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = img;
    
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    statusBackView.backgroundColor = COLOR(254, 227, 48, 1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self createNav];
}


#pragma mark - Updata

- (void)updateDetail {
    
    [DJXRequest requestWithBlock:kApiGetUserShowDetail
                           param:@{@"infoId" : [NSNumber numberWithInteger:self.infoId]}
                         success:^(id object,NSString * msg)
    {
        if ([object isKindOfClass:[NSDictionary class]]) {
            self.sharedOrderDetail = [LBSharedOrderDetailM modelWithDict:object];
            NSLog(@"%@", object);
            [self createUI];
            [self updateMsg:NO];
        }else {
            [self createNullNote];
        }
    } failure:^(id object,NSString * msg) {
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
//    [request requestUrl:kGJGRequestUrl(kApiGetUserShowDetail)
//            requestType:RequestGetType
//             parameters:@{@"infoId" : [NSNumber numberWithInteger:self.infoId]}
//           requestblock:^(id responseobject, NSError *error) {
//               if (!error) {
//                   if ([responseobject isKindOfClass:[NSDictionary class]] && [[responseobject objectForKey:@"status"] isEqualToNumber:@0]) {
//                       NSLog(@"lb_userShow_detail:%@", responseobject);
//                       if ([responseobject[@"data"] isKindOfClass:[NSDictionary class]]) {
//                           
//                           self.sharedOrderDetail = [LBSharedOrderDetailM modelWithDict:responseobject[@"data"]];
//                           [self createUI];
//                           [self updateMsg];
//                       }
//                   }
//               }else {
//                   NSLog(@"lb_request fail:%@",error);
//               }
//           }];
}

- (void)updateMsg:(BOOL)needScroll {
    
    [DJXRequest requestWithBlock:kApiGetUserShowComments
                           param:@{@"infoId" : [NSNumber numberWithInteger:self.infoId],
                                   @"page"   : @1}
                         success:^(id object,NSString * msg)
    {
        if ([object isKindOfClass:[NSArray class]]) {
            page = 2;
            [self.commentDataSource removeAllObjects];
            [self.commentDataSource addObjectsFromArray:[LBMsgM objectsWithArray:object]];
            [detailTableView reloadData];
            [detailTableView.mj_footer endRefreshing];
        }else {
            [detailTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (needScroll) {
            [detailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentDataSource.count ? 1 : 0 inSection:0]
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:YES];
        }
    } failure:^(id object,NSString * msg) {
        [detailTableView.mj_footer endRefreshing];
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)updateMoreMsg {
    
    [DJXRequest requestWithBlock:kApiGetUserShowComments
                           param:@{@"infoId" : [NSNumber numberWithInteger:self.infoId],
                                   @"page"   : [NSNumber numberWithInteger:page]}
                         success:^(id object,NSString * msg)
     {
         if ([object isKindOfClass:[NSArray class]]) {
             page ++;
             NSArray *msgs = [LBMsgM objectsWithArray:object];
             [self.commentDataSource addObjectsFromArray:msgs];
             [detailTableView reloadData];
             [detailTableView.mj_footer endRefreshing];
         }else {
             [detailTableView.mj_footer endRefreshingWithNoMoreData];
         }
     } failure:^(id object,NSString * msg) {
         [detailTableView.mj_footer endRefreshing];
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
}

- (void)createNullNote {
    
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
    UIImageView *nullImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cry"]];
    [self.view addSubview:nullImg];
    [nullImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(61 + 64);
    }];
}

- (void)createUI {
    
    [self createDetailTableView];
    [self createTableHeaderView];
    [self createBottomBar];
    [self commentView];
}

- (void)createNav {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [titleLabel setText:@"详情"];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:COLOR(51, 51, 51, 1)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)createDetailTableView {
    
    detailTableView = [[UITableView alloc] init];
    detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    detailTableView.backgroundColor = [UIColor clearColor];
    detailTableView.showsVerticalScrollIndicator = NO;
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.rowHeight = UITableViewAutomaticDimension;
    detailTableView.estimatedRowHeight = 44.f;
    [detailTableView registerClass:[DetailMsgTableViewCell class] forCellReuseIdentifier:@"DetailMsgTableViewCell"];
    [detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopGuideTableViewCell class])
                                                bundle:nil]
          forCellReuseIdentifier:@"ShopGuideTableViewCell"];
    [self.view addSubview:detailTableView];
    [detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(64);
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    detailTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self updateMoreMsg];
    }];
}

- (void)createTableHeaderView {
    
    CGFloat cycleViewH = ScreenWidth * 1.08;
    CGFloat labelH = 39;
    
    headerViewHolder = [[UIView alloc] init];
    
    __weak __typeof(&*self)weakSelf =self;
    
    cycleScrollView = [LBCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                     isAutoSwitch:YES
                                                     timeInterval:2.3f
                                                       isUseLabel:NO
                                                       clickBlick:^(NSInteger index)
    {
        JZAlbumViewController *imgVC = [[JZAlbumViewController alloc] init];
        imgVC.currentIndex = index;
        imgVC.imgArr = self.sharedOrderDetail.Images;
        [weakSelf presentViewController:imgVC animated:YES completion:nil];
        NSLog(@"click %lu cycle img.", index);
    }];
    [cycleScrollView lb_setDataSource:self.sharedOrderDetail.Images labelDataSource:nil type:LBCycleScrollViewDataSourceTypeUrl];
    [headerViewHolder addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.and.right.equalTo(headerViewHolder).with.offset(0);
        make.height.mas_equalTo(cycleViewH);
    }];
    
    
    labelViewHolder = [[UIView alloc] init];
    UITapGestureRecognizer *labelViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelsClick)];
    labelViewHolder.userInteractionEnabled = YES;
    [labelViewHolder addGestureRecognizer:labelViewTap];
    [labelViewHolder setBackgroundColor:[UIColor whiteColor]];
    
    detailLabelTitles = [NSMutableArray array];
    NSMutableArray *labelTitles = [NSMutableArray array];
    if (self.sharedOrderDetail.ProductName && self.sharedOrderDetail.ProductName.length > 0) {
        [labelTitles addObject:self.sharedOrderDetail.ProductName];
        [detailLabelTitles addObject:[NSString stringWithFormat:@"商品名：%@", self.sharedOrderDetail.ProductName]];
    }
    if (self.sharedOrderDetail.Brand && self.sharedOrderDetail.Brand.length > 0) {
        [labelTitles addObject:self.sharedOrderDetail.Brand];
        [detailLabelTitles addObject:[NSString stringWithFormat:@"品牌：%@", self.sharedOrderDetail.Brand]];
    }
    if (self.sharedOrderDetail.Price && self.sharedOrderDetail.Price.doubleValue != 0) {
        NSLog(@"晒单获取的价格%@", self.sharedOrderDetail.Price);
        [labelTitles addObject:[NSString stringWithFormat:@"%@", self.sharedOrderDetail.Price]];
        [detailLabelTitles addObject:[NSString stringWithFormat:@"价格：%@", self.sharedOrderDetail.Price]];
    }
    if (self.sharedOrderDetail.BuyFrom && self.sharedOrderDetail.BuyFrom.length > 0) {
        [labelTitles addObject:self.sharedOrderDetail.BuyFrom];
        [detailLabelTitles addObject:[NSString stringWithFormat:@"购买地：%@", self.sharedOrderDetail.BuyFrom]];
    }
    
    if (labelTitles.count == 0) {
        
        [headerViewHolder removeGestureRecognizer:labelViewTap];
        
        detailTableView.tableHeaderView = headerViewHolder;
        detailTableView.tableHeaderView.frame = CGRectMake(0, 0, 0, cycleViewH);
        return;
    }
    
    UIButton *lastBtn;
    static CGFloat labelMag = 15.f;
    CGFloat labelWidth = (ScreenWidth - 75) * 0.25;
    
    for (int i = 0; i < labelTitles.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setUserInteractionEnabled:NO];
        btn.layer.borderWidth = .5f;
        btn.layer.borderColor = GJGBLACKCOLOR.CGColor;
        btn.layer.cornerRadius = 11.5f;
        [btn setTitle:labelTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR(51.f, 51.f, 51.f, 1) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [labelViewHolder addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(labelViewHolder).with.offset(8);
            if (lastBtn) {
                make.left.equalTo(lastBtn.mas_right).with.offset(labelMag);
            }else {
                make.left.equalTo(labelViewHolder.mas_left).with.offset(labelMag);
            }
            make.width.mas_equalTo(labelWidth);
            make.height.mas_equalTo(@23);
        }];
        lastBtn = btn;
    }
    
//    NSArray *pinkLabelTitles = @[self.sharedOrderDetail.ProductName ?
//                                 self.sharedOrderDetail.ProductName : @"",
//                                 self.sharedOrderDetail.BuyFrom ?
//                                 self.sharedOrderDetail.BuyFrom : @""];
//    NSArray *darkLabelTitles = @[self.sharedOrderDetail.Price ?
//                                 [NSString stringWithFormat:@"%lu", self.sharedOrderDetail.Price] : @"无",
//                                self.sharedOrderDetail.Brand ?
//                                 self.sharedOrderDetail.Brand : @"无"];
//    
//    id previousBtn = nil;
//    static CGFloat labelMag = 15.f;
////    static CGFloat titleLeftMag = 16.f;
////    static CGFloat titleRightMag = 7.f;
//    CGFloat labelWidth = (ScreenWidth - 75) * 0.25;
//    
//    for (int i = 0; i < pinkLabelTitles.count; i++) {
//        
////        CGSize size = CGSizeMake(ScreenWidth, 0);//SG_TEXTSIZE(pinkLabelTitles[i], [UIFont systemFontOfSize:12]);
//        
////        UIImage *bgImg = [UIImage imageNamed:@"label_bg_pink"];
////        bgImg = [bgImg stretchableImageWithLeftCapWidth:40 topCapHeight:15];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setUserInteractionEnabled:NO];
//        btn.layer.borderWidth = .5f;
//        btn.layer.borderColor = GJGBLACKCOLOR.CGColor;
//        btn.layer.cornerRadius = 11.5f;
//        [btn setTitle:pinkLabelTitles[i] forState:UIControlStateNormal];
//        [btn setTitleColor:COLOR(51.f, 51.f, 51.f, 1) forState:UIControlStateNormal];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
////        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, titleLeftMag, 0, titleRightMag)];
////        [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
//        [labelViewHolder addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(labelViewHolder).with.offset(8);
//            if (previousBtn != nil) {
//                make.left.equalTo(((UIButton *)previousBtn).right).with.offset(labelMag);
//            }else {
//                make.left.equalTo(labelViewHolder).with.offset(labelMag);
//            }
//            make.width.mas_equalTo(labelWidth);
//            make.height.mas_equalTo(@23);
//        }];
//        previousBtn = btn;
//    }
//    for (int i = 0; i < darkLabelTitles.count; i++) {
//        
////        CGSize size = CGSizeMake(ScreenWidth, 0);//SG_TEXTSIZE(darkLabelTitles[i], [UIFont systemFontOfSize:12]);
//        
////        UIImage *bgImg = [UIImage imageNamed:@"lable_bg_gray"];
////        bgImg = [bgImg stretchableImageWithLeftCapWidth:40 topCapHeight:15];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setUserInteractionEnabled:NO];
//        btn.layer.borderWidth = .5f;
//        btn.layer.borderColor = GJGBLACKCOLOR.CGColor;
//        btn.layer.cornerRadius = 11.5f;
//        [btn setTitle:darkLabelTitles[i] forState:UIControlStateNormal];
//        [btn setTitleColor:COLOR(51.f, 51.f, 51.f, 1) forState:UIControlStateNormal];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
////        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, titleLeftMag, 0, titleRightMag)];
////        [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
//        [labelViewHolder addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(labelViewHolder).with.offset(8);
//            if (previousBtn != nil) {
//                make.left.equalTo(((UIButton *)previousBtn).right).with.offset(labelMag);
//            }else {
//                make.left.equalTo(labelViewHolder).with.offset(labelMag);
//            }
//            make.width.mas_equalTo(labelWidth);
//            make.height.mas_equalTo(@23);
//        }];
//        previousBtn = btn;
//    }
    
    [headerViewHolder addSubview:labelViewHolder];
    [labelViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(headerViewHolder).with.offset(0);
        make.top.equalTo(cycleScrollView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(labelH);
    }];
    
    detailTableView.tableHeaderView = headerViewHolder;
    detailTableView.tableHeaderView.frame = CGRectMake(0, 0, 0, cycleViewH + 39);
}

- (void)createBottomBar {
    
    NSArray *titles = @[@"点赞", @"评论", @"分享"];
    NSArray *imgs = @[@"thumbup_default", @"chat_default", @"share_default"];
    bottomBar = [GJGBottomToolBar bottomToolBarWithTitles:titles imgs:imgs hightLightImgs:@[@"thumbup_selected"]];
    [bottomBar.btns firstObject].selected = self.sharedOrderDetail.HasLike;
    bottomBar.delegate = self;
    
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo([NSNumber numberWithDouble:49]);
    }];
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentDataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
        cell.type = ShopGuideCellTypeIsSharedOrderDetail;
        cell.guideInfo = self.sharedOrderDetail.guideInfo;
        return cell;
    }else {
        DetailMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailMsgTableViewCell"];
        cell.msg = self.commentDataSource[indexPath.row - 1];
        return cell;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[LoginManager shareManager] checkUserLoginState:^{
        if (indexPath.row > 0) {
            [textView becomeFirstResponder];
            NSString *beReplyName = self.commentDataSource[indexPath.row - 1].user.UserName;
            textViewHolderString = [NSString stringWithFormat:@"回复:%@", beReplyName ? beReplyName : @""];
            // 在这里比较一下当前的这个回复者是否跟上个回复者一样，如果一样，就不清空回复内容
            // 1.比较
            if (indexPath.row != commentIndex) {
                textView.text = @"";
                // 2.answerer = this guys
                commentIndex = indexPath.row;
            }
            [textView setContentOffset:CGPointZero animated:NO];
            [textView scrollRangeToVisible:textView.selectedRange];
            [self textViewDidChange:textView];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        [textView resignFirstResponder];
    }
}


#pragma mark - Show & Hidden commentView

-(void)keyboardWillAppear:(NSNotification *)notification {
    
    if (!soAlphaView) {
        soAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [soAlphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCommentView)]];
    }
    [self.view addSubview:soAlphaView];
    [self.view bringSubviewToFront:self.commentView];
    
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        self.commentView.frame = CGRectMake(0, ScreenHeight - change - 44, ScreenWidth, 44);
    }];
    [detailTableView setContentOffset:CGPointMake(0, detailTableView.contentOffset.y + keyboardHeight) animated:YES];
}

-(void)keyboardWillDisappear:(NSNotification *)notification {
    
    [soAlphaView removeFromSuperview];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
    }];
    [detailTableView setContentOffset:CGPointMake(0, detailTableView.contentOffset.y - keyboardHeight)];
}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo {
    
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    keyboardHeight = keyboardEndingFrame.size.height;
    return keyboardHeight;
}
- (void)hiddenCommentView {
    [self.view endEditing:YES];
    [textView resignFirstResponder];
}

#pragma mark - Text view delegate

- (void)textViewDidChange:(UITextView *)textV {
    
    textViewHolder.text = textV.text.length ? @"" : textViewHolderString;
    
    if (textV.text.length > 140) {
        [MBProgressHUD showError:@"评论最多140字哦" toView:self.view];
        textV.text = [textV.text substringWithRange:NSMakeRange(0, 140)];
    }
    
    CGFloat textViewH = 0;
    CGFloat minHeight = 33.f;
    CGFloat maxHeight = 68.f;
    
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
        textViewH = minHeight;
    }else if (contentHeight > maxHeight){
        textViewH = maxHeight;
    }else{
        textViewH = contentHeight;
    }
    
    CGFloat commentViewHeight = textViewH + TextViewVerticalMargin * 2 - 1;
    CGRect frame = self.commentView.frame;
    frame.size.height = commentViewHeight;
    frame.origin.y = ScreenHeight - keyboardHeight - frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.commentView.frame = frame;
        [self.commentView layoutIfNeeded];
    }];
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}


#pragma mark - Button click event

- (void)labelsClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.labelsDetailView];
    [self.labelsDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(window).with.offset(0);
    }];
    self.labelsDetailView.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.labelsDetailView.alpha = 1.f;
    }completion:^(BOOL finished) {
    }];
}

- (void)offLabelsView {
    self.labelsDetailView.alpha = 1.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.labelsDetailView.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self.labelsDetailView removeFromSuperview];
    }];
}

- (void)bottomToolBarDidSelected:(NSInteger)index title:(NSString *)title {
    
    if ([title isEqualToString:@"点赞"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self likeOrUnLike];
        }];
    }else if ([title isEqualToString:@"评论"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self addComment];
        }];
    }else if ([title isEqualToString:@"分享"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self share];
        }];
    }
}

- (void)likeOrUnLike {
    NSLog(@"lb_like_status:%d", self.sharedOrderDetail.HasLike);
    
    static int isRequesing = 0;
    if (isRequesing) {
        return;
    }
    isRequesing = 1;
    
    [DJXRequest requestWithBlock:self.sharedOrderDetail.HasLike ? kApiUserShowUnLike : kApiUserShowLike
                           param:@{@"infoId" : [NSNumber numberWithInteger:self.sharedOrderDetail.Id]}
                         success:^(id object,NSString * msg)
     {
         self.sharedOrderDetail.HasLike = !self.sharedOrderDetail.HasLike;
         if (self.sharedOrderDetail.HasLike) {
             self.sharedOrderDetail.Like += 1;
         }else {
             self.sharedOrderDetail.Like -= 1;
         }
         self.sharedOrderDetail.guideInfo = nil;
         [[bottomBar.btns firstObject] setSelected:self.sharedOrderDetail.HasLike];
         ShopGuideTableViewCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         cell.type = ShopGuideCellTypeIsSharedOrderDetail;
         cell.guideInfo = self.sharedOrderDetail.guideInfo;
         isRequesing = 0;
         
         [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201050150002
                                                         andBCID:nil
                                                       andMallID:nil
                                                       andShopID:nil
                                                 andBusinessType:nil
                                                       andItemID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.Id]
                                                     andItemText:nil
                                                     andOpUserID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.userM.UserId]];
     } failure:^(id object,NSString * msg) {
         isRequesing = 0;
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
}


- (void)addComment {
    [textView becomeFirstResponder];
    textViewHolderString = @"添加留言";
    // 一样需要比较是否需要下面这行代码去清空留言内容
    if (commentIndex != 0) {
        commentIndex = 0;
        textView.text = @"";
    }
    [textView setContentOffset:CGPointZero animated:NO];
    [textView scrollRangeToVisible:textView.selectedRange];
    [self textViewDidChange:textView];
}

- (void)sendClick {
    
    if (textView.text.length == 0) {
        [MBProgressHUD showError:@"评论/回复不能为空" toView:self.view];
        return;
    }

    [DJXRequest requestWithBlock:kApiAddUserShowComment
                           param:@{@"InfoId" : [NSNumber numberWithInteger:self.sharedOrderDetail.Id],
                                   @"ReplyId" : (commentIndex == 0) ?
                                   @0 : [NSNumber numberWithInteger:self.commentDataSource[commentIndex - 1].CommentId],
                                   @"Content" : textView.text}//[textView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]}
                         success:^(id object,NSString * msg)
     {
         textView.text = @"";
         
         if ([object isKindOfClass:[NSString class]]) {
             [MBProgressHUD showSuccess:object toView:self.view];
         }
         
         self.sharedOrderDetail.Comment ++;
         ShopGuideTableViewCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         cell.type = ShopGuideCellTypeIsSharedOrderDetail;
         self.sharedOrderDetail.guideInfo = nil;
         cell.guideInfo = self.sharedOrderDetail.guideInfo;
         [self updateMsg:YES];
         
         [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201050170003
                                                         andBCID:nil
                                                       andMallID:nil
                                                       andShopID:nil
                                                 andBusinessType:nil
                                                       andItemID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.Id]
                                                     andItemText:nil
                                                     andOpUserID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.userM.UserId]];
     } failure:^(id object,NSString * msg) {
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
    [textView resignFirstResponder];
    for (UIView *subView in self.view.subviews) {
        if (subView != self.commentView && subView != soAlphaView && subView != detailTableView && subView != bottomBar) {
            [subView removeFromSuperview];
        }
    }
    [soAlphaView removeFromSuperview];
}

- (void)share {
    
    [[LBRequestManager sharedManager] getSharedInfoWithInfoId:self.sharedOrderDetail.Id
                                                     infoType:GJGShareInfoTypeIsShareOrder
                                                       result:^(id responseobject, NSError *error)
     {
         if (!error) {
             GJGShareInfo *shareInfo = responseobject;
             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                   title:shareInfo.Title
                                                                imageUrl:shareInfo.Images
                                                                     url:shareInfo.Url
                                                             description:@""
                                                                  infoId:[NSString stringWithFormat:@"%ld", self.sharedOrderDetail.Id]
                                                               shareType:UserOrderShareType
                                                     presentedController:self
                                                                 success:^(id object, UserShareSns sns)
              {
                  [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201050160004
                                                                  andBCID:nil
                                                                andMallID:nil
                                                                andShopID:nil
                                                          andBusinessType:nil
                                                                andItemID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.Id]
                                                              andItemText:nil
                                                              andOpUserID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.userM.UserId]];
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
////                  [[JXViewManager sharedInstance] showJXNoticeMessage:@"分享成功, 获得5成长值"];
//                  [DJXRequest requestWithBlock:kApiShareSuccess
//                                         param:@{@"InfoId" : @(self.sharedOrderDetail.Id),
//                                                 @"infoType" : @(GJGShareInfoTypeIsShareOrder),
//                                                 @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]}
//                                       success:^(id object)
//                   {
//                       if ([object isKindOfClass:[NSString class]]) {
//                           [MBProgressHUD showSuccess:object toView:self.view];
////                           [[JXViewManager sharedInstance] showJXNoticeMessage:object];
//                       }
//                       NSLog(@"记录分享行为成功.");
//                   }
//                                       failure:^(id object){}];
//                  [[GJGStatisticManager sharedManager] statisticByEventID:ID_0201050160004
//                                                                  andBCID:nil
//                                                                andMallID:nil
//                                                                andShopID:nil
//                                                          andBusinessType:nil
//                                                                andItemID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.Id]
//                                                              andItemText:nil
//                                                              andOpUserID:[NSString stringWithFormat:@"%lu", self.sharedOrderDetail.userM.UserId]];
//              } failure:^(id object, UserShareSns sns){}];
         }else {
             [MBProgressHUD showError:@"获取分享内容失败, 请检查网络." toView:self.view];
         }
     }];
}

@end
