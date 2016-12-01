//
//  ShopFeedbackController.m
//  GJieGo
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 yangzx. All rights reserved.
//  ---  店铺留言 ---

#import "ShopFeedbackController.h"
#import "UserDBManager.h"

@interface ShopFeedbackController ()<UIScrollViewDelegate ,UITextViewDelegate>{
    UIView *statusBackView;
    
    UILabel *placeholderLabel;
    
    NSInteger click;                //
    NSInteger Ia;                   //
    
    NSString *cellPhone;            //电话
    UIView *backView;               //textView背景
    
    UIScrollView *feedScrollView;
}
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *cellphoneButton;
@property (nonatomic, strong)UIButton *commitButton;
@end

@implementation ShopFeedbackController
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
    
    click = 0;
    cellPhone = @"";
    
    
    feedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    feedScrollView.delegate = self;
    feedScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 1);
    feedScrollView.backgroundColor = GJGRGB16Color(0xEBEBEB);
    [self.view addSubview:feedScrollView];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 0.66)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
//    label.text = @"最多输入1500字留言";
    label.textColor = GJGGRAYCOLOR;
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:12.0f];
    
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    self.textView.tintColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:12.0f];
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    placeholderLabel.text = @"请输入对我们的建议和任何您在使用过程中遇到的问题";
    placeholderLabel.font = [UIFont systemFontOfSize:12.0f];
    placeholderLabel.textColor = GJGRGB16Color(0x999999);
    self.cellphoneButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:@"发送您的联系方式给商家" titleSize:12.0f frame:CGRectMake(15, backView.frame.size.height + 55, 155, 20) Image:[UIImage imageNamed:@"shopfeedback_default"] target:self action:@selector(didClickCellphone:)];
    [self.cellphoneButton setImage:[UIImage imageNamed:@"shopfeedback_selected"] forState:UIControlStateSelected];
    [self.cellphoneButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    Ia = 0;
    self.cellphoneButton.selected = NO;
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom tag:0 title:@"提交" titleSize:15.0f frame:CGRectMake(15, backView.frame.size.height + 80, ScreenWidth - 30, 40) Image:nil target:self action:@selector(didClickCommitButton:)];
    self.commitButton.backgroundColor = GJGRGB16Color(0xc8c8c8);
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [feedScrollView addSubview:backView];
    [backView addSubview:self.textView];
    [backView addSubview:label];
    [self.textView addSubview:placeholderLabel];
    [feedScrollView addSubview:self.cellphoneButton];
    [feedScrollView addSubview:self.commitButton];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(backView).offset(-15);
        make.bottom.equalTo(backView).offset(-10);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backView).offset(10);
        make.top.equalTo(backView);
        make.trailing.equalTo(backView).offset(-15);
        make.height.equalTo(backView);
    }];
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.textView).offset(5);
        make.top.equalTo(self.textView).offset(6);
        
    }];
    [self.cellphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.bottom.equalTo(self.commitButton.top).offset(-10);
        make.width.equalTo(150);
        make.height.equalTo(20);
    }];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.top.equalTo(backView.bottom).offset(80);
        make.width.equalTo(ScreenWidth*0.92);
        make.height.equalTo(40);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [feedScrollView addGestureRecognizer:tap];
}

//-(void)textViewDidChange:(UITextView *)textView  {
//    if (textView.text.length < 1500) {
//        if (textView.text.length > 0) {
//        placeholderLabel.hidden = YES;
//        self.commitButton.backgroundColor = GJGRGB16Color(0xfee330);
//        [self.commitButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
//    }else{
//        placeholderLabel.hidden = NO;
//        self.commitButton.backgroundColor = GJGRGB16Color(0xc8c8c8);
//        [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
//    }else{
//        placeholderLabel.hidden = YES;
//        self.commitButton.backgroundColor = GJGRGB16Color(0xc8c8c8);
//        [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
//    
//}

