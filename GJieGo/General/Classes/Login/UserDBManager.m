//
//  UserDBManager.m
//  GJieGo
//
//  Created by dujinxin on 16/6/12.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "UserDBManager.h"

@implementation UserDBManager
/**
 *  通过此类方法，得到单例
 */
static UserDBManager * manager = nil;
+ (UserDBManager *)shareManager{
    @synchronized(self){
        if (manager == nil) {
            manager = [[self alloc]init ];
            [manager initializeData];
        }
    }
    return manager;
}
/**
 *  初始化数据库，获得存储路径
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseWithPath:[NSString stringWithFormat:@"%@.db",UserDBName]]];
//    }
//    return self;
//}

- (void)initializeData{
    if ([manager isExist:UserDBName]){
        NSArray * dataArray = [manager selectData:UserDBName];
        if (dataArray) {
            [manager setValuesForKeysWithDictionary:dataArray.firstObject];
            NSLog(@"用户信息:%@",dataArray);
        }else{
            NSLog(@"游客身份:%@",@{@"token":[self getToken],@"refreshToken":[self getRefreshToken]});
        }
    }else{
        NSLog(@"游客身份:%@",@{@"token":[self getToken],@"refreshToken":[self getRefreshToken]});
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"value:%@  key:%@",value,key);
}
- (BOOL)insertData:(NSString *)name keyValues:(NSDictionary *)keyValues{
    BOOL result = [super insertData:name keyValues:keyValues];
    if (result) {
        [self initializeData];
    }
    return result;
}
- (void)clearUserInfo{
    //清除数据库
    [manager deleteData:UserDBName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self databaseWithPath:[NSString stringWithFormat:@"%@.db",UserDBName]]]) {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[self databaseWithPath:[NSString stringWithFormat:@"%@.db",UserDBName]] error:&error];
        if (error) {
            NSLog(@"clear userInfo file error :%@",error.localizedDescription);
        }else{
            NSLog(@"clear userInfo file success!");
        }
    }
    //清除属性值
    manager.Token = nil;
    manager.RefreshToken = nil;
    manager.PhoneNumber = nil;
    manager.UserID = nil;
    manager.UserName = nil;
    manager.UserAge = nil;
    manager.UserImage = nil;
    manager.UserImage = nil;
    
    manager.HxAccount = nil;
    manager.HxPassword = nil;
    manager = nil;
    
    NSLog(@"用户信息已清除");
    
}
- (BOOL)modifyUserNickName:(NSString *)nickName{
    NSString * conditionStr = [NSString stringWithFormat:@"UserID = %@",manager.UserID];
    BOOL result = [self updateData:UserDBName keyValues:@{@"UserName":nickName} where:@[conditionStr]];
    manager.UserName = nickName;
    return result;
}
- (BOOL)modifyUserImage:(NSString *)imageUrl{
    NSString * conditionStr = [NSString stringWithFormat:@"UserID = %@",manager.UserID];
    BOOL result = [self updateData:UserDBName keyValues:@{@"UserImage":imageUrl} where:@[conditionStr]];
    manager.UserImage = imageUrl;
    return result;
}
- (BOOL)modifyUserGender:(NSString *)gender{
    NSLog(@"manager.UserID  ===  %@",manager.UserID);
    NSString * conditionStr = [NSString stringWithFormat:@"UserID = %@",manager.UserID];
    BOOL result = [self updateData:UserDBName keyValues:@{@"UserGender":gender} where:@[conditionStr]];
    manager.UserGender = gender;
    return result;
}
- (BOOL)updateToken:(NSString *)token refreshToken:(NSString *)refreshToken{
    BOOL result = YES;
    if ([LoginManager shareManager].isHadLogin){
//        NSString * conditionStr = [NSString stringWithFormat:@"UserID = %@",manager.UserID];
//        result = [self updateData:UserDBName keyValues:@{@"Token":token,@"RefreshToken":refreshToken} where:@[conditionStr]];
//        manager.Token = token;
//        manager.RefreshToken = refreshToken;
    }
    
    [kUserDefaults setObject:token forKey:UDKEY_VisitorToken];
    [kUserDefaults setObject:refreshToken forKey:UDKEY_RefreshToken];
    NSDate * date = [NSDate date];
    [kUserDefaults setObject:date forKey:UDKEY_TokenDate];
    [kUserDefaults synchronize];
    
    return result;
}
- (void)deleteToken{
    [kUserDefaults removeObjectForKey:UDKEY_VisitorToken];
    [kUserDefaults removeObjectForKey:UDKEY_RefreshToken];
    [kUserDefaults removeObjectForKey:UDKEY_TokenDate];
    [kUserDefaults synchronize];
}
- (NSString *)getToken{
    NSString * token = @"";
    if ([[LoginManager shareManager] isHadLogin]) {
        token = [UserDBManager shareManager].Token;
    }
    if([kUserDefaults objectForKey:UDKEY_VisitorToken]){
        token = [kUserDefaults objectForKey:UDKEY_VisitorToken];
    }
    return token;
}
- (NSString *)getRefreshToken{
    NSString * refreshToken = @"";
    if ([[LoginManager shareManager] isHadLogin]) {
        refreshToken = [UserDBManager shareManager].RefreshToken;
    }
    if([kUserDefaults objectForKey:UDKEY_RefreshToken]){
        refreshToken = [kUserDefaults objectForKey:UDKEY_RefreshToken];
    }
    return refreshToken;
}
- (BOOL)isVisitor{
    if ([self getToken] && [[self getToken] hasPrefix:@"Y"]) {
        return YES;
    }
    return NO;
}
@end
