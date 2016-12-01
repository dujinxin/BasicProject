//
//  ShareViewController.m
//  GJieGo
//
//  Created by liubei on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#define TextViewVerticalMargin 6.f
#define TextViewLeftMargin 15.f
#define TextViewRightMargin 15.f

#define TextViewHolderViewHorMargin 6.f
#define TextViewHolderViewVerMargin 8.f

#define kAlphaNum       @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha          @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers        @"0123456789"
#define kNumbersPeriod  @"0123456789."


#import "ShareViewController.h"
#import "ShareActivityViewController.h"
#import "ShareImageDetailViewController.h"
#import "SharedOrderDetailViewController.h"
#import "TZImagePickerController.h"

@interface ShareViewController ()
<UITextViewDelegate,
UITextFieldDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ShareImageDetailViewControllerDelegate,
ShareActivityViewControllerDelegate,
UIActionSheetDelegate,
TZImagePickerControllerDelegate> {
    
    UIScrollView *scrollView;
    UIView *imgHolder;
    
    UIView *activityHolder;
    UILabel *activityNameLabel;
    UIButton *deleteAcBtn;
    ShareActivityModel *selectedActivity;
    
    UIView *labelHolder;
    UILabel *labelNote;
    UIImageView *noteImg;
    UILabel *goodsLabel;
    UILabel *brandLabel;
    UILabel *priceLabel;
    UILabel *buyPlaceLabel;
    
    UIView *shareMsgHolder;
    UITextView *textView;
    UILabel *textViewHolder;
    CGFloat keyboardHeight;
    
    UIButton *lastClickBtn;
    
    UITextField *goodsTextField;
    UITextField *brandTextField;
    UITextField *priceTextField;
    UITextField *buyPlaceTextField;
    
    NSInteger userShowID;
}

@property (nonatomic, strong) UIView *statusBackView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *imgBtns;
@property (strong, nonatomic) UIActionSheet *actionSheet;
//@property (nonatomic, strong) UIImagePickerController *pickerImage;
@property (nonatomic, strong) UIView *labelSelectedView;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAttributes];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundColor:GJGRGB16Color(0xfee330)];
    [self.navigationController.navigationBar addSubview:self.statusBackView];
    [scrollView setContentOffset:CGPointMake(0, -64)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.statusBackView removeFromSuperview];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    NSInteger col = 3;
    CGFloat horOutMargin = 15.f;
    CGFloat horInMargin = 8.f;
    CGFloat verTopMargin = 8.f;
    CGFloat verBotMargin = 14.f;
    
    CGFloat btnW = (ScreenWidth - horOutMargin * 2 - (col - 1) * horInMargin) / col;
    CGFloat btnH = btnW;
    CGFloat imgHolderH = verTopMargin + verBotMargin + btnW + (btnW + horInMargin) * ((self.imgBtns.count - 1) / col);
    
    for (int i = 0; i < self.imgBtns.count; i ++) {
        
        CGFloat btnX = horOutMargin + (btnW + horInMargin) * (i % col);
        CGFloat btnY = verTopMargin + (btnH + verTopMargin) * (i / col);
        
        UIButton *btn = (UIButton *)self.imgBtns[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    imgHolder.frame = CGRectMake(0, 0, ScreenWidth, imgHolderH);
    activityHolder.frame = CGRectMake(0, CGRectGetMaxY(imgHolder.frame), kScreenWidth, 44);
    labelHolder.frame = CGRectMake(0, CGRectGetMaxY(activityHolder.frame) + 10, ScreenWidth, 103);
    shareMsgHolder.frame = CGRectMake(0, CGRectGetMaxY(labelHolder.frame) + 10, ScreenWidth, 158);
    scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(shareMsgHolder.frame));
}


#pragma mark - Lazy

- (UIView *)statusBackView {
    
    if (!_statusBackView) {
        
        _statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
        _statusBackView.backgroundColor = GJGRGB16Color(0xfee330);
    }
    return _statusBackView;
}

- (NSMutableArray *)imgBtns {
    
    if (!_imgBtns) {
        
        _imgBtns = [NSMutableArray array];
    }
    return _imgBtns;
}

//- (UIImagePickerController *)pickerImage {
//    
//    if (!_pickerImage) {
//        
//        _pickerImage = [[UIImagePickerController alloc] init];
//        
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//            _pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            _pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_pickerImage.sourceType];
//            
//        }
//        _pickerImage.delegate = self;
//        _pickerImage.allowsEditing = NO;
//    }
//    return _pickerImage;
//}

