//
//  FeedbackViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/28.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIPlaceHolderTextView.h"

@interface FeedbackViewController ()<UITextViewDelegate>{
    UIPlaceHolderTextView    *   _messageView;
    UIButton                 *   _submitButton;
}

@end

@implementation FeedbackViewController

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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)loadView{
    [super loadView];
    self.title = @"意见反馈";
    //白色背景
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, kNavStatusHeight, self.view.frame.size.width, 280)];
    bgview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgview];
    
    _messageView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(7, kNavStatusHeight +2, kScreenWidth -14, 276)];
    //_messageView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth -20, 260)];
    _messageView.font = [UIFont systemFontOfSize:13];
    _messageView.returnKeyType = UIReturnKeyDone;
    _messageView.delegate = self;
//    _messageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _messageView.layer.borderWidth =0.5;
//    _messageView.layer.cornerRadius =2.0;;
    _messageView.placeholder = @"请输入对我们的建议和任何您在使用过程中遇到的问题！";
    _messageView.backgroundColor = [UIColor clearColor];
    
    //    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(message.jxRight-60, message.jxBottom-15, 50, 10)];
    //    [image setImage:[UIImage imageNamed:@"less140"]];
    //    [self.view addSubview:image];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(18,CGRectGetMaxY(_messageView.frame) + 18, kScreenWidth -36, 44);
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
    //[_submitButton setBackgroundColor:JX999999Color];
    _submitButton.layer.cornerRadius = 5.f;
    [_submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
//    [_submitButton setTitleColor:JXFfffffColor forState:UIControlStateNormal];
//    [_submitButton setBackgroundImage:JXImageNamed(@"btn_disabled") forState:UIControlStateNormal];
//    _submitButton.enabled = NO;
    
    [_submitButton setTitleColor:JX333333Color forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
    
    _submitButton.titleLabel.font = JXFontForNormal(16);
    _submitButton.layer.cornerRadius = 5.f;

    
    [self.view addSubview:_submitButton];
    [self.view addSubview:_messageView];
    
}


#pragma mark - Click events

- (void)submit:(id)sender
{
    [self.view endEditing:YES];
    if (_messageView.text.length == 0) {
        [self showJXNoticeMessage:@"您还未输入信息，无法提交"];
        return;
    } else if (_messageView.text.length >1500) {
        [self showJXNoticeMessage:@"字数超过1500"];
        return;
    }
//    [self showLoadView];
    [[UserRequest shareManager] userFeedback:kApiFeedback param:@{@"Con":_messageView.text} success:^(id object,NSString *msg) {
//        [self hideLoadView];
//        [self showJXNoticeMessage:@"提交成功"];
        [self showJXNoticeMessage:object];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id object,NSString *msg) {
        [self showJXNoticeMessage:msg];
//        [self hideLoadView];
    }];
}

#pragma mark --------------------------------UITextView delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 1500) {
        NSString * string = [NSString stringWithString:textView.text];
        textView.text = [string substringToIndex:1499];
        [self showJXNoticeMessage:@"字符个数不能大于1500"];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
//    if (textView.text.length > 1500) {
//        textView.text = [textView.text substringToIndex:1499];
//    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (range.location > 1499){
        NSString *string1 = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSString *string2;
        string2 = [string1 substringToIndex:1499];
        //string = [string substringWithRange:NSMakeRange(0, 1500)];
        textView.text = string2;
        [self showJXNoticeMessage:@"字符个数不能大于1500"];
    }
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}
@end
