//
//  ShareManager.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "ShareManager.h"
#import "UMSocial.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@implementation ShareManager

static ShareManager * manager = nil;
+(ShareManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ShareManager alloc]init ];
        
    });
    return manager;
}
- (JXSelectView *)shareView{
    if (!_shareView) {
        _shareView = [[JXSelectView alloc]initWithCustomView:self.contentView];
        _shareView.selectViewPosition = JXSelectViewShowPositionBottom;
        _shareView.useTopButton = NO;
    }
    return _shareView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [self layoutShareView];
    }
    return _contentView;
}

- (void)dismiss{
    [self.shareView dismiss];
}

- (UIView *)layoutShareView{
    UIView * view = [UITool createBackgroundViewWithColor:[UIColor whiteColor] frame:CGRectMake(0, 0, kScreenWidth, 173)];
    UIView * title = [UITool createLabelWithText:@"分享到" textColor:JX333333Color font:JXFontForNormal(14) frame:CGRectMake(0, 0, kScreenWidth, 40)];
    [view addSubview:title];
    
    NSArray * titleArray = @[@"QQ好友",@"QQ空间",@"微信",@"朋友圈"];
    NSArray * imageArray = @[@"qq",@"kongjian",@"weixin",@"pengyouquan"];
    CGFloat width = kScreenWidth /titleArray.count;
    CGFloat height = 73;
    CGFloat space = 0;
//    CGFloat space = (kScreenWidth - width*3)/4;
    
    for (int i = 0 ; i < titleArray.count; i++) {
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [btn setFrame:CGRectMake(space +(width +space)*i, 40, width, height)];
        [btn setFrame:CGRectMake(space +(width +space)*i, 40, width, height)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:JX333333Color forState:UIControlStateNormal];
        //[btn setBackgroundImage:JXImageNamed(imageArray[i]) forState:UIControlStateNormal];
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [btn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 +i;
        [view addSubview:btn];
        //btn.backgroundColor = JXDebugColor;
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth /titleArray.count -43)/2, 0, 43, 43)];
        [image setImage:JXImageNamed(imageArray[i])];
        [btn addSubview:image];
        
    }
    UIView * line = [UITool createBackgroundViewWithColor:JXSeparatorColor frame:CGRectMake(0, 123, kScreenWidth, 1)];
    [view addSubview:line];
    
    UIButton * cancel  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancel setFrame:CGRectMake(0, 124, kScreenWidth, 49)];
    [cancel setBackgroundColor:JXFfffffColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:JXTextColor forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 110;
    [view addSubview:cancel];
    return view;
}
-(void)shareTo:(UIButton *)button{
    
    [self dismiss];
    
    UserShareSns sns = ShareToWechatSession;
    NSArray * SNSType;
    UIImage * image;
    if ([_imageUrl hasPrefix:@"http"]) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]]];
    }else{
        image = [UIImage imageNamed:@"image_four"];//JXImageFile(_imageUrl);
    }
    CLLocation * location;
    UMSocialUrlResource * urlResource;
    BOOL isAppInstalled = NO;

    //QQ分享消息类型分为图文、纯图片，
    //QQ空间分享只支持图文分享（图片文字缺一不可）
    //微信分享消息类型分为图文、纯图片、纯文字、应用三种类型，默认分享类型为图文分享，即展示分享文字及图片缩略图，点击后跳转到预设链接
    switch (button.tag) {
        case 100:
        {
            SNSType = @[UMShareToQQ];
            sns = ShareToQQ;
            [UMSocialData defaultData].extConfig.qqData.title = _title;
            [UMSocialData defaultData].extConfig.qqData.url = _url;
            
            isAppInstalled = [self checkIsAppInstalled:ShareToQQ];
        }
            break;
        case 101:
        {
            SNSType = @[UMShareToQzone];
            sns = ShareToQzone;
            [UMSocialData defaultData].extConfig.qzoneData.title = _title;
            [UMSocialData defaultData].extConfig.qzoneData.url = _url;
            
            isAppInstalled = [self checkIsAppInstalled:ShareToQzone];
        }
            break;
        case 102:
        {
            sns = ShareToWechatSession;
            SNSType = @[UMShareToWechatSession];
            [UMSocialData defaultData].extConfig.wechatSessionData.title = _title;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
            
            isAppInstalled = [self checkIsAppInstalled:ShareToWechatSession];
        }
            break;
        case 103:
        {
            sns = ShareToWechatTimeline;
            SNSType = @[UMShareToWechatTimeline];
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = _title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
            
            isAppInstalled = [self checkIsAppInstalled:ShareToWechatTimeline];
        }
            break;
    }
    if (!isAppInstalled) {//现在默认使用友盟提示
        if (button.tag == 100 || button.tag == 101){
            [[JXViewManager sharedInstance] showJXNoticeMessage:@"您的设备未安装QQ"];
        }else{
            [[JXViewManager sharedInstance] showJXNoticeMessage:@"您的设备未安装微信"];
        }
        return;
    }
    if ([SNSType.firstObject isEqualToString:UMShareToQzone] && !image && !_content) {
        NSLog(@"分享到QQ空间必须设置图片+文字消息");
        return;
    }
    if (_shareType <0) {
        NSLog(@"分享类型缺失");
        return;
    }
    if (_infoId == nil) {
        NSLog(@"分享信息编号缺失");
        return;
    }

    JXDispatch_async_global((^{
        [DJXRequest requestWithBlock:kApiShareSuccess param:@{@"InfoId":_infoId ,@"infoType":@(_shareType),@"ShareTo":@(sns)} success:^(id object,NSString *msg) {
        //[self showJXNoticeMessage:object];
        _noticeMsg = msg;
        if (![kUserDefaults stringForKey:UDKEY_ShareNotice]){
            [kUserDefaults setValue:_noticeMsg forKey:UDKEY_ShareNotice];
            [kUserDefaults synchronize];
        }
            
    } failure:^(id object,NSString *msg) {}];
    }));
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:SNSType content:_content image:image location:location urlResource:urlResource presentedController:_presentedController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功 = %@",response.data);
            if (_success) {
                self.success(response.data,sns);
            }
        }else{
            NSLog(@"分享取消或失败 = %@",response.description);
            if (_failure) {
                self.failure(response.message,sns);
            }
        }