- (UIView *)labelSelectedView {
    
    if (!_labelSelectedView) {
        
        _labelSelectedView = [[UIView alloc] init];
        
        UIView *alphaView = [[UIView alloc] init];
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.alpha = 0.6;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [alphaView addGestureRecognizer:tap];
        
        [_labelSelectedView addSubview:alphaView];
        [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.bottom.and.right.equalTo(_labelSelectedView).with.offset(0);
        }];
        
        UIColor *color = GJGRGB16Color(0xdbdbdb);
        CGFloat fieldH = 44;
        
        goodsTextField = [[UITextField alloc] init];
        goodsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        goodsTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        goodsTextField.leftViewMode = UITextFieldViewModeAlways;
        goodsTextField.font = [UIFont systemFontOfSize:13];
        goodsTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:@"商品名"
                                                attributes:@{NSForegroundColorAttributeName: color}];
        goodsTextField.delegate = self;
        [goodsTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        goodsTextField.textColor = color;
        goodsTextField.layer.borderWidth = 1;
        goodsTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        goodsTextField.layer.masksToBounds = YES;
        goodsTextField.layer.cornerRadius = fieldH * 0.5;
        goodsTextField.backgroundColor = [UIColor clearColor];
        [_labelSelectedView addSubview:goodsTextField];
        [goodsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_labelSelectedView).with.offset(15);
            make.right.equalTo(_labelSelectedView).with.offset(-15);
            make.top.equalTo(_labelSelectedView).with.offset(64+16);
            make.height.equalTo(fieldH);
        }];
        
        brandTextField = [[UITextField alloc] init];
        brandTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        brandTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        brandTextField.leftViewMode = UITextFieldViewModeAlways;
        brandTextField.font = [UIFont systemFontOfSize:13];
        brandTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:@"品牌"
                                                attributes:@{NSForegroundColorAttributeName: color}];
        brandTextField.delegate = self;
        [brandTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        brandTextField.textColor = color;
        brandTextField.layer.borderWidth = 1;
        brandTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        brandTextField.layer.cornerRadius = fieldH * 0.5;
        brandTextField.layer.masksToBounds = YES;
        brandTextField.backgroundColor = [UIColor clearColor];
        [_labelSelectedView addSubview:brandTextField];
        [brandTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_labelSelectedView).with.offset(15);
            make.right.equalTo(_labelSelectedView).with.offset(-15);
            make.top.equalTo(goodsTextField.mas_bottom).with.offset(16);
            make.height.equalTo(fieldH);
        }];
        
        priceTextField = [[UITextField alloc] init];
        priceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        priceTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        priceTextField.leftViewMode = UITextFieldViewModeAlways;
        priceTextField.font = [UIFont systemFontOfSize:13];
        priceTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:@"价格"
                                                attributes:@{NSForegroundColorAttributeName: color}];
        priceTextField.delegate = self;
        [priceTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        priceTextField.textColor = color;
        priceTextField.layer.borderWidth = 1;
        priceTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        priceTextField.layer.cornerRadius = fieldH * 0.5;
        priceTextField.layer.masksToBounds = YES;
        priceTextField.backgroundColor = [UIColor clearColor];
        [_labelSelectedView addSubview:priceTextField];
        [priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_labelSelectedView).with.offset(15);
            make.right.equalTo(_labelSelectedView).with.offset(-15);
            make.top.equalTo(brandTextField.mas_bottom).with.offset(16);
            make.height.equalTo(fieldH);
        }];
        
        buyPlaceTextField = [[UITextField alloc] init];
        buyPlaceTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        buyPlaceTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        buyPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
        buyPlaceTextField.font = [UIFont systemFontOfSize:13];
        buyPlaceTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:@"购买地"
                                                attributes:@{NSForegroundColorAttributeName: color}];
        buyPlaceTextField.delegate = self;
        [buyPlaceTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        buyPlaceTextField.textColor = color;
        buyPlaceTextField.layer.borderWidth = 1;
        buyPlaceTextField.layer.borderColor = [UIColor whiteColor].CGColor;
        buyPlaceTextField.layer.cornerRadius = fieldH * 0.5;
        buyPlaceTextField.layer.masksToBounds = YES;
        buyPlaceTextField.backgroundColor = [UIColor clearColor];
        [_labelSelectedView addSubview:buyPlaceTextField];
        [buyPlaceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_labelSelectedView).with.offset(15);
            make.right.equalTo(_labelSelectedView).with.offset(-15);
            make.top.equalTo(priceTextField.mas_bottom).with.offset(16);
            make.height.equalTo(fieldH);
        }];
        
        UIButton *accomplishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [accomplishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [accomplishBtn setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
        [accomplishBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [accomplishBtn setBackgroundColor:GJGRGB16Color(0xfee330)];
        [accomplishBtn addTarget:self action:@selector(accomplishInput) forControlEvents:UIControlEventTouchUpInside];
        
        [_labelSelectedView addSubview:accomplishBtn];
        [accomplishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_labelSelectedView).with.offset(15);
            make.right.equalTo(_labelSelectedView).with.offset(-15);
            make.top.equalTo(buyPlaceTextField.mas_bottom).with.offset(61);
            make.height.equalTo(fieldH);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn addTarget:self action:@selector(cancelSelectLabel) forControlEvents:UIControlEventTouchUpInside];
        
        [_labelSelectedView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_labelSelectedView).with.offset(15);
            make.right.equalTo(_labelSelectedView).with.offset(-15);
            make.top.equalTo(accomplishBtn.mas_bottom).with.offset(10);
            make.height.equalTo(fieldH);
        }];
    }
    return _labelSelectedView;
}


