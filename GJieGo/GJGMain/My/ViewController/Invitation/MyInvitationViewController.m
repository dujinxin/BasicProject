//
//  MyInvitationViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/11/23.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "MyInvitationViewController.h"
#import "PayScanViewController.h"

@interface MyInvitationViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    UILabel     * _textLabel;
    UITextField * _textField;
    UIButton    * _scanButton;
    UIButton    * _confirmButton;
    
    UILabel     * _codeLabel;
    UIImageView * _userImage;
    UILabel     * _userName;
    UILabel     * _statusLabel;
}

@property (nonatomic, strong)UILabel     * textLabel;
@property (nonatomic, strong)UITextField * textField;
@property (nonatomic, strong)UIButton    * scanButton;
@property (nonatomic, strong)UIButton    * confirmButton;

@property (nonatomic, strong)UILabel     * codeLabel;
@property (nonatomic, strong)UIImageView * userImage;
@property (nonatomic, strong)UILabel     * userName;
@property (nonatomic, strong)UILabel     * statusLabel;
@end

@implementation MyInvitationViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    [DJXRequest requestWithBlock:kApiInvitation param:nil success:^(id object,NSString *msg) {
        if ([object isKindOfClass:[NSDictionary class]]){
            _dictionary = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
            [self setFinishedUI];
            [self setData];
        }else{
            [self setFinishingUI];
        }
    } failure:^(id object,NSString *msg) {
        //
    }];
}
- (void)didReceiveMemoryWarning{
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)loadView{
    [super loadView];
    self.title = @"我的邀请人";
    
}

