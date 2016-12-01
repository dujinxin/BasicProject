//
//  UserEntity.m
//  PRJ_Shopping
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

@end

@implementation UserObj


- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
//        object = @{
//                   @"Token": @"werwewerwerwerwerwerwee",
//                   @"RefreshToken": @"fhrthfhfghfghgfhfghfghfghgf",
//                   @"Phonenumber": @"13121273646",
//                   @"UserID": @"11",
//                   @"UserName": @"阿杜",
//                   @"UserAge": @"18",
//                   @"UserImage": @"http://images.gjg.com/test.jpg",
//                   @"UserGender": @"0",
//                   };
        //delegate
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseSuccessObj:tag:)]) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                // JSON -> User
                UserEntity * entity = [UserEntity mj_objectWithKeyValues:dict];
                [self.delegate responseSuccessObj:entity tag:self.tag];
            }
        }
        //block
        if (self.success) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                
                // JSON -> User
                UserEntity * entity = [UserEntity mj_objectWithKeyValues:dict];
                
                if ([[UserDBManager shareManager] isExist:UserDBName]){
                    [[UserDBManager shareManager] deleteData:UserDBName];
                }
                [[UserDBManager shareManager] createTable:UserDBName keys:dict.allKeys];
                [[UserDBManager shareManager] insertData:UserDBName keyValues:dict];
                //
                [[UserDBManager shareManager] updateToken:dict[@"Token"] refreshToken:dict[@"RefreshToken"]];
                
                //同步把自身的昵称和头像也存储到环信联系人中
                NSString * nickName;
                if (dict[@"UserName"]) {
                    nickName = dict[@"UserName"];
                }else{
                    nickName = dict[@"HxAccount"];
                }
                NSMutableDictionary * hxDict = [NSMutableDictionary dictionary];
                [hxDict setValue:nickName forKey:@"nickName"];
                [hxDict setValue:dict[@"UserImage"]forKey:@"userImage"];
                [hxDict setValue:dict[@"UserID"] forKey:@"userId"];
                [hxDict setValue:dict[@"HxAccount"]forKey:@"userName"];

                [[ChatManager shareManager] createTable:ChatDBName keys:hxDict.allKeys];
                [[ChatManager shareManager] saveUserProfileEntityWithDict:hxDict];
                

                
                self.success(entity,message);
            }
        }
    }else{
        //delegate
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(responseFailed:message:)]) {
            [self.delegate responseFailed:self.tag message:message];
        }
        //block
        if (self.failure) {
            self.failure(nil,message);
        }
    }
}
@end

@implementation RefreshTokenObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;

                UserEntity * entity = [UserEntity mj_objectWithKeyValues:dict];
                if (entity.UserID && entity.UserID.length){
                    if ([[UserDBManager shareManager] isExist:UserDBName]){
                        [[UserDBManager shareManager] deleteData:UserDBName];
                    }
                    [[UserDBManager shareManager] createTable:UserDBName keys:dict.allKeys];
                    [[UserDBManager shareManager] insertData:UserDBName keyValues:dict];
                }
                //
                [[UserDBManager shareManager] updateToken:dict[@"Token"] refreshToken:dict[@"RefreshToken"]];
                
                
                //同步把自身的昵称和头像也存储到环信联系人中
                if (entity.HxAccount && entity.HxAccount.length){
                    NSString * nickName;
                    if (dict[@"UserName"]) {
                        nickName = dict[@"UserName"];
                    }else{
                        nickName = dict[@"HxAccount"];
                    }
                    NSMutableDictionary * hxDict = [NSMutableDictionary dictionary];
                    [hxDict setValue:nickName forKey:@"nickName"];
                    [hxDict setValue:dict[@"UserImage"]forKey:@"userImage"];
                    [hxDict setValue:dict[@"UserID"] forKey:@"userId"];
                    [hxDict setValue:dict[@"HxAccount"]forKey:@"userName"];
                    [[ChatManager shareManager] createTable:ChatDBName keys:hxDict.allKeys];
                    [[ChatManager shareManager] saveUserProfileEntityWithDict:hxDict];
                }
                
                self.success(entity,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(nil,message);
        }
    }
}