#pragma mark - Init

- (void)initAttributes {
    
    selectedActivity = nil;
    if (self.activityName && self.activityId) {
        selectedActivity = [[ShareActivityModel alloc] init];
        selectedActivity.ActivityName = self.activityName;
        selectedActivity.ActivityId = self.activityId;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = GJGRGB16Color(0xf1f1f1);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)createUI {
    
    userShowID = 0;
    [self createNavigationView];
    [self createMainView];
}

- (void)createNavigationView {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [leftButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(0,0,44,44);
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    [rightButton setTitleColor:GJGRGB16Color(0x999999) forState:UIControlStateDisabled];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightButton addTarget:self action:@selector(shareOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createMainView {

    scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 300, 0);
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    
    imgHolder = [[UIView alloc] init];
    imgHolder.backgroundColor = [UIColor clearColor];

    [imgHolder addSubview:[self getAddBtn]];
    [scrollView addSubview:imgHolder];
    
    // 活动
    activityHolder = [[UIView alloc] init];
    [scrollView addSubview:activityHolder];
    UITapGestureRecognizer *acTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activityTap)];
    activityHolder.userInteractionEnabled = YES;
    [activityHolder addGestureRecognizer:acTap];
    activityHolder.backgroundColor = [UIColor whiteColor];

    UIImageView *activityIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_add_activity"]];
    [activityHolder addSubview:activityIcon];
    [activityIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(activityHolder.mas_centerY).with.offset(0);
        make.width.and.height.mas_equalTo(@30);
        make.left.equalTo(activityHolder.mas_left).with.offset(@15);
    }];
    
    activityNameLabel = [[UILabel alloc] init];
    activityNameLabel.text = selectedActivity.ActivityName ? selectedActivity.ActivityName : @"参与活动或主题";
    activityNameLabel.font = [UIFont systemFontOfSize:13];
    activityNameLabel.textColor = GJGBLACKCOLOR;
    [activityHolder addSubview:activityNameLabel];
    [activityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(activityHolder).with.offset(0);
        make.left.equalTo(activityIcon.mas_right).with.offset(@8);
    }];
    
    deleteAcBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteAcBtn addTarget:self action:@selector(deleteActivity) forControlEvents:UIControlEventTouchUpInside];
    deleteAcBtn.hidden = !selectedActivity;
    [deleteAcBtn setBackgroundImage:[UIImage imageNamed:@"login_input_delete"] forState:UIControlStateNormal];
    [activityHolder addSubview:deleteAcBtn];
    [deleteAcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(activityHolder.mas_centerY).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.equalTo(activityNameLabel.mas_right).with.offset(5);
    }];
    
    UIImageView *activityRightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_arrow"]];
    [activityHolder addSubview:activityRightIcon];
    [activityRightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(6, 10));
        make.centerY.mas_equalTo(activityHolder.mas_centerY);
        make.right.equalTo(activityHolder.mas_right).with.offset(@(-15));
    }];
    
    // 标签
    labelHolder = [[UIView alloc] init];
    labelHolder.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLabels)];
    labelHolder.userInteractionEnabled = YES;
    [labelHolder addGestureRecognizer:tap];
    
    labelNote = [[UILabel alloc] init];
    labelNote.text = @"点击添加标签";
    labelNote.font = [UIFont systemFontOfSize:13];
    labelNote.textColor = GJGRGB16Color(0xdbdbdb);
    labelNote.textAlignment = NSTextAlignmentLeft;
    [labelHolder addSubview:labelNote];
    [labelNote mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(labelHolder).with.offset(10);
        make.left.equalTo(labelHolder).with.offset(15);
    }];
    
    noteImg = [[UIImageView alloc] init];
    noteImg.image = [UIImage imageNamed:@"btn_add_tags"];
    noteImg.layer.cornerRadius = 33.f;
    noteImg.layer.masksToBounds = YES;
    noteImg.contentMode = UIViewContentModeScaleAspectFill;
    [labelHolder addSubview:noteImg];
    [noteImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(labelHolder.mas_centerX);
        make.centerY.mas_equalTo(labelHolder.mas_centerY);
        make.width.and.height.equalTo(@66);
    }];
    
    // create label
    goodsLabel = [[UILabel alloc] init];
    goodsLabel.font = [UIFont systemFontOfSize:13];
    goodsLabel.textColor = GJGBLACKCOLOR;
    goodsLabel.textAlignment = NSTextAlignmentLeft;
    [labelHolder addSubview:goodsLabel];
    [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(labelHolder.mas_top).with.offset(10);
        make.left.equalTo(labelHolder.mas_left).with.offset(15);
        make.right.equalTo(labelHolder.mas_right).with.offset(-15);
        make.height.mas_equalTo(20);
    }];
    brandLabel = [[UILabel alloc] init];
    brandLabel.font = [UIFont systemFontOfSize:13];
    brandLabel.textColor = GJGBLACKCOLOR;
    brandLabel.textAlignment = NSTextAlignmentLeft;
    [labelHolder addSubview:brandLabel];
    [brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(goodsLabel.mas_bottom).with.offset(0);
        make.left.equalTo(labelHolder.mas_left).with.offset(15);
        make.right.equalTo(labelHolder.mas_right).with.offset(-15);
        make.height.mas_equalTo(20);
    }];
    priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.textColor = GJGBLACKCOLOR;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [labelHolder addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(brandLabel.mas_bottom).with.offset(0);
        make.left.equalTo(labelHolder.mas_left).with.offset(15);
        make.right.equalTo(labelHolder.mas_right).with.offset(-15);
        make.height.mas_equalTo(20);
    }];
    buyPlaceLabel = [[UILabel alloc] init];
    buyPlaceLabel.font = [UIFont systemFontOfSize:13];
    buyPlaceLabel.textColor = GJGBLACKCOLOR;
    buyPlaceLabel.textAlignment = NSTextAlignmentLeft;
    [labelHolder addSubview:buyPlaceLabel];
    [buyPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(priceLabel.mas_bottom).with.offset(0);
        make.left.equalTo(labelHolder.mas_left).with.offset(15);
        make.right.equalTo(labelHolder.mas_right).with.offset(-15);
        make.height.mas_equalTo(20);
    }];
    [scrollView addSubview:labelHolder];
    
    shareMsgHolder = [[UIView alloc] init];
    [shareMsgHolder setBackgroundColor:[UIColor whiteColor]];
    
    textView = [[UITextView alloc] init];
    [textView setDelegate:self];
    [textView.layer setCornerRadius:4.f];
    [textView.layer setMasksToBounds:YES];
    [textView setFont:[UIFont systemFontOfSize:13]];
    [textView setBackgroundColor:[UIColor whiteColor]];
    [textView setShowsVerticalScrollIndicator:NO];
    [textView setBounces:NO];
    textViewHolder = [[UILabel alloc] init];
    textViewHolder.text = @"请输入5-700字的晒单心得";
    [textViewHolder setFont:[UIFont systemFontOfSize:13]];
    [textViewHolder setTextColor:GJGRGB16Color(0xdbdbdb)];
    [textView addSubview:textViewHolder];
    [textViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(textView).with.offset(TextViewHolderViewVerMargin);
        make.left.equalTo(textView).with.offset(TextViewHolderViewHorMargin);
    }];
    
    [shareMsgHolder addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(shareMsgHolder).with.offset(TextViewVerticalMargin-1);
        make.bottom.equalTo(shareMsgHolder).with.offset(-TextViewVerticalMargin);
        make.left.equalTo(shareMsgHolder.left).with.offset(TextViewLeftMargin);
        make.right.equalTo(shareMsgHolder.right).with.offset(-TextViewRightMargin);
    }];
    
    [scrollView addSubview:shareMsgHolder];
}

