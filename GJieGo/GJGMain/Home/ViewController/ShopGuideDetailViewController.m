//
//  ShopGuideDetailViewController.m
//  GJieGo
//
//  Created by liubei on 16/4/27.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "ShopGuideDetailViewController.h"
#import "ShopGuideTableViewCell.h"
#import "DetailMsgTableViewCell.h"
#import "LBGuideInfoM.h"
#import "LBMsgM.h"
#import "GJGBottomToolBar.h"
#import "DJXRequest.h"

#define CommentViewHeigth 46.f

#define TextViewVerticalMargin 6.f
#define TextViewLeftMargin 20.f
#define TextViewRightMargin -64.f

#define TextViewHolderViewHorMargin 6.f
#define TextViewHolderViewVerMargin 8.f

#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000


@interface ShopGuideDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
GJGBottomToolBarDelegate,
UITextViewDelegate> {
    
    UITableView *detailTableView;
    UIView *statusBackView;
    GJGBottomToolBar *bottomBar;
    
    UIView *commentView;
    UITextView *textView;
    UILabel *textViewHolder;
    NSString *textViewHolderString;
    
    UIView *sgAlphaView;
    
    CGFloat keyboardHeight;
    CGFloat textViewBaseContentHeight;
    
    NSInteger page;
    NSInteger commentIndex;
    
    NSInteger likeCountWithoutMe;
}

@property (nonatomic, weak) id answerer;
@property (nonatomic, assign, getter=isAnswerToOthers) BOOL answerToOthers;
/** 详情顶部Cell所需模型 */
@property (nonatomic, strong) LBGuideInfoM *guideInfo;
/** 评论信息数组 */
@property (nonatomic, strong) NSMutableArray<LBMsgM *> *commentDataSource;

@end

@implementation ShopGuideDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
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


- (NSMutableArray *)commentDataSource {
    
    if (!_commentDataSource) {
        
        _commentDataSource = [NSMutableArray array];
    }
    return _commentDataSource;
}


#pragma mark - Init

- (void)initAttributes {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241, 1);
    
    page = 1;
    commentIndex = 0;
    
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


#pragma mark - Load data

- (void)loadData {

    [DJXRequest requestWithBlock:kApiGetPromotionDetails
                           param:@{@"infoid" : [NSNumber numberWithInteger:self.infoid]}
                         success:^(id object,NSString * msg)
    {
        if ([object isKindOfClass:[NSDictionary class]]) {
            self.guideInfo = [LBGuideInfoM modelWithDict:object];
            self.guideInfo.statisticChat = self.statisticChat;
            likeCountWithoutMe = self.guideInfo.LikeNum - self.guideInfo.HasLike;
            [self createUI];
//            [detailTableView reloadData];
            [self loadMsg:NO];
        }else {
            [self createNullNote];
        }
    } failure:^(id object,NSString * msg) {
        if ([msg isKindOfClass:[NSString class]]) {
            [MBProgressHUD showError:msg toView:self.view];
        }
    }];
}

- (void)loadMsg:(BOOL)needScroll {
    
    [DJXRequest requestWithBlock:kApiGetPromotionComments
                           param:@{@"InfoId" : [NSNumber numberWithInteger:self.guideInfo.InfoId],
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
- (void)loadMoreMsg {
    [DJXRequest requestWithBlock:kApiGetPromotionComments
                           param:@{@"InfoId" : [NSNumber numberWithInteger:self.guideInfo.InfoId],
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


#pragma mark - Create UI

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
    [self createBottomBar];
    [self createCommentView];
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
    [detailTableView registerClass:[DetailMsgTableViewCell class]
            forCellReuseIdentifier:@"DetailMsgTableViewCell"];
    [detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopGuideTableViewCell class])
                                                bundle:nil]
          forCellReuseIdentifier:@"ShopGuideTableViewCell"];
    [self.view addSubview:detailTableView];
    [detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    detailTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [self loadMoreMsg];
    }];
}

- (void)createBottomBar {
    
    NSArray *titles = @[@"点赞", @"评论", @"分享"];
    NSArray *imgs = @[@"thumbup_default", @"chat_default", @"share_default"];
    bottomBar = [GJGBottomToolBar bottomToolBarWithTitles:titles imgs:imgs hightLightImgs:@[@"thumbup_selected"]];
    bottomBar.delegate = self;
    [[bottomBar.btns firstObject] setSelected:self.guideInfo.HasLike];
    
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo([NSNumber numberWithDouble:49]);
    }];
}