#pragma mark - 监听textView
- (void)textViewDidChange:(UITextView *)textV {
    
    if (_textView.text.length <= 1500) {
        if (_textView.text.length > 0) {
        placeholderLabel.hidden = YES;
        self.commitButton.backgroundColor = GJGRGB16Color(0xfee330);
        [self.commitButton setTitleColor:GJGRGB16Color(0x333333) forState:UIControlStateNormal];
    }else{
        placeholderLabel.hidden = NO;
        self.commitButton.backgroundColor = GJGRGB16Color(0xc8c8c8);
        [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    }else{
        NSString *str = [textV.text substringToIndex:1500];
        _textView.text = str;
//        placeholderLabel.hidden = YES;
//        self.commitButton.backgroundColor = GJGRGB16Color(0xc8c8c8);
//        [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    CGFloat textViewH = 0;
    CGFloat minHeight = ScreenWidth * 0.66;
    CGFloat commentViewHeight = textViewH;
    CGSize size = CGSizeMake(ScreenWidth, ScreenHeight + 1);
    
    CGFloat contentHeight = _textView.contentSize.height;
    if (contentHeight < minHeight) {
        textViewH = minHeight;
        commentViewHeight = ScreenWidth * 0.66;
        size = CGSizeMake(ScreenWidth, ScreenHeight + 1);
    }else{
        textViewH = contentHeight;
        commentViewHeight = textViewH + 44;
        size = CGSizeMake(ScreenWidth, commentViewHeight + 450);
    }
    
    CGRect frame = backView.frame;
    frame.size.height = commentViewHeight;
    [UIView animateWithDuration:0.2 animations:^{
        backView.frame = frame;
        [backView layoutIfNeeded];
        feedScrollView.contentSize = size;
        [feedScrollView layoutIfNeeded];
    }];
    
    [_textView setContentOffset:CGPointZero animated:YES];
    [_textView scrollRangeToVisible:_textView.selectedRange];
}

#pragma mark - 监听scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y != 0) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark - 是否发送联系方式
- (void)didClickCellphone:(UIButton *)button{

    if (self.cellphoneButton.selected == NO) {
        self.cellphoneButton.selected = YES;
        cellPhone = [UserDBManager shareManager].PhoneNumber;
        Ia = 1;
    }else{
        self.cellphoneButton.selected = NO;
        cellPhone = @"";
        Ia = 0;
    }
}
- (void)delayMethod{
    isRequest = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
static BOOL isRequest = YES;
#pragma mark - 提交留言
- (void)didClickCommitButton:(UIButton *)button{
    [self.textView resignFirstResponder];
    
    
    if (isRequest == NO) {
        return;
    }
    isRequest = NO;
    
    [[LoginManager shareManager] checkUserLoginState:^{
       if (self.textView.text.length <= 1500) {
        if (self.textView.text.length > 0) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param addEntriesFromDictionary:@{@"Id":self.Id, @"It":self.It, @"Con":_textView.text, @"Ia":[NSString stringWithFormat:@"%ld", Ia]}];
           NSInteger stat = [request requestPostTypeWithUrl:kGJGRequestUrl(kGet_AddSuggestion) parameters:param requestblock:^(id responseobject, NSError *error) {
               
               if ([responseobject[@"status"] integerValue] == 0) {
                    
                    [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
                    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
                }else{
                    [self.view makeToast:responseobject[@"message"] duration:2 position:CSToastPositionCenter];
                }
            }];
            if (stat == ReachabilityStatusNotReachable) {
                isRequest = YES;
                [self.view makeToast:@"没有网络,请检查网络状态" duration:2 position:CSToastPositionCenter];
            }
        }else{
            isRequest = YES;
            [self.view makeToast:@"请输入您的留言" duration:2 position:CSToastPositionCenter];
        }
       }else{
           isRequest = YES;
           [self.view makeToast:@"请输入最多1500字的留言" duration:2 position:CSToastPositionCenter];
       }
        
}];
    
    
}

#pragma mark - 点击回收键盘
- (void)tapViewAction:(UITapGestureRecognizer *)tap{
    [self.textView resignFirstResponder];
}
@end