- (UIButton *)getAddBtn {
    
    UIButton *addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    addImgBtn.imageView.clipsToBounds = YES;
    addImgBtn.backgroundColor = [UIColor whiteColor];
    [addImgBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_images"] forState:UIControlStateNormal];
    [addImgBtn addTarget:self action:@selector(addImgClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imgBtns addObject:addImgBtn];
    
    return addImgBtn;
}


#pragma mark - 上传 发布晒单
- (void)uploadShareOrder {
    
    [self.view endEditing:YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showMessag:@"上传中..." toView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",
                                                               @"text/html",
                                                               @"text/json",
                                                               @"text/javascript",
                                                               @"application/x-javascript", nil]];
        NSDictionary *dict;
        if (selectedActivity) {
            dict = @{@"Description" : textView.text.length > 5 ? textView.text :
                         [NSString stringWithFormat:@"%@", textView.text],
                     @"ActivityId" : selectedActivity.ActivityId,
                     @"ProductName" : goodsLabel.text.length > 0 ? goodsLabel.text : @"",
                     @"Brand" : brandLabel.text.length > 0 ? brandLabel.text : @"",
                     @"Price" : priceLabel.text.length > 0 ? priceLabel.text : @"",
                     @"BuyFrom" : buyPlaceLabel.text.length > 0 ? buyPlaceLabel.text : @"",
                     @"CityId" : [NSNumber numberWithInteger:[GJGLocationManager sharedManager].cityID]};
        }else {
            dict = @{@"Description" : textView.text.length > 5 ? textView.text :
                         [NSString stringWithFormat:@"%@          ", textView.text],
                     @"ProductName" : goodsLabel.text.length > 0 ? goodsLabel.text : @"",
                     @"Brand" : brandLabel.text.length > 0 ? brandLabel.text : @"",
                     @"Price" : priceLabel.text.length > 0 ? priceLabel.text : @"",
                     @"BuyFrom" : buyPlaceLabel.text.length > 0 ? buyPlaceLabel.text : @"",
                     @"CityId" : [NSNumber numberWithInteger:[GJGLocationManager sharedManager].cityID]};
        }
        NSString *urlString = kGJGRequestUrl(kApiAddUserShowAll);
        
        [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //上传文件参数
            // 设置日期格式
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            
            for (int i = 0; i < self.imgBtns.count; i ++) {
                if (self.imgBtns[i].imageView.image) {
                    
                    NSString *fileName = [formatter stringFromDate:[NSDate date]];
                    UIImage *uploadImg = self.imgBtns[i].imageView.image;
                    
                    CGFloat ratio = 1;  // 压缩比率
                    int count = 0;
                    NSData *imgData = UIImageJPEGRepresentation(uploadImg, ratio);
                    
                    while (imgData.length > 400000 && count < 4) {
                        NSLog(@"上传第%d张图片, 压缩后大小为:%lu, 超过限制,再次压缩", i, imgData.length);
                        ratio *= 0.2;
                        count ++;
                        imgData = UIImageJPEGRepresentation(uploadImg, ratio);
                    }
                    if (imgData.length > 490000) {
                        [[JXViewManager sharedInstance] showJXNoticeMessage:[NSString stringWithFormat:@"第%d张图片过大", i]];
                        return ;
                    }
                    NSLog(@"上传第%d张图片, 压缩后大小为:%lu, 符合要求, 进行拼接.", i, imgData.length);
                    // 拼接图片
                    [formData appendPartWithFileData:imgData
                                                name:[NSString stringWithFormat:@"%@", fileName]
                                            fileName:[NSString stringWithFormat:@"%@.png", fileName]
                                            mimeType:@"image/png"];
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印下上传进度
            NSLog(@"上传进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            kResponseStatus status = (kResponseStatus)[[responseObject objectForKey:@"status"] integerValue];
            if (status == kResponseShortTokenDisabled) {
                [[UserRequest shareManager] userLongToken:kApiUserLongToken
                                                    param:@{@"RToken":[[UserDBManager shareManager] getToken]}
                                                  success:^(id object,NSString *msg)
                {
                    [self uploadShareOrder];
                } failure:^(id object,NSString *msg) {
                    //
                }];
                return;
            }
            //请求成功
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"发布晒单成功, %@", responseObject);
            if ([[responseObject objectForKey:@"status"] isEqualToNumber:@0]) {
                if ([responseObject objectForKey:@"data"]) {
                    if ([responseObject objectForKey:@"message"]) {
                        [MBProgressHUD showSuccess:[responseObject objectForKey:@"message"] toView:self.view];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                    {
                        NSMutableArray *vcs = [self.navigationController.viewControllers mutableCopy];
                        for (UIViewController *vc in vcs) {
                            if (vc == self) {
                                [vcs removeObject:vc];
                            }
                        }
                        SharedOrderDetailViewController *shareOrderVC = [[SharedOrderDetailViewController alloc] init];
                        shareOrderVC.hidesBottomBarWhenPushed = YES;
                        shareOrderVC.infoId = [[[responseObject objectForKey:@"data"] objectForKey:@"Id"] integerValue];
                        NSLog(@"new create share order id:%lu", shareOrderVC.infoId);
                        [vcs addObject:shareOrderVC];
                        [self.navigationController setViewControllers:vcs animated:YES];
                    });
                }
            }else {
                [MBProgressHUD showError:[responseObject objectForKey:@"message"] toView:self.view];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败
            NSLog(@"请求失败：%@",error);
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络异常" toView:self.view];
        }];
    });
}


#pragma mark - Click event

- (void)cancelClick:(id)sender {
    
    NSInteger imgCount = 0;
    for (UIButton *btn in self.imgBtns) {
        if (btn.imageView.image) {
            imgCount ++;
        }
    }
    if (imgCount > 0 ||
        textView.text.length > 0 ||
        goodsLabel.text.length > 0 ||
        brandLabel.text.length > 0 ||
        priceLabel.text.length > 0 ||
        buyPlaceLabel.text.length > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"亲, 编辑尚未保存\n确定退出吗?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }];
        UIAlertAction *notSure = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:sure];
        [alert addAction:notSure];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shareOrderClick:(id)sender {
    
    [self hiddenKeyBoard];
    NSInteger imgCount = 0;
    for (UIButton *btn in self.imgBtns) {
        if (btn.imageView.image) {
            imgCount ++;
        }
    }
    if (imgCount < 1) {
        [MBProgressHUD showError:@"请至少上传一张图片" toView:self.view];
        return;
    }
//    if (goodsLabel.text.length < 1) {
//        NSLog(@"请输入商品名");
//        return;
//    }
//    if (brandLabel.text.length < 1) {
//        NSLog(@"请输入品牌名");
//        return;
//    }
//    if (priceLabel.text.length < 1) {
//        NSLog(@"请输入价格");
//        return;
//    }
//    if (buyPlaceLabel.text.length < 1) {
//        NSLog(@"请输入购买地");
//        return;
//    }
//    if (!(textView.text.length > 0)) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                       message:@"还未添加标签/share心得哦，确认发布吗？"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定"
//                                                       style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * _Nonnull action) {
//                                                         [self uploadShareOrder];
//                                                     }];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
//                                                       style:UIAlertActionStyleDefault
//                                                     handler:nil];
//        [alert addAction:sure];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
    if (textView.text.length < 5) {
        if (textView.text.length == 0) {
            [[JXViewManager sharedInstance] showJXNoticeMessage:@"请输入晒单心得"];
//            [MBProgressHUD showError:@"请输入晒单心得" toView:self.view];
            return;
        }else {
            [[JXViewManager sharedInstance] showJXNoticeMessage:@"晒单心得至少5个字，亲再赏几个字吧"];
//            [MBProgressHUD showError:@"晒单心得至少10个字，亲再赏几个字吧" toView:self.view];
            return;
        }
    }
    [self uploadShareOrder];
}

- (void)addImgClick:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    lastClickBtn = button;
    if (button.imageView.image == nil) {
        [self callActionSheetFunc];
    }else {
        ShareImageDetailViewController *detailVC = [[ShareImageDetailViewController alloc] init];
        detailVC.delegate = self;
        detailVC.showImage = button.imageView.image;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)callActionSheetFunc{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选择", nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    [self openCamera];
                    break;
                case 1:
                    //来源:相册
                    [self openPhoneLibray];
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                [self openPhoneLibray];
            }
        }
    }
}

