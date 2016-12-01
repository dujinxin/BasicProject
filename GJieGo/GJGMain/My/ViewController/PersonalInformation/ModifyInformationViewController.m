//
//  ModifyInformationViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/25.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ModifyInformationViewController.h"

#import "ModifyPictureViewController.h"
#import "ModifyNameViewController.h"
#import "ModifyGenderViewController.h"

#import "MyCodeViewController.h"

typedef NS_ENUM(NSInteger, LoginViewControllerTag){
    ModifyInformationViewControllerUserImageViewTag      =    1,
    ModifyInformationViewControllerUserNameTag,
    ModifyInformationViewControllerUserGenderTag,
    
};

@interface ModifyInformationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView  * _tableView;
    NSArray      * _sectionArray;
    
    NSString     * _imageStr;
    NSString     * _nameStr;
    NSString     * _genderStr;
    
}

@end

@implementation ModifyInformationViewController

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
    
    _sectionArray = @[
                       @[@"当前账号",@"ID"],
                       @[@"我的邀请码"],
                       @[@"头像",@"昵称",@"性别"]
                       ];
    
    
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    self.title = @"修改个人信息";
//    if (self.isRegisterSuccessEnter) {
//        self.navigationItem.leftBarButtonItem = getBackItem(self, @selector(back));
//    }
    if (![UserDBManager shareManager].UserName || ![UserDBManager shareManager].UserName.length) {
        self.navigationItem.leftBarButtonItem = getBackItem(self, @selector(back));
    }
    [self setHeadView];
}
#pragma mark - click events
- (void)back{
    if (![UserDBManager shareManager].UserName || ![UserDBManager shareManager].UserName.length) {
        [self showJXNoticeMessage:@"请设置用户名"];
    }else{
        if (![kUserDefaults stringForKey:UDKEY_IsFirstLoginRegister]){
            [kUserDefaults setValue:@"1" forKey:UDKEY_IsFirstLoginRegister];
            [kUserDefaults synchronize];
            [[JXViewManager sharedInstance] dismissViewController:YES resetRootViewController:YES];
            NSLog(@"首次进入");
        }else{
            if (self.registerSuccessEnter) {
                if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                NSLog(@"注册进入");
            }else{
                if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                NSLog(@"其他进入");
            }
        }
    }
}
#pragma mark - subView init
- (void)setHeadView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 0.1;
    _tableView.backgroundColor = JXF1f1f1Color;
    [self.view addSubview:_tableView];
    [self  layoutSubView];
    
}
- (void)layoutSubView{
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sectionArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString  * cellIdentifier = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = JX333333Color;
        cell.textLabel.font = JXFontForNormal(13);
    }
    [cell.contentView removeAllSubviews];
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 200, 0, 160, 44)];
    infoLabel.tag = ModifyInformationViewControllerUserNameTag;
    infoLabel.textAlignment = NSTextAlignmentRight;
    infoLabel.textColor = JX999999Color;
    infoLabel.font = JXFontForNormal(13);
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:infoLabel];
    }else if (indexPath.section == 1) {
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 5, 9)];
        [arrow setImage:JXImageNamed(@"list_arrow")];
        [cell.contentView addSubview:arrow];
        
        UIImageView * codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 74, 5, 34, 34)];
        codeImageView.image = JXImageNamed(@"invite_code");
        [cell.contentView addSubview:codeImageView];
        
    }else{
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, 17, 5, 9)];
        [arrow setImage:JXImageNamed(@"list_arrow")];
        [cell.contentView addSubview:arrow];
        
        if (indexPath.row == 0) {
            UIImageView * userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 74, 5, 34, 34)];
            userImageView.tag = ModifyInformationViewControllerUserImageViewTag;
            userImageView.layer.cornerRadius = 17.0;
            userImageView.clipsToBounds = YES;
            [cell.contentView addSubview:userImageView];
        }else{
            [cell.contentView addSubview:infoLabel];
        }
    }
    UIView * line = [[UIView alloc ]initWithFrame:CGRectMake(0, 43.5, kScreenWidth, 0.5)];
    line.backgroundColor = JXSeparatorColor;
    [cell.contentView addSubview:line];
    
    NSArray * rowArray = _sectionArray[indexPath.section];
//    UILabel * infoLabel = (UILabel *)[cell.contentView viewWithTag:ModifyInformationViewControllerUserNameTag];
    cell.textLabel.text = rowArray[indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                infoLabel.text = [UserDBManager shareManager].PhoneNumber;
            }else{
                infoLabel.text = [UserDBManager shareManager].UserID;
            }
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                UIImageView * userImageView = (UIImageView *)[cell.contentView viewWithTag:ModifyInformationViewControllerUserImageViewTag];
                [userImageView sd_setImageWithURL:[NSURL URLWithString:[UserDBManager shareManager].UserImage] placeholderImage:JXImageNamed(@"portrait_default")];
            }else if(indexPath.row ==1){
                infoLabel.text = [UserDBManager shareManager].UserName;
            }else{
                if ([UserDBManager shareManager].UserGender.integerValue ==1){
                    infoLabel.text = @"女";
                }else{
                    infoLabel.text = @"男";
                }
            }
        }
            break;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        MyCodeViewController * cvc = [[MyCodeViewController alloc ]init ];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                ModifyPictureViewController * mvc = [[ModifyPictureViewController alloc] init ];
                mvc.imageUrl = @"";
                mvc.block = ^(id object){
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:mvc animated:YES];
            }
                break;
            case 1:
            {
                ModifyNameViewController * mvc = [[ModifyNameViewController alloc] init ];
                mvc.name = @"";
                mvc.block = ^(id object){
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:mvc animated:YES];
            }
                break;
            case 2:
            {
                ModifyGenderViewController * mvc = [[ModifyGenderViewController alloc] init ];
                mvc.gender = (NSNumber *)[UserDBManager shareManager].UserGender;
                mvc.block = ^(id object){
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:mvc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else{
        
    }
}

@end