- (void)createCommentView {
    
    commentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, CommentViewHeigth)];
    [commentView setBackgroundColor:COLOR(241, 241, 241, 1)];
    
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
    
    [commentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(commentView).with.offset(TextViewVerticalMargin-1);
        make.left.equalTo(commentView.left).with.offset(TextViewLeftMargin);
        make.bottom.equalTo(commentView).with.offset(-TextViewVerticalMargin);
        make.right.equalTo(commentView.right).with.offset(TextViewRightMargin);
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
    [commentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(commentView.mas_right).with.offset(-10);
        make.centerY.equalTo(commentView.mas_centerY).with.offset(0);
        make.height.mas_equalTo(@34);
        make.width.mas_equalTo(@44);
    }];
    
    textViewBaseContentHeight = 36.f;
    [self.view addSubview:commentView];
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.guideInfo ? self.commentDataSource.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ShopGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopGuideTableViewCell"];
        cell.type = ShopGuideCellTypeIsDetail;
        cell.guideInfo = self.guideInfo;
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
            commentIndex = indexPath.row;
            textView.text = @"";
            [textView setContentOffset:CGPointZero animated:NO];
            [textView scrollRangeToVisible:textView.selectedRange];
            [self textViewDidChange:textView];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    
    if (!sgAlphaView) {
        sgAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [sgAlphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCommentView)]];
    }
    [self.view addSubview:sgAlphaView];
    [self.view bringSubviewToFront:commentView];
    
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue]  animations:^{
        commentView.frame = CGRectMake(0, ScreenHeight - change - 44, ScreenWidth, 44);
    }];
    [detailTableView setContentOffset:CGPointMake(0, detailTableView.contentOffset.y + keyboardHeight) animated:YES];
}

-(void)keyboardWillDisappear:(NSNotification *)notification {
    
    [sgAlphaView removeFromSuperview];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        commentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
        detailTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
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
    CGRect frame = commentView.frame;
    frame.size.height = commentViewHeight;
    frame.origin.y = ScreenHeight - keyboardHeight - frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        
        commentView.frame = frame;
        [commentView layoutIfNeeded];
    }];
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}
static NSString *unloadStr = @"";

#pragma mark - Button click event

- (void)bottomToolBarDidSelected:(NSInteger)index title:(NSString *)title {
    
    if ([title isEqualToString:@"点赞"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self likeOrUnLike];
        }];
    }else if ([title isEqualToString:@"评论"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self addCommentClick];
        }];
    }else if ([title isEqualToString:@"分享"]) {
        [[LoginManager shareManager] checkUserLoginState:^{
            [self share];
        }];
    }
}

- (void)likeOrUnLike {
    
    static int isRequesing = 0;
    if (isRequesing) {
        return;
    }
    isRequesing = 1;
    
    [DJXRequest requestWithBlock:self.guideInfo.HasLike ? kApiPromotionUnLike : kApiPromotionLike
                           param:@{@"infoId" : [NSNumber numberWithInteger:self.guideInfo.InfoId]}
                         success:^(id object,NSString * msg)
     {
         self.guideInfo.HasLike = !self.guideInfo.HasLike;
         self.guideInfo.LikeNum = likeCountWithoutMe + self.guideInfo.HasLike;
         [[bottomBar.btns firstObject] setSelected:self.guideInfo.HasLike];
         ShopGuideTableViewCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         cell.type = ShopGuideCellTypeIsDetail;
         cell.guideInfo = self.guideInfo;
         isRequesing = 0;
         if (self.statisticLike.length) {
             [[GJGStatisticManager sharedManager] statisticByEventID:self.statisticLike
                                                             andBCID:nil
                                                           andMallID:nil
                                                           andShopID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.ShopId]
                                                     andBusinessType:self.guideInfo.guider.BusinessFormat
                                                           andItemID:[NSString stringWithFormat:@"%lu", self.guideInfo.InfoId]
                                                         andItemText:nil
                                                         andOpUserID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.UserId]];
         }
     } failure:^(id object,NSString * msg) {
         isRequesing = 0;
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
}

- (void)addCommentClick {
    
    [textView becomeFirstResponder];
    textViewHolderString = @"添加留言";
    // 一样需要比较是否需要下面这行代码去清空留言内容
//    if (commentIndex != 0) {
//        commentIndex = 0;
//        textView.text = @"";
//    }
    commentIndex = 0;
    textView.text = @"";
    [textView setContentOffset:CGPointZero animated:NO];
    [textView scrollRangeToVisible:textView.selectedRange];
    [self textViewDidChange:textView];
}