- (void)openCamera {
    // 跳转到相机页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)openPhoneLibray {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowTakePicture = NO;
    int phoneNumber = 0;
    for (UIButton *btn in self.imgBtns) {
        if (btn.imageView.image) {
            phoneNumber ++;
        }
    }
    imagePickerVc.maxImagesCount = 4 - phoneNumber;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *phones, NSArray *asses, BOOL success) {
        
        for (int i = 0; i <phones.count; i++) {
            [lastClickBtn setImage:phones[i] forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (self.imgBtns.count < 4) {
                UIButton *newCreateBtn = [self getAddBtn];
                lastClickBtn = newCreateBtn;
                [imgHolder addSubview:newCreateBtn];
            }
        }
        [self viewWillLayoutSubviews];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *origanlImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    origanlImage = [origanlImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSData *imageData = UIImageJPEGRepresentation(origanlImage, 1);
    UIImage *image = [UIImage imageWithData:imageData];
    
    [lastClickBtn setImage:image forState:UIControlStateNormal];
    if (self.imgBtns.count < 4) {
        UIButton *newCreateBtn = [self getAddBtn];
        lastClickBtn = newCreateBtn;
        [imgHolder addSubview:newCreateBtn];
    }
    [self viewWillLayoutSubviews];
}

- (void)selectLabels {
    
    goodsTextField.text = goodsLabel.text;
    brandTextField.text = brandLabel.text;
    priceTextField.text = priceLabel.text;
    buyPlaceTextField.text = buyPlaceLabel.text;
    self.labelSelectedView.alpha = 0;
    
    [self.view addSubview:self.labelSelectedView];
    [_labelSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.view).with.offset(0);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        self.labelSelectedView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)accomplishInput {
    
    if (priceTextField.text.length && ![self stringIsPureInt:priceTextField.text] && ![self stringIsPureFloat:priceTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.labelSelectedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.labelSelectedView removeFromSuperview];
        goodsLabel.text = goodsTextField.text;
        brandLabel.text = brandTextField.text;
        priceLabel.text = priceTextField.text;
//        if ([priceTextField.text rangeOfString:@"."].location == NSNotFound) {
//            priceLabel.text = [NSString stringWithFormat:@"%ld", priceTextField.text.integerValue];
//        }else {
//            if ([priceLabel.text rangeOfString:@"."].location == priceLabel.text.length - 1) {
//                priceLabel.text = [NSString stringWithFormat:@"%ld", ([priceTextField.text substringWithRange:NSMakeRange(0, priceTextField.text.length - 1)]).integerValue];
//            }else if ([priceLabel.text rangeOfString:@"."].location == priceLabel.text.length - 2) {
//                priceLabel.text = [NSString stringWithFormat:@"%.2f", priceTextField.text.floatValue];
//            }
//        }
        buyPlaceLabel.text = buyPlaceTextField.text;
        if (goodsLabel.text.length > 0 || brandLabel.text.length > 0 || priceLabel.text.length > 0 || buyPlaceLabel.text.length > 0) {
            noteImg.hidden = YES;
            labelNote.hidden = YES;
        }else {
            noteImg.hidden = NO;
            labelNote.hidden = NO;
        }
    }];
}

- (void)cancelSelectLabel {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.labelSelectedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.labelSelectedView removeFromSuperview];
    }];
}


