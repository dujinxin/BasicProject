//
//  GJGStatisticManager.m
//  GJieGo
//
//  Created by gjg on 16/8/8.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GJGStatisticManager.h"

#define GJGStatisticFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GJGStatistic.txt"]


@interface GJGStatisticManager ()
@property (nonatomic,copy) NSString *ItemType;

@end

@implementation GJGStatisticManager

static GJGStatisticManager *instance;
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GJGStatisticManager alloc] init];
    });
    
    return instance;
}
- (void)statisticByEventID:(NSString *)EventID andBCID:(NSString *)BCID andMallID:(NSString *)MallID andShopID:(NSString *)ShopID andItemType:(NSString *)ItemType andBusinessType:(NSString *)BusinessType andItemID:(NSString *)ItemID andItemText:(NSString *)ItemText andOpUserID:(NSString *)OpUserID{
    self.ItemType = ItemType;
    
    [self statisticByEventID:EventID andBCID:BCID andMallID:MallID andShopID:ShopID andBusinessType:BusinessType andItemID:ItemID andItemText:ItemText andOpUserID:OpUserID];
    
}

- (void)statisticByEventID:(NSString *)EventID andBCID:(NSString *)BCID andMallID:(NSString *)MallID andShopID:(NSString *)ShopID andBusinessType:(NSString *)BusinessType andItemID:(NSString *)ItemID andItemText:(NSString *)ItemText andOpUserID:(NSString *)OpUserID{
    
    if (EventID == nil){
        EventID = @"";
    }
    if (BCID == nil) {
        BCID = @"0";
    }
    if (MallID == nil) {
        MallID = @"0";
    }
    if (ShopID == nil) {
        ShopID = @"0";
    }
    if (BusinessType == nil) {
        BusinessType = @"";
    }
    if (ItemID == nil) {
        ItemID = @"0";
    }
    if (ItemText == nil) {
        ItemText = @"";
    }
    if (OpUserID == nil) {
        OpUserID = @"0";
    }
    if (self.ItemType == nil) {
        self.ItemType = @"0";
    }
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *codeTime = [userDefaults objectForKey:@"codeTime"];
    long long code_time;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long CreateDate = [[NSNumber numberWithDouble:time] longLongValue] * 1000;
    
    if (codeTime.floatValue == 0 || codeTime == nil) {
        [userDefaults setObject:@(CreateDate) forKey:@"codeTime"];
        [userDefaults synchronize];
        code_time = CreateDate;
    }else{
        code_time = [codeTime longLongValue];
    }
    
    double timeDifference = CreateDate - code_time;
    
    NSLog(@"1970年毫秒数,%@",@(CreateDate));
    
    NSString *jsonStr = [NSString stringWithFormat:@"{\"EventID\" : \"%@\",\"BCID\" : %@,\"MallID\" : %@,\"ShopID\" : %@,\"ItemType\" : %@,\"BusinessType\" : \"%@\",\"ItemID\" : %@,\"ItemText\" :\"%@\",\"OpUserID\" : %@,\"CreateDate\" : %lld}",EventID,BCID,MallID,ShopID,self.ItemType,BusinessType,ItemID,ItemText,OpUserID,CreateDate];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"数据统计文件路径-------%@",GJGStatisticFile);
    if(![fileManager fileExistsAtPath:GJGStatisticFile]){
        [jsonStr writeToFile:GJGStatisticFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSString *fileStr = [NSString stringWithContentsOfFile:GJGStatisticFile encoding:NSUTF8StringEncoding error:nil];
        [fileStr stringByAppendingString:jsonStr];
        fileStr = [NSString stringWithFormat:@"%@\n%@",fileStr,jsonStr];
        [fileManager removeItemAtPath:GJGStatisticFile error:nil];
        [fileStr writeToFile:GJGStatisticFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    NSString *fileStr = [NSString stringWithContentsOfFile:GJGStatisticFile encoding:NSUTF8StringEncoding error:nil];
    if (fileStr != nil) {
        NSData *fileData = [NSData dataWithContentsOfFile:GJGStatisticFile];
        
        if (fileData.length > 18 * 1024 || timeDifference > 24 * 60 * 60 *1000) {
            [self upLoadToServer];
        }
    }
//    [self upLoadToServer:[NSString stringWithFormat:@"%lld",CreateDate]]; 
}


- (NSDictionary *)getParams{
    NSString *Token;
    
    NSString *Version = kAppVersion;
    
    NSString *Package = kPackage;
    
    NSString *Channel = @"appStore";
    
    NSString *Mac = @"";
    
    NSString *IP = @"";
    
    NSString *City = [GJGLocationManager sharedManager].cityName;
    
    NSString *Area = [GJGLocationManager sharedManager].cityName;
    
    NSString *UserID;
    
    NSString *loginstate;
    if([LoginManager shareManager].isHadLogin){
        loginstate = @"0";
    }else{
        loginstate = @"1";
    }
    
    if ([[LoginManager shareManager] isHadLogin] ) { // 是否登录
        Token = [UserDBManager shareManager].Token;
        UserID = [UserDBManager shareManager].UserID;
    }else{
        Token = [kUserDefaults objectForKey:UDKEY_VisitorToken];
        UserID = @"0";
    }
    return @{@"Version"     : Version,
             @"Package"     : Package,
             @"Token"       : Token,
             @"Channel"     : Channel,
             @"Mac"         : Mac,
             @"IP"          : IP,
             @"UserID"      : UserID,
             @"City"        : City,
             @"Area"        : Area,
             @"AccessToken" : @""
             };
}


- (void)upLoadToServer{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:GJGStatisticFile]){
        return ;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",
                                                               @"text/html",
                                                               @"text/json",
                                                               @"text/javascript",
                                                               @"application/x-javascript", nil]];
        NSDictionary *param = [self getParams];
        
        NSString *urlString = kStatisticUrl;
       
        [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            long long CreateDate = [[NSNumber numberWithDouble:time] longLongValue] * 1000;
            NSData * data = [NSData dataWithContentsOfFile:GJGStatisticFile];
            NSLog(@"需要上传的文件:%@----地址%@",data,GJGStatisticFile);
            [formData appendPartWithFileData:data
                                        name:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%lld",CreateDate]]
                                    fileName:[NSString stringWithFormat:@"%@.txt", [NSString stringWithFormat:@"%lld",CreateDate]]
                                    mimeType:@"txt"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            // 打印下上传进度
            NSLog(@"上传进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"uploadresponse------数据统计文件上传成功:%@",responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)responseObject;
                
                if ([dict[@"status"] integerValue] == 0) {
                    // 删除文件 清空记录时间
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [fileManager removeItemAtPath:GJGStatisticFile error:nil];
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"codeTime"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"codeTime-----%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"codeTime"]);
                }
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            NSLog(@"请求失败：%@", [error localizedDescription]);
            
        }];
    });
}

@end
