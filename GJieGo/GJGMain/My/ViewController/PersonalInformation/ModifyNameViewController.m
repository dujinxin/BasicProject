//
//  ModifyNameViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ModifyNameViewController.h"
#import "UserEntity.h"

@interface ModifyNameViewController ()<UITextFieldDelegate>{
    UITextField  * _userTextField;
    UIButton     * _saveButton;
}

@end

@implementation ModifyNameViewController

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
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;
    self.navigationItem.leftBarButtonItem = [self getNavigationItem:self selector:@selector(cancel:) title:JXLocalizedString(@"Cancel") style:kDefault];
//    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(save:) title:JXLocalizedString(@"Save") style:kDefault];
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(0, 0, 30, 30);
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:17];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    CGRect rect = [JXLocalizedString(@"Save") boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    _saveButton.frame = CGRectMake(0, 0, rect.size.width +4, 44);
    [_saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_saveButton setTitle:JXLocalizedString(@"Save") forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    //[_saveButton setTitleColor:JXEeeeeeColor forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    _saveButton.enabled = NO;
    
    _userTextField = [[UITextField alloc ]initWithFrame:CGRectMake(0,kNavStatusHeight+ 10, kScreenWidth, 44) ];
    _userTextField.backgroundColor = JXFfffffColor;
    _userTextField.textColor = JX333333Color;
    _userTextField.font = JXFontForNormal(13);
    _userTextField.borderStyle = UITextBorderStyleNone;
    _userTextField.leftViewMode = UITextFieldViewModeAlways;
    _userTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _userTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userTextField.delegate = self;
    _userTextField.leftView = ({
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26+5, 26)];
        leftView.contentMode = UIViewContentModeCenter;
        [leftView setImage:JXImageNamed(@"writeMobile")];
        leftView;
    });
    _userTextField.placeholder = @"名字不能为空";
    _userTextField.text = [UserDBManager shareManager].UserName;
    [self.view addSubview:_userTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark - click events
- (void)cancel:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(UIButton *)button{
    
    if (!_userTextField.text.length) {
        [self showJXNoticeMessage:@"昵称不能为空"];
        return;
    }
    if (_userTextField.text.length <2) {
        [self showJXNoticeMessage:@"昵称不能少于2个字符哦"];
        return;
    }
    if (_userTextField.text.length>12) {
        [self showJXNoticeMessage:@"昵称不能超过12个字符哦"];
        return;
    }
    if (![NSString validateUserName:_userTextField.text]){
        [self showJXNoticeMessage:@"昵称只能包含汉字、英文字母、数字、下划线哦"];
        return;
    }
    [self showLoadView];
    [[UserRequest shareManager] userName:kApiUserName param:@{@"Name":_userTextField.text} delegate:self];
    
//    [[UserRequest shareManager] userName:kApiUserName param:@{@"Name":_userTextField.text } success:^(id object) {
//        //
//        [self hideLoadView];
//        if ([[UserDBManager shareManager] modifyUserNickName:_userTextField.text]) {
//            [self showJXNoticeMessage:object];
//            
//            if ([[ChatManager shareManager] modifyUserNickName:_userTextField.text]) {
//                EMError * error = [[EMClient sharedClient] setApnsNickname:_userTextField.text];
//                if (!error) {
//                    NSLog(@"设置环信昵称成功");
//                }
//            }
//            if (_block) {
//                self.block(_userTextField.text);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        
//    } failure:^(id object) {
//        //
//        [self hideLoadView];
//        [self showJXNoticeMessage:object];
//    }];
}
#pragma mark --------------------------UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    self._strNewName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _userTextField){
        if (range.location > 11){
            NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            text = [text substringToIndex:11];
            textField.text = text;
            [self showJXNoticeMessage:@"字符个数不能大于12"];
        }
    }
    return YES;
}

- (void)textChange:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[UITextField class]]) {
        UITextField * textField = (UITextField *)notification.object;
        if (textField.text.length && _userTextField.text.length && ![_userTextField.text isEqualToString:[UserDBManager shareManager].UserName]) {
            _saveButton.enabled = YES;
            [_saveButton setTitleColor:JX333333Color forState:UIControlStateNormal];
            if (textField.text.length > 12){
                NSString *text = [textField.text substringToIndex:12];
                _userTextField.text = text;
                [self showJXNoticeMessage:@"字符个数不能大于12"];
            }
        }else{
            _saveButton.enabled = NO;
            [_saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userTextField resignFirstResponder];
}
#pragma mark – RequestDelegate
-(void)responseSuccessObj:(id)responseObj message:(NSString *)msg tag:(JX_APITAG)tag{
    
    [self hideLoadView];
    if ([[UserDBManager shareManager] modifyUserNickName:_userTextField.text]) {
        [self showJXNoticeMessage:msg];
        
        if ([[ChatManager shareManager] modifyUserNickName:_userTextField.text]) {
            EMError * error = [[EMClient sharedClient] setApnsNickname:_userTextField.text];
            if (!error) {
                NSLog(@"设置环信昵称成功");
            }
        }
        if (_block) {
            self.block(_userTextField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)responseFailed:(JX_APITAG)tag message:(NSString*)errMsg{
    [self hideLoadView];
    [self showJXNoticeMessage:errMsg];
}
@end