//        if (_noticeMsg) {
//            [[JXViewManager sharedInstance] showJXNoticeMessage:_noticeMsg];
//            if (![kUserDefaults stringForKey:UDKEY_ShareNotice]){
//                [kUserDefaults removeObjectForKey:UDKEY_ShareNotice];
//                [kUserDefaults synchronize];
//            }
//        }
    }];
    
}
- (void)cancel:(UIButton *)button{
    [self dismiss];
}
- (BOOL)checkIsAppInstalled:(UserShareSns)sns{

    switch (sns) {
        case ShareToQQ:
        case ShareToQzone:
        {
            return [QQApiInterface isQQInstalled];
        }
            break;
        case ShareToWechatSession:
        case ShareToWechatTimeline:
        {
            return [WXApi isWXAppInstalled];
        }
            break;
            
        default:
            break;
    }
    return NO;
}
- (void)showCustomShareViewWithObject:(id)object presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure{
    
    [self showCustomShareViewWithObject:object shareType:-1 presentedController:presentedController success:success failure:failure];
}
- (void)showCustomShareViewWithObject:(id)object shareType:(UserShareType)type presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure{
    if (object) {
        if ([object isKindOfClass:[ShareEntity class]]) {
            _entity = (ShareEntity *)object;
        }else if ([object isKindOfClass:[NSDictionary class]]){
            NSDictionary * dict = (NSDictionary *)object;
            _entity = [ShareEntity mj_objectWithKeyValues:dict];
        }else{
            NSLog(@"未知类型，暂不支持！");
            return;
        }
        _imageUrl = _entity.Images;
        _title = _entity.Title;
        _content = _entity.Content;
        _url = _entity.Url;
        _infoId = _entity.InfoId;
    }else{
        NSLog(@"分享内容不可为空！");
        return;
    }
    _shareType = type;
    _success = success;
    _failure = failure;
    _presentedController = presentedController;
    
    [[LoginManager shareManager] checkUserLoginState:^{
        [self.shareView show];
    }];
}
- (void)showCustomShareViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure{
    [self showCustomShareViewWithContent:content title:title imageUrl:imageUrl url:url description:description infoId:nil shareType:-1 presentedController:presentedController success:success failure:failure];
}
- (void)showCustomShareViewWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl url:(NSString *)url description:(NSString *)description infoId:(NSString *)infoId shareType:(UserShareType)type presentedController:(UIViewController *)presentedController success:(void(^)(id object,UserShareSns sns))success failure:(void(^)(id object,UserShareSns sns))failure{
    _title = title;
    _content = content;
    _imageUrl = imageUrl;
    _url = url;
    _Descirption = description;
    _shareType = type;
    _infoId = infoId;
    _presentedController = presentedController;
    _success = success;
    _failure = failure;
    
    [[LoginManager shareManager] checkUserLoginState:^{
        [self.shareView show];
    }];
}
@end


@implementation ShareEntity

@end
