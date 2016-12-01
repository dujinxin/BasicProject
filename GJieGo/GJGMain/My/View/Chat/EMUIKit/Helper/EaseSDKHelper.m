/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import "EaseSDKHelper.h"

#import "EaseConvertToCommonEmoticonsHelper.h"

//@interface EMChatImageOptions : NSObject<IChatImageOptions>
//
//@property (assign, nonatomic) CGFloat compressionQuality;
//
//@end

static EaseSDKHelper *helper = nil;

@implementation EaseSDKHelper

@synthesize isShowingimagePicker = _isShowingimagePicker;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

+(instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[EaseSDKHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - private

- (void)commonInit
{
    
}

#pragma mark - app delegate notifications

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)_setupAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)appDidEnterBackgroundNotif:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}

#pragma mark - register apns
// 注册推送
- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
//        UIMutableUserNotificationAction *action1;
//        action1 = [[UIMutableUserNotificationAction alloc] init];
//        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
//        [action1 setTitle:@"取消"];
//        [action1 setIdentifier:NotificationActionOneIdent];
//        [action1 setDestructive:NO];
//        [action1 setAuthenticationRequired:NO];
//        
//        UIMutableUserNotificationAction *action2;
//        action2 = [[UIMutableUserNotificationAction alloc] init];
//        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
//        [action2 setTitle:@"回复"];
//        [action2 setIdentifier:NotificationActionTwoIdent];
//        [action2 setDestructive:NO];
//        [action2 setAuthenticationRequired:NO];
//        
//        UIMutableUserNotificationCategory *actionCategory;
//        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
//        [actionCategory setIdentifier:NotificationCategoryIdent];
//        [actionCategory setActions:@[action1, action2]
//                        forContext:UIUserNotificationActionContextDefault];
//        
//        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);

        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

#pragma mark - init easemob

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册AppDelegate默认回调监听
    [self _setupAppDelegateNotifications];
    
    //注册apns
    [self _registerRemoteNotification];

    [EMClient sharedClient].pushOptions.noDisturbStatus =EMPushNoDisturbStatusClose;
    [EMClient sharedClient].pushOptions.displayStyle = EMPushDisplayStyleMessageSummary;
    EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
    if (!error){
        NSLog(@"更新推送配置成功");
    }
    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.apnsCertName = apnsCertName;
    options.isAutoAcceptGroupInvitation = NO;
    if ([otherConfig objectForKey:kSDKConfigEnableConsoleLogger]) {
        options.enableConsoleLog = YES;
    }
    
//    BOOL sandBox = [otherConfig objectForKey:@"easeSandBox"] && [[otherConfig objectForKey:@"easeSandBox"] boolValue];
//    if (!sandBox) {
        [[EMClient sharedClient] initializeSDKWithOptions:options];
//    }
}

- (void)dealloc
{
    
}

#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)toUser
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt

{
    // 表情映射。
    NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:willSendText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:[self customMessageExt:messageExt]];
    
    return message;
}

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt
{
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithLatitude:latitude longitude:longitude address:address];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self customMessageExt:messageExt]];
    
    return message;
}

+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:@"image.png"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self customMessageExt:messageExt]];
    
    return message;
}

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    return [self sendImageMessageWithImageData:data to:to messageType:messageType messageExt:[self customMessageExt:messageExt]];
}

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:localPath displayName:@"audio"];
    body.duration = (int)duration;
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self customMessageExt:messageExt]];
    
    return message;
}

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:[url path] displayName:@"video.mp4"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:[self customMessageExt:messageExt]];
    
    return message;
}
//custom
+ (NSDictionary *)customMessageExt:(NSDictionary *)ext{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:ext];
    [dict setValue:[UserDBManager shareManager].UserID forKey:@"userId"];
    [dict setValue:[UserDBManager shareManager].HxAccount forKey:@"userName"];
    [dict setValue:[UserDBManager shareManager].UserImage forKey:@"head"];
    if ([UserDBManager shareManager].UserName) {
        [dict setValue:[UserDBManager shareManager].UserName forKey:@"name"];
    }else{
        NSString * nickName = [[UserDBManager shareManager].PhoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [dict setValue:nickName forKey:@"name"];
    }
    [dict setValue:@{
        @"alert":@"你收到了一条消息",
        @"badge":@0,
        @"sound":@"default"
        } forKey:@"aps"];
    [dict setValue:@(true) forKey:@"em_force_notification"];
    [dict setValue:@{@"note":@{@"NoteType" : @100}} forKey:@"em_apns_ext"];
    return dict;
}
@end