#pragma mark - ShareImageDetail controller delegate

- (void)shareImageDetailViewControllerDeleteThisImage:(BOOL)delete {
    
    if (delete) {
        
        [lastClickBtn removeFromSuperview];
        
        NSInteger imgCount = 0;
        for (UIButton *btn in self.imgBtns) {
            if (btn.imageView.image != nil) {
                imgCount ++;
            }
        }
        if (imgCount > 1) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (imgCount == 4) {
                [imgHolder addSubview:[self getAddBtn]];
            }
        }else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        [self.imgBtns removeObject:lastClickBtn];
        [self viewWillLayoutSubviews];
    }
}


#pragma mark - Scroll view delegate 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [textView resignFirstResponder];
}


#pragma mark - Show & Hidden commentView

-(void)keyboardWillAppear:(NSNotification *)notification {
    
    keyboardHeight = [self keyboardEndingFrameHeight:notification.userInfo];
    CGFloat pointY = shareMsgHolder.frame.origin.y - (kScreenHeight - keyboardHeight - shareMsgHolder.frame.size.height);
    [scrollView setContentOffset:CGPointMake(0, pointY) animated:YES];
}

-(void)keyboardWillDisappear:(NSNotification *)notification {
    
//    if (![textView isFirstResponder])    return;
//    
//    UIEdgeInsets edg = scrollView.contentInset;
//    edg.bottom = 0;
//    
//    [UIView animateWithDuration:0.2f animations:^{
//        
//        scrollView.contentInset = edg;
//    }];
}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo {
    
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    keyboardHeight = keyboardEndingFrame.size.height;
    return keyboardHeight;
}


