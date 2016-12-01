//
//  NSString+Category.m
//  JXView
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "NSString+Category.h"
#import "NSString+MD5.h"

@implementation NSString (Category)
/*
IOS常用正则表达式

IOS常用正则表达式 正则表达式用于字符串处理、表单验证等场合，实用高效。现将一些常用的表达式收集于此，以备不时之需。

匹配中文字符的正则表达式： [\u4e00-\u9fa5]
评注：匹配中文还真是个头疼的事，有了这个表达式就好办了

匹配双字节字符(包括汉字在内)：[^\x00-\xff]
评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）

匹配空白行的正则表达式：\n\s*\r
评注：可以用来删除空白行

匹配HTML标记的正则表达式：<(\S*?)[^>]*>.*?</\1>|<.*? />
评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧没有能力为力

匹配首尾空白字符的正则表达式：^\s*|\s*$
评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式

匹配Email地址的正则表达式：\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*
评注：表单验证时很实用

匹配网址URL的正则表达式：[a-zA-z]+://[^\s]*
评注：网上流传的版本功能很有限，上面这个基本可以满足需求

匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
评注：表单验证时很实用

匹配国内电话号码：\d{3}-\d{8}|\d{4}-\d{7}
评注：匹配形式如 0511-4405222 或 021-87888822

匹配腾讯QQ号：[1-9][0-9]{4,}
评注：腾讯QQ号从10000开始

匹配中国邮政编码：[1-9]\d{5}(?!\d)
评注：中国邮政编码为6位数字

匹配身份证：\d{15}|\d{18}
评注：中国的身份证为15位或18位

匹配ip地址：\d+\.\d+\.\d+\.\d+
评注：提取ip地址时有用

匹配特定数字：
^[1-9]\d*$　 　 //匹配正整数
^-[1-9]\d*$ 　 //匹配负整数
^-?[1-9]\d*$　　 //匹配整数
^[1-9]\d*|0$　 //匹配非负整数（正整数 + 0）
^-[1-9]\d*|0$　　 //匹配非正整数（负整数 + 0）
^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$　　 //匹配正浮点数
^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$　 //匹配负浮点数
^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$　 //匹配浮点数
^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$　　 //匹配非负浮点数（正浮点数 + 0）
^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$　　//匹配非正浮点数（负浮点数 + 0）
评注：处理大量数据时有用，具体应用时注意修正

匹配特定字符串：
^[A-Za-z]+$　　//匹配由26个英文字母组成的字符串
^[A-Z]+$　　//匹配由26个英文字母的大写组成的字符串
^[a-z]+$　　//匹配由26个英文字母的小写组成的字符串
^[A-Za-z0-9]+$　　//匹配由数字和26个英文字母组成的字符串
^\w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串

*/
+ (BOOL)isEmailAddress:(NSString*)candidate
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(NSNumber *)asNumber;{
    NSString *regEx = @"^-?\\d+.?\\d?";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL isMatch            = [pred evaluateWithObject:self];
    if (isMatch) {
        return [NSNumber numberWithDouble:[self doubleValue]];
    }
    return nil;
}

//摘自NSString+BeeExtension.mm
- (BOOL)isUserName
{
    NSString *      regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isPassword
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *      regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isUrl
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestphs evaluateWithObject:self]      ||
    [regextestct evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestcm evaluateWithObject:self];
}


//邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL)validateTelephone:(NSString *)tel
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    //只做1开头，11位的校验，其他详细的交给后台来做
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:tel];
}


//车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL)validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名 6-16位只含有汉字、数字、字母、下划线，下划线位置不限
+ (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]{2,12}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//密码  6-16位数字和字母
+ (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//验证码  4-6位数字
+ (BOOL)validateVerficationCode:(NSString *)code{
    NSString *passWordRegex = @"^[0-9]{6}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:code];
}
+ (BOOL)validateInvitationCode:(NSString *)code{
    NSString *passWordRegex = @"^[0-9]{1,9}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:code];
}
//昵称
+ (BOOL)validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 判断是否符合规范
- (BOOL)validateUserName:(NSString *) nameStr isMatchRegex:(NSString *)regex
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                               initWithPattern:regex
                                               options:NSRegularExpressionCaseInsensitive
                                               error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:nameStr
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, nameStr.length)
                                ];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
    
}
//使用正则表达式去掉html中的标签元素,获得纯文本
//content是根据网址获得的网页源码字符串
- (NSArray *)getHtmlContentString:(NSString *)content{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                             options:0
                             error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSArray *arr=[NSArray array];
    content=[NSString stringWithString:content];
    arr =  [content componentsSeparatedByString:@"-"];
    NSMutableArray *marr=[NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    return  marr;
}

#pragma mark 保存图片到document
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}
@end