@end

@implementation UserTokenEntity
@end

@implementation UserTokenObj


- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {

        if (self.success) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                UserTokenEntity * entity = [UserTokenEntity mj_objectWithKeyValues:dict];
                [[UserDBManager shareManager] updateToken:entity.Token refreshToken:entity.RefreshToken];
                self.success(entity,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(nil,message);
        }
    }
}
@end

@implementation UserDetailEntity

@end
@implementation UserDetailObj


- (NSString *)requestUrl{
    return @"/UserInfo/UserDetails";
}

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
//        object =  @{
//            @"UserId": @11,
//            @"UserName": @"爱购物的小巴",
//            @"HeadPortrait": @"http://images.gjg.com/test.jpg",	 //头像
//            @"FollowNum": @1001,
//            @"UserLevel": @3,
//            @"UserLevelName": @"购物大神",
//            @"UserType": @1	,		//参考UserType--用户类型
//            @"HasFollow":@true
//        };

        if (self.success) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = (NSDictionary *)object;
                UserDetailEntity * entity = [UserDetailEntity mj_objectWithKeyValues:dict];
                self.success(entity,message);
            }
        }
    }else{
        if (self.failure) {
            self.failure(nil,message);
        }
    }
}
@end

@implementation UserNameObj

- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            self.success(object,message);
        }
        if (self.delegate) {
            [self.delegate responseSuccessObj:object message:message tag:0];
        }
    }else{
        if (self.failure) {
            self.failure(nil,message);
        }
        if (self.delegate) {
            [self.delegate responseFailed:0 message:message];
        }
    }
}
@end

@implementation UploadImageObj

- (AFConstructingBlock)constructingBodyBlock{
    return ^(id<AFMultipartFormData> formData){
        
        //        UIImage *image = [UIImage imageNamed:@"头像1"];
        //        NSData *data = UIImagePNGRepresentation(image);
        //        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        //        // 要解决此问题，
        //        // 可以在上传时使用当前的系统事件作为文件名
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置时间格式
        //        formatter.dateFormat = @"yyyyMMddHHmmss";
        //        NSString *str = [formatter stringFromDate:[NSDate date]];
        //        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        //        /*
        //         此方法参数
        //         1. 要上传的[二进制数据]
        //         2. 对应网站上[upload.php中]处理文件的[字段"file"]
        //         3. 要保存在服务器上的[文件名]
        //         4. 上传文件的[mimeType]
        //         */
        //        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        
        self.imagePath = [[NSHomeDirectory()  stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userImage.jpg"];
//        NSURL * fileURL = [[NSURL alloc] initFileURLWithPath:self.imagePath];
//        [formData appendPartWithFileURL:fileURL name:@"image" fileName:@"userImage.jpg" mimeType:@"image/jpeg" error:nil];

        NSData * data = [NSData dataWithContentsOfFile:self.imagePath];
        NSInputStream * stream = [[NSInputStream alloc ]initWithData:data];
        
        [formData appendPartWithInputStream:stream  name:@"image" fileName:@"userImage.jpg" length:data.length mimeType:@"image/jpeg"];
    };
}
- (void)responseResult:(id)object message:(NSString *)message isSuccess:(BOOL)isSuccess{
    [super responseResult:object message:message isSuccess:isSuccess];
    if (isSuccess) {
        if (self.success) {
            self.success(object,message);
        }
        if (self.delegate) {
            [self.delegate responseSuccessObj:object message:message tag:0];
        }
    }else{
        if (self.failure) {
            self.failure(nil,message);
        }
        if (self.delegate) {
            [self.delegate responseFailed:0 message:message];
        }
    }
}
@end