#pragma mark - Activity Event

- (void)activityTap {
    
    ShareActivityViewController *acVC = [[ShareActivityViewController alloc] init];
    acVC.delegate = self;
    [self.navigationController pushViewController:acVC animated:YES];
}

- (void)deleteActivity {
    selectedActivity = nil;
    activityNameLabel.text = @"参与活动或主题";
    deleteAcBtn.hidden = YES;
}

#pragma mark - Activity vc delegate

- (void)shareActivityViewControllerDidSelectedActivity:(ShareActivityModel *)model {
    selectedActivity = model;
    activityNameLabel.text = selectedActivity.ActivityName;
    deleteAcBtn.hidden = NO;
}


#pragma mark - Text view delegate

- (void)textViewDidChange:(UITextView *)textV {

    textViewHolder.text = textV.text.length ? @"" : @"请输入5-700字的晒单心得";
    if (textV.text.length > 700) {
        textV.text = [textV.text substringWithRange:NSMakeRange(0, 700)];
//        [MBProgressHUD showError:@"Share心得最多700字哦, 亲删掉一些再发布吧" toView:self.view];
    }
}


#pragma mark - Text field delegate

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length > 30) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 30)];
        NSString *errorMsg = nil;
        if ([textField isEqual:goodsTextField]) {
            errorMsg = @"商品名太长啦, 最多30字哦";
        }else if ([textField isEqual:brandTextField]) {
            errorMsg = @"品牌名太长啦, 最多30字哦";
        }else if ([textField isEqual:buyPlaceTextField]) {
            errorMsg = @"购买地太长啦, 最多30字哦";
        }
        [MBProgressHUD showError:errorMsg toView:self.view];
    }
    if ([textField isEqual:priceTextField] && textField.text.length > 10) {
        [MBProgressHUD showError:@"价格太长啦, 最多10字哦" toView:self.view];
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 10)];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([textField isEqual:priceTextField]) {

        BOOL isHaveDian = YES;
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            isHaveDian = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
//                        [MBProgressHUD showError:@"亲，第一个数字不能为小数点" toView:self.view];
//                        [self showError:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
//                        [MBProgressHUD showError:@"亲，第一个数字不能为0" toView:self.view];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian = YES;
                        return YES;
                        
                    }else{
                        [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
//                        [MBProgressHUD showError:@"亲，您已经输入过小数点了" toView:self.view];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    //如果输入的是数字, 那么数字不能超过8位整数(千万)
                    NSLog(@"textfield:%f", textField.text.floatValue);
                    NSMutableString *priceStr = [textField.text mutableCopy];
                    [priceStr insertString:string atIndex:range.location];
                    
                    if ([priceStr floatValue] > 99999999) {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    
                    if (isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            return YES;
                        }else{
                            [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
//                            [MBProgressHUD showError:@"亲，您最多只能输入两位小数" toView:self.view];
                            return NO;
                        }
                    }else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
//        if ([string isEqualToString:@"."] &&
//            (range.location == 0 || ([textField.text rangeOfString:@"."].location != NSNotFound))) {
//            [MBProgressHUD showError:@"请输入正确的价格如：12.34" toView:self.view];
//            return NO;
//        }
//        
//        NSCharacterSet *cs;
//        cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbersPeriod] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL basic = [string isEqualToString:filtered];
//        return basic;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)stringIsPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)stringIsPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (void)hiddenKeyBoard {
    [textView resignFirstResponder];
    [goodsTextField resignFirstResponder];
    [brandTextField resignFirstResponder];
    [priceTextField resignFirstResponder];
    [buyPlaceTextField resignFirstResponder];
}

@end
