//
//  ModifyPictureViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ModifyPictureViewController.h"
#import "UILabel+Category.h"
#import "UserEntity.h"

@interface ModifyPictureViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    UIImageView * _userImageView;
    UIButton    * _functionButton;
    
    UIImage     * _originImage;
    BOOL          _isPictureChanged;
}

@end

@implementation ModifyPictureViewController

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
    [self setSubView];
    [self layoutSubView];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = JXF1f1f1Color;
    self.navigationItem.leftBarButtonItem = [self getNavigationItem:self selector:@selector(cancel:) title:JXLocalizedString(@"Cancel") style:kDefault];
    self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(save:) title:JXLocalizedString(@"Save") style:kDefault];
    
    _userImageView = [UIImageView new];
    _functionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
}
- (void)setSubView{
    _userImageView.backgroundColor = JXEeeeeeColor;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:[UserDBManager shareManager].UserImage] placeholderImage:JXImageNamed(@"portrait_default_big")];
    [self.view addSubview:_userImageView];
    
    _functionButton.backgroundColor = JXMainColor;
    [_functionButton setTitle:@"更换头像" forState:UIControlStateNormal];
    [_functionButton setTitleColor:JX333333Color forState:UIControlStateNormal];
    [_functionButton addTarget:self action:@selector(changeUserPicture:) forControlEvents:UIControlEventTouchUpInside];
    [_functionButton.layer setCornerRadius:3];
    
    [self.view addSubview:_functionButton];
}
- (void)layoutSubView{
    [_userImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.width.equalTo(self.view);
//        make.height.equalTo(314*kPercent);
        make.height.equalTo(self.view.jxWidth);
    }];
    [_functionButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(_userImageView.bottom).offset(20);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(kPercent *44);
    }];
}

#pragma mark - click events 
- (void)cancel:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(UIButton *)button{

    if (!_isPictureChanged){
        [self showJXNoticeMessage:@"您没有更换图片哦！"];
        return;
    }
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userImage.jpg"];
    NSFileManager *fileMag = [NSFileManager defaultManager];
    if ([fileMag fileExistsAtPath:filePath])
    {
        [self showLoadView];
//        [[UserRequest shareManager] userImage:kApiUserImage param:nil success:^(id object) {
//            [self hideLoadView];
//            if ([[UserDBManager shareManager] modifyUserImage:object]) {
//                [self showJXNoticeMessage:object];
//                if ([[ChatManager shareManager] modifyUserNickName:object]) {
//                    NSLog(@"更换环信头像成功");
//                }
//                if (_block) {
//                    self.block(object);
//                }
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        } failure:^(id object) {
//            [self hideLoadView];
//            [self showJXNoticeMessage:object];
//        }];
        [[UserRequest shareManager] userImage:kApiUserImage param:nil delegate:self];
    }
    
}
- (void)changeUserPicture:(UIButton *)button{

    if (kIOS_VERSION >= 8) {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * pictureAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //拍照
            [self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypeCamera]];
        }];
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //相册选择
            [self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypePhotoLibrary]];
            
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:pictureAction];
        [alertVC addAction:cameraAction];
        [alertVC addAction:cancelAction];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
//        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
//        UIFont *font = [UIFont systemFontOfSize:15];
//        [appearanceLabel setAppearanceFont:font];
        [pictureAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cameraAction setValue:JXTextColor forKey:@"_titleTextColor"];
        [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }else{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"相册", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tintColor = JXTextColor;//不起作用
        [actionSheet showInView:self.view];
        //注意整个工程的view 都会被修改
       // [[UIView appearance] setTintColor:JXTextColor];
    }
    
    
}
#pragma mark –-------------------------UIActionSheetDelegate
// iOS8.0之前可用
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:JXTextColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypeCamera]];
    }
    if (buttonIndex == 1) {
        //相册选择
        [self performSelector:@selector(showImagePicker:) withObject:[NSNumber numberWithInt:UIImagePickerControllerSourceTypePhotoLibrary]];
    }
    
}
- (void)showImagePicker:(NSNumber*)sourceType
{
    //sourceType=0相机，1相册
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.title = @"选择照片";
    imagepicker.navigationBar.barTintColor = JXMainColor;
    imagepicker.navigationBar.backIndicatorImage = [JXImageNamed(@"back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imagepicker.navigationBar.backIndicatorTransitionMaskImage = [JXImageNamed(@"back") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [[UIView appearance] setTintColor:JXTextColor];
    imagepicker.navigationItem.rightBarButtonItem.tintColor = JXTextColor;
    
    [imagepicker setDelegate:self];
    [imagepicker setAllowsEditing:YES];
    [imagepicker setSourceType:[sourceType intValue]];
    
    [self presentViewController:imagepicker animated:NO completion:nil];
}
#pragma mark –-------------------------Camera View Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        [picker dismissViewControllerAnimated:NO completion:nil];
        
        _originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        _originImage = [UIImage imageWithImageSimple:_originImage scaledToSize:CGSizeMake(kScreenWidth, kScreenWidth)];
        [NSString saveImage:_originImage WithName:@"userImage.jpg"];
        
        _userImageView.image = _originImage;
        
        //imageV.image = originImage;
        _isPictureChanged = YES;
        
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}
#pragma mark – RequestDelegate
-(void)responseSuccessObj:(id)responseObj message:(NSString *)msg tag:(JX_APITAG)tag{
    [self hideLoadView];
    if ([[UserDBManager shareManager] modifyUserImage:responseObj]) {
        [self showJXNoticeMessage:msg];
        if ([[ChatManager shareManager] modifyUserImage:responseObj]) {
            NSLog(@"更换环信头像成功");
        }
        if (_block) {
            self.block(responseObj);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)responseFailed:(JX_APITAG)tag message:(NSString*)errMsg{
    [self hideLoadView];
    [self showJXNoticeMessage:errMsg];
}

@end