#pragma mark - UI set
- (void)setFinishedUI{
    UIView * topView = [UITool createBackgroundViewWithColor:JXFfffffColor frame:CGRectZero];
    [self.view addSubview:topView];
    
    UIView * centerView = [UITool createBackgroundViewWithColor:JXFfffffColor frame:CGRectZero];
    [self.view addSubview:centerView];
    
    UIView * bottomView = [UITool createBackgroundViewWithColor:JXFfffffColor frame:CGRectZero];
    [self.view addSubview:bottomView];
    
    NSArray * titleArray = @[@"您已绑定邀请码：",@"邀请人：",@"邀请状态："];
    for (int i = 0; i < titleArray.count; i ++) {
        UIView * contentView = [UITool createBackgroundViewWithColor:JXFfffffColor frame:CGRectZero];
        contentView.tag = i;
        [self.view addSubview:contentView];
        
        UILabel * leftLabel = [UILabel new];
        leftLabel.text = titleArray[i];
        leftLabel.textColor = JX333333Color;
        leftLabel.backgroundColor = JXDebugColor;
        leftLabel.font = JXFontForNormal(14);
        leftLabel.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:leftLabel];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).offset(0);
            if (i == 0) {
                make.top.equalTo(self.view).offset(kNavStatusHeight + 10*(i+1));
                make.height.equalTo(75);
            }else if(i == 1){
                make.top.equalTo(self.view).offset(kNavStatusHeight + 10*(i+1) +75);
                make.height.equalTo(117);
            }else{
                make.top.equalTo(self.view).offset(kNavStatusHeight + 10*(i+1) +75 + 117);
                make.height.equalTo(75);
            }
        }];
        
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.left).offset(26);
            if (i == 1) {
                make.top.equalTo(contentView).offset(20);
                make.height.equalTo(14);
            }else{
                make.centerY.equalTo(contentView.centerY);
            }
        }];
        
        if (i == 0) {
            [contentView addSubview:self.codeLabel];
            [self.codeLabel makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView.centerY);
                make.right.equalTo(contentView.right).offset(-26);
            }];
        }else if (i == 1){
            [contentView addSubview:self.userImage];
            [contentView addSubview:self.userName];
            [self.userImage makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.centerX);
                make.top.equalTo(contentView).offset(26);
                make.height.and.width.equalTo(50);
            }];
            [self.userName makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView.centerX);
                make.top.equalTo(self.userImage.bottom).offset(10);
                make.height.equalTo(11);
            }];
        }else{
            [contentView addSubview:self.statusLabel];
            [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(contentView.centerY);
                make.right.equalTo(contentView.right).offset(-26);
            }];
        }
    }
    
}
- (void)setFinishingUI{
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.scanButton];
    [self.view addSubview:self.confirmButton];
    
    [self layoutFinishingUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)layoutFinishedUI{
    
}
- (void)layoutFinishingUI{
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(kNavStatusHeight +24.f);
        make.left.equalTo(self.view.left).offset(24.f);
        make.right.equalTo(self.view.right).offset(-24.f);
        make.height.equalTo(14);
    }];
    UIView * line1 = [UITool createBackgroundViewWithColor:JXSeparatorColor frame:CGRectZero];
    [self.view addSubview:line1];
    
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.bottom).offset(20.f);
        make.left.equalTo(self.view.left).offset(15.f);
        make.right.equalTo(self.view.right).offset(-15.f);
        make.height.equalTo(1);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.bottom).offset(0.f);
        make.left.equalTo(self.view.left).offset(24.f);
        //make.right.equalTo(self.view.right).offset(-15.f);
        make.height.equalTo(54);
    }];
    
    [self.scanButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.bottom).offset(0.f);
        //make.left.equalTo(self.view.right).offset(-24.f);
        make.right.equalTo(self.view.right).offset(-24.f);
        make.height.equalTo(54);
    }];
    UIView * line2 = [UITool createBackgroundViewWithColor:JXColorFromRGB(0xa5a5a5) frame:CGRectZero];
    [self.view addSubview:line2];
    
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scanButton.centerY);
        make.right.equalTo(self.scanButton.left).offset(-20.f);
        make.height.equalTo(29);
        make.width.equalTo(0.5);
    }];
    
    UIView * line3 = [UITool createBackgroundViewWithColor:JXSeparatorColor frame:CGRectZero];
    [self.view addSubview:line3];
    
    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanButton.bottom).offset(0.f);
        make.left.equalTo(self.view.left).offset(15.f);
        make.right.equalTo(self.view.right).offset(-15.f);
        make.height.equalTo(1);
    }];
    
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.bottom).offset(20.f);
        make.left.equalTo(self.view.left).offset(15.f);
        make.right.equalTo(self.view.right).offset(-15.f);
        make.height.equalTo(44);
    }];
    
    
}
#pragma mark - set data
- (void)setData{
    if ([_dictionary[@"Code"] isKindOfClass:[NSNull class]] ||[_dictionary[@"Image"]isKindOfClass:[NSNull class]] ||[_dictionary[@"Name"] isKindOfClass:[NSNull class]]) {
        [self showJXNoticeMessage:@"接口数据不全，无法显示"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.codeLabel.text = [NSString stringWithFormat:@"%@",_dictionary[@"Code"]];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:_dictionary[@"Image"]] placeholderImage:JXImageNamed(@"portrait_default")];
    self.userName.text = [NSString stringWithFormat:@"%@",_dictionary[@"Name"]];
    self.statusLabel.text = @"成功";
    
    if ([_dictionary[@"Type"] intValue] == 1) {
        self.userImage.layer.cornerRadius = 25.f;
    }else{
        self.userImage.layer.cornerRadius = 0;
    }
}
#pragma mark - lazy load
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.backgroundColor = JXDebugColor;
        _textLabel.text = @"您的邀请码：";
        _textLabel.font = JXFontForNormal(14);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = JXTextColor;
    }
    return _textLabel;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.backgroundColor = JXClearColor;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _textField.delegate = self;
        _textField.placeholder = @"请输入邀请码";
        _textField.textColor = JXColorFromRGB(0xa5a5a5);
        _textField.font = JXFontForNormal(15);
    }
    return _textField;
}
- (UIButton *)scanButton{
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
        [_scanButton setImage:JXImageNamed(@"invite_code") forState:UIControlStateNormal];
        [_scanButton setTitleColor:JX333333Color forState:UIControlStateNormal];
        _scanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_scanButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [_scanButton setBackgroundColor:JXDebugColor];
        _scanButton.titleLabel.font = JXFontForNormal(14);
        [_scanButton addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}
- (UIButton *)confirmButton{
    if (!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        //    [_registerButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
        //    [_registerButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = JXFontForNormal(16);
        _confirmButton.layer.cornerRadius = 5.f;
        _confirmButton.enabled = NO;
        [_confirmButton addTarget:self action:@selector(confirmEvent:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _confirmButton;
}


- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [UILabel new];
        _codeLabel.backgroundColor = JXDebugColor;
        _codeLabel.font = JXFontForNormal(20);
        _codeLabel.textAlignment = NSTextAlignmentRight;
        _codeLabel.textColor = JXTextColor;
    }
    return _codeLabel;
}
- (UIImageView *)userImage{
    if (!_userImage) {
        _userImage = [UIImageView new];
        _userImage.backgroundColor = JXDebugColor;
        _userImage.image = JXImageNamed(@"portrait_default");
        _userImage.layer.masksToBounds = YES;
    }
    return _userImage;
}
- (UILabel *)userName{
    if (!_userName) {
        _userName = [UILabel new];
        _userName.backgroundColor = JXDebugColor;
        _userName.text = @"";
        _userName.font = JXFontForNormal(11);
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.textColor = JXTextColor;
    }
    return _userName;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.backgroundColor = JXDebugColor;
        _statusLabel.text = @"成功";
        _statusLabel.font = JXFontForNormal(20);
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = JXColorFromRGB(0xf74952);
    }
    return _statusLabel;
}
#pragma mark - click events
- (void)scan:(UIButton *)button{
    PayScanViewController * svc = [[PayScanViewController alloc ]init ];
    svc.backBlock = ^(id object){
        _textField.text = object;
        
        _confirmButton.enabled = YES;
        [_confirmButton setTitleColor:JX333333Color forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)confirmEvent:(UIButton *)button{
    if (![NSString validateInvitationCode: _textField.text]) {
        [self showJXNoticeMessage:@"此邀请码不存在，请重新输入"];
        return ;
    }
    if (_textField.text.length != 9){
        [self showJXNoticeMessage:@"此邀请码不存在，请重新输入"];
        return ;
    }
    UIAlertView * alert = [[UIAlertView alloc ]initWithTitle:@"确认邀请码后不可变更，是否确认？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 1) {
        NSLog(@"确定！");
        [self showLoadView];
        [DJXRequest requestWithBlock:kApiInvite param:@{@"code":_textField.text} success:^(id object,NSString *msg) {
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id object,NSString *msg) {
            [self hideLoadView];
            [self showJXNoticeMessage:msg];
        }];
    }
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (range.location > 8){
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        text = [text substringToIndex:8];
        textField.text = text;
        [self showJXNoticeMessage:@"字符个数不能大于9"];
    }
    
    return YES;
}
#pragma mark - text Notification
- (void)textChange:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[UITextField class]]) {
        UITextField * textField = (UITextField *)notification.object;
        if (textField.text.length) {
            _confirmButton.enabled = YES;
            [_confirmButton setTitleColor:JX333333Color forState:UIControlStateNormal];
            [_confirmButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
        }else{
            _confirmButton.enabled = NO;
            [_confirmButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
            [_confirmButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
        }
    }
}
#pragma mark - touch events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}
@end