- (void)sendClick {
    
    if (textView.text.length == 0) {
        [MBProgressHUD showError:@"评论/回复不能为空" toView:self.view];
        return;
    }
    
    NSLog(@"msg: %@", textView.text);

    [DJXRequest requestWithBlock:kApiAddPromotionComment
                           param:@{@"InfoId" : [NSNumber numberWithInteger:self.guideInfo.InfoId],
                                   @"ReplyId" : (commentIndex == 0) ?
                                   @0 : [NSNumber numberWithInteger:self.commentDataSource[commentIndex - 1].CommentId],
                                   @"Content" : textView.text}//[textView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]}
                         success:^(id object,NSString * msg)
     {
         if ([object isKindOfClass:[NSString class]]) {
             [MBProgressHUD showSuccess:object toView:self.view];
         }
         self.guideInfo.CommentNum ++;
         ShopGuideTableViewCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         cell.type = ShopGuideCellTypeIsDetail;
         cell.guideInfo = self.guideInfo;
         [self loadMsg:YES];
         if (self.statisticSendMsg.length) {
             [[GJGStatisticManager sharedManager] statisticByEventID:self.statisticSendMsg
                                                             andBCID:nil
                                                           andMallID:nil
                                                           andShopID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.ShopId]
                                                     andBusinessType:self.guideInfo.guider.BusinessFormat
                                                           andItemID:[NSString stringWithFormat:@"%lu", self.guideInfo.InfoId]
                                                         andItemText:nil
                                                         andOpUserID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.UserId]];
         }
     } failure:^(id object,NSString * msg) {
         if ([msg isKindOfClass:[NSString class]]) {
             [MBProgressHUD showError:msg toView:self.view];
         }
     }];
    [textView resignFirstResponder];
    for (UIView *subView in self.view.subviews) {
        if (subView != commentView && subView != sgAlphaView && subView != detailTableView && subView != bottomBar) {
            [subView removeFromSuperview];
        }
    }
    [sgAlphaView removeFromSuperview];
}

- (void)share {
    [[LBRequestManager sharedManager] getSharedInfoWithInfoId:self.guideInfo.InfoId
                                                     infoType:GJGShareInfoTypeIsGuideInfo
                                                       result:^(id responseobject, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (!error) {  // 获取分享内容成功
             GJGShareInfo *shareInfo = responseobject;
             [[ShareManager shareManager] showCustomShareViewWithContent:shareInfo.Content
                                                                   title:shareInfo.Title
                                                                imageUrl:shareInfo.Images
                                                                     url:shareInfo.Url
                                                             description:@""
                                                                  infoId:[NSString stringWithFormat:@"%ld", self.guideInfo.InfoId]
                                                               shareType:UserPromotionShareType
                                                     presentedController:self
                                                                 success:^(id object, UserShareSns sns)
             {  // 分享成功, 触发数据埋点
                 if (self.statisticShare.length) {
                     [[GJGStatisticManager sharedManager] statisticByEventID:self.statisticShare
                                                                     andBCID:nil
                                                                   andMallID:nil
                                                                   andShopID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.      ShopId]
                                                             andBusinessType:self.guideInfo.guider.BusinessFormat
                                                                   andItemID:[NSString stringWithFormat:@"%lu", self.guideInfo.InfoId]
                                                                 andItemText:nil
                                                                 andOpUserID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.UserId]];
                 }
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
//                                         param:@{@"InfoId" : @(self.guideInfo.InfoId),
//                                                 @"infoType" : @(GJGShareInfoTypeIsGuideInfo),
//                                                 @"ShareTo":[NSString stringWithFormat:@"%ld", (long)sns]}
//                                       success:^(id object)
//                   {
//                       if ([object isKindOfClass:[NSString class]]) {
//                           [[JXViewManager sharedInstance] showJXNoticeMessage:object];
//                       }
//                       NSLog(@"记录分享行为成功.");
//                   }
//                                       failure:^(id object){}];
//                  if (self.statisticShare.length) {
//                      [[GJGStatisticManager sharedManager] statisticByEventID:self.statisticShare
//                                                                      andBCID:nil
//                                                                    andMallID:nil
//                                                                    andShopID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.      ShopId]
//                                                              andBusinessType:self.guideInfo.guider.BusinessFormat
//                                                                    andItemID:[NSString stringWithFormat:@"%lu", self.guideInfo.InfoId]
//                                                                  andItemText:nil
//                                                                  andOpUserID:[NSString stringWithFormat:@"%lu", self.guideInfo.guider.UserId]];
//                  }
//              } failure:^(id object, UserShareSns sns){}];
            }else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:@"获取分享内容失败, 请检查网络." toView:self.view];
            }
     }];
}

@end
