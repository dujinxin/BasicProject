//
//  Utils.m     工具类
//  PlayMusicTool
//
//  Created by 陈 宏 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <dirent.h>
#import <sys/stat.h>
#import "NSString+MD5.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
//#import <AlipaySDK/AlipaySDK.h>

//#import "config.h"


#define DEFAULT_VOID_COLOR [UIColor whiteColor]

//const NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
//const NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$";
//const NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";

@implementation Utils

static Utils * _instance;

+(Utils *)sharesInstance
{
    @synchronized(self)
    {
        if (_instance==nil) {
            _instance=[[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}

// 改变线条颜色和高度
+ (void)changeLineHeightAndColor:(UILabel *)line{
    
}

+(BOOL)isEmail:(NSString *)input{
    return YES;
}

+(NSString *)getDefaultFilePathString:(NSString *)fileName;
{
    NSString *defaultPathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return defaultPathString;
}

+(NSString *)getDocumentFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(NSString *)getLibraryFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return [libraryDirectory stringByAppendingPathComponent:fileName];
    
}

+(NSString *)getCacheFilePathString:(NSString *)fileName;
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cachePath = [cache objectAtIndex:0] ;
    return [cachePath stringByAppendingPathComponent:fileName];
    
}
//仅仅得到cache的路径
+(NSString *)getCachePathString;
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
    NSString *cachePath = [cache objectAtIndex:0] ;
    return cachePath;
}

+(NSString *)getTempPathString {
    return NSTemporaryDirectory();
}

+(NSString *)getTempFilePathString:(NSString *)fileName;
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

+(NSString *)getResourceFilePathString:(NSString *) resourceName ofType:(NSString*)typeName;
{
    return [[NSBundle mainBundle] pathForResource: resourceName ofType: typeName];
}

+(void)removeFile:(NSString *)folderPath {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:folderPath error:NULL];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        [fileManager removeItemAtPath:[folderPath stringByAppendingPathComponent:filename] error:NULL];
    }
}


+ (NSString *)getSaveFilePath:(NSString *)fileName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (void)saveFilePath:(NSString *)filepath fileData:(id)info andEncodeObjectKey:(NSString *)key {

    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver= [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:info forKey:key];
    [archiver finishEncoding];
    [data writeToFile:filepath atomically:YES];
}

+ (NSData *)loadDataFromFile:(NSString *)fileName anddencodeObjectKey:(NSString *)key {

    NSString *filePath = [Utils getSaveFilePath:fileName];

    if ([Utils isHaveFileAtPath:filePath]) {
        
        NSData *data1 = [NSData dataWithContentsOfFile:[Utils getDocumentFilePathString:fileName]];
        NSKeyedUnarchiver *archiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
        id info = [archiver decodeObjectForKey:key];
        [archiver finishDecoding];
        return info;
    }
    return nil;
}

+ (NSString *)loadClientVersionKey:(NSString *)key {
    
    NSDictionary *configCenterDic = (NSDictionary *)[Utils loadDataFromFile:@"configCenter.json" anddencodeObjectKey:@"configCenter"];
    NSPredicate *bobPredicate = [NSPredicate predicateWithFormat:key];
    NSArray *configcenterArray = [[configCenterDic objectForKey:@"configCenterList"] filteredArrayUsingPredicate:bobPredicate];
    NSDictionary *legalServiceDic = [NSDictionary dictionaryWithDictionary:[configcenterArray firstObject]];
    return [legalServiceDic objectForKey:@"value"];
}

+ (BOOL)isHaveFileAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//判断文件夹是否存在
+(BOOL)judgeFileExist:(NSString * )fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath=[documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager * fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

//去掉前后空格
+ (NSString *) getDisposalStr:(NSString *)s;
{
    if (![@"" isEqualToString:s]) {
        return [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return @"";
}

+(NSInteger)weiBoCountWord:(NSString*)s {
    NSUInteger i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;            
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

//获取数据MD5值
+ (NSString *)md5:(NSData *)data
{
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5,[data bytes],(int)[data length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1], 
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

+(BOOL)isMobileNum:(NSString *)input{
    BOOL rs = YES;
    if ([input length] != 11) {
        return NO;
    }
    if (![Utils isNumber:input]) {
        return NO;
    }
    for (int i = 0; i < [input length]; ++i) {
        unichar c = [input characterAtIndex:i];
        if (c > 47 && c < 58) {
            
        }else
        {
            return NO;
        }
        if (i == 0 &&  c != '1') {
            rs = NO;
            break;
        }
    }
	return rs;
}

+(BOOL)isIdentityCardNo:(NSString *)input {
    NSString *emailRegex = @"\\d{15}|(\\d{17}([0-9]|X|x)$)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}
+(BOOL)isYouBian:(NSString *)input
{
    
    NSString *emailRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}
+(BOOL)isNumber:(NSString *)input {
    NSString *emailRegex = @"[0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:input];
}

+ (NSString *)millisecondConvertedToDay:(unsigned long long )time {
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)millisecondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format {
    
    if (format==nil||[format isEqualToString:@""]) {
        format=@"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)secondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format {
    if (format==nil||[format isEqualToString:@""]) {
        format=@"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)translateDateString:(NSString *)translateDateString format:(NSString *)format toFormat:(NSString *)tofarmt {
    if (translateDateString==nil || format==nil || tofarmt == nil) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *translateDate = [dateFormatter dateFromString:translateDateString];
    
    NSDateFormatter *translateDateFormatter = [[NSDateFormatter alloc] init];
    [translateDateFormatter setDateFormat:tofarmt];
    NSString *string = [translateDateFormatter stringFromDate:translateDate];
    
    return string;
}

+ (NSString *)getWeekdayFromDate:(NSString *)dateStr formatter:(NSString *)matter {

    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
   
    NSInteger unitFlags = NSCalendarUnitYear |
   
                             NSCalendarUnitMonth |
    
                            NSCalendarUnitDay |
   
                            NSCalendarUnitWeekday |
   
                            NSCalendarUnitHour |
 
                          NSCalendarUnitMinute |
  
                            NSCalendarUnitSecond;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:matter];
    NSDate *date = [formatter dateFromString:dateStr];
   
    if (date == nil) {
        return @"";
    }
    components = [calendar components:unitFlags fromDate:date];
 
    NSUInteger weekday = [components weekday];
    
    switch (weekday) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
    return @"";
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


+(NSString *)ToHex:(long long int)tmpid
{
    //    NSString *endtmp=@"";
    NSString *nLetterValue;
    //    NSString *nStrat;
    NSString *str =@"";
    //    tmpid = 13621631651;
    long long int ttmpig;
    
    
    
    for (int i = 0; i<9; i++) {
        
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    
    //        } while (tmpid == 0);
    //
    return str;
}


//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//得到日期开始和结束时间
+(NSArray *)getStartDayAndEndDay:(TimeStateType)type{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday|NSCalendarUnitMonth|kCFCalendarUnitYear) fromDate:today];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    if (type==WeekType) {
        NSInteger weekday = [dayComponents weekday];
        NSInteger month = [dayComponents weekOfMonth];
        NSInteger year = [dayComponents weekOfYear];
        NSLog(@"week :%ld---%ld",(long)month, (long)year);
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-weekday*60*60*24];
        NSString *startString = [formatter stringFromDate:startDate];
        
        for(int i = 1;i<5;i++){
            NSDate *endDate = [NSDate dateWithTimeInterval:-(7*i*60*60*24) sinceDate:startDate];
            NSString *endString = [formatter stringFromDate:endDate];
            startString = [startString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            endString = [endString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            [temp addObject:[NSString stringWithFormat:@"%@-%@",endString,startString]];
            startString = endString;
            startDate = endDate;
        }
    }else if(type==MonthType){
        NSInteger month  =  [dayComponents month];
        NSInteger year= [dayComponents year];
        for (int i=1; i<5; i++) {
            if (month==1) {
                year--;
            }
            month = month==1?12:month-1;
            
            dayComponents.day = 1;
            dayComponents.year=year;
            dayComponents.month = month;
            NSRange range = [gregorian rangeOfUnit:NSCalendarUnitDay
                                            inUnit:NSCalendarUnitMonth
                                           forDate:[gregorian dateFromComponents:dayComponents]];
            NSDate *firstDate = [gregorian dateFromComponents:dayComponents];
            [dayComponents setDay:range.length];
            NSDate *lastDate = [gregorian dateFromComponents:dayComponents];
            NSString *startString = [formatter stringFromDate:firstDate];
            NSString *endString = [formatter stringFromDate:lastDate];
            startString = [startString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            endString = [endString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            [temp addObject:[NSString stringWithFormat:@"%@-%@",startString,endString]];
        }
        
        
    }

return temp;
}


+(long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


//获取文件夹大小
+(long long)folderSize:(const char *)folderPath {
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) {
        return 0;
    }
    struct dirent* child;
    while ((child = readdir(dir)) != NULL) {
        if (child->d_type == DT_DIR
            && (child->d_name[0] == '.' && child->d_name[1] == 0)) {
            continue;
        }
        
        if (child->d_type == DT_DIR
            && (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)) {
            continue;
        }
        
        NSUInteger folderPathLength = strlen(folderPath);
        char childPath[1024];
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength - 1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        
        stpcpy(childPath + folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){
            folderSize += [self folderSize:childPath];
            struct stat st;
            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        } else if (child->d_type == DT_REG || child->d_type == DT_LNK){
            struct stat st;
            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        }
    }
    
    return folderSize;
}


// 计算字符串的高度
+ (CGFloat)heightForString:(NSString *)string fontSize:(float)fontSize andWidth:(float)width
{
    if (string==nil) {
        return 0;
    }

    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(width,CGFLOAT_MAX);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize.height;

}

// 计算字符串长度
+ (CGFloat)widthForString:(NSString *)string fontSize:(float)fontSize andHeight:(float)height
{
    if (string==nil) {
        return 0;
    }
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(CGFLOAT_MAX,height);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize.width;
}

+ (NSString *)translateToCardString:(NSString *)string interval:(NSInteger)interval
{
    if (!string) {
        return @"";
    }
    NSMutableString *translateStr = [NSMutableString stringWithString:string];
    
    NSInteger tempNum = 0;
    for (int i = 0; i < string.length; i++) {
        
        if (i%interval==0 && i>0) {
            ///插入空格
            [translateStr insertString:@" " atIndex:i+tempNum];
            tempNum++;
        }
    }
    return translateStr;
}

+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor {

    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    if (oneStr) {
        NSRange range1 = NSMakeRange(0, oneStr.length);
        [registerStr setAttributes:@{NSForegroundColorAttributeName:oneColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:10.0]}
                             range:range1];
    }
    if (otherStr) {
        NSRange range2 = NSMakeRange(oneStr.length, otherStr.length);
        
        [registerStr setAttributes:@{NSForegroundColorAttributeName:otherColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:10.0]}
                             range:range2];
    }

    return registerStr;
}

+ (NSAttributedString *)getDifferentFontString:(NSString *)totalStr oneStr:(NSString *)oneStr font:(UIFont *)oneFont color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherFont:(UIFont *)otherFont ortherColor:(UIColor *)otherColor {
    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    if (oneStr) {
        NSRange range1 = NSMakeRange(0, oneStr.length);
        [registerStr setAttributes:@{NSForegroundColorAttributeName:oneColor,
                                     NSFontAttributeName:oneFont}
                             range:range1];
    }
    if (otherStr) {
        NSRange range2 = NSMakeRange(oneStr.length, otherStr.length);
        
        [registerStr setAttributes:@{NSForegroundColorAttributeName:otherColor,
                                     NSFontAttributeName:otherFont}
                             range:range2];
    }
    
    return registerStr;
}

+ (NSAttributedString *)getDifferentFontStringWithTotalString:(NSString *)totalStr andInfo:(NSArray *)info {

    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    @try {
        CGFloat tempLength = 0;

        for (int i =0; i < info.count; i++) {
            NSArray *tempArray = [info objectAtIndex:i];
            NSString *str = [tempArray firstObject];
            UIColor *color = [tempArray objectAtIndex:1];
            UIFont *font = [tempArray lastObject];
            
            NSRange range = NSMakeRange(tempLength, str.length);
            [registerStr setAttributes:@{NSForegroundColorAttributeName:color,
                                         NSFontAttributeName:font}
                                 range:range];
            
            tempLength+=str.length;
        }
    }
    @catch (NSException *exception) {
        ///
    }
    @finally {
        ///
    }

    
    return registerStr;
}

+ (NSMutableAttributedString *)getLineSpaceString:(NSString *)string lineSpace:(CGFloat)space alignment:(NSTextAlignment)alignment {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//调整行间距
    paragraphStyle.alignment = alignment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}

+ (NSString *)getBankName:(NSString *)bankCode {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankLogoList" ofType:@"plist"];
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *bankInfo = [bankDic objectForKey:bankCode];
    
    if (bankInfo==nil) {
        return @"";
    }
    return [bankInfo objectForKey:@"name"];
    
}

+ (NSString *)getBankLogo:(NSString *)bankCode {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BankLogoList" ofType:@"plist"];
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *bankInfo = [bankDic objectForKey:bankCode];
    
    if (bankInfo==nil) {
        return @"";
    }
    return [bankInfo objectForKey:@"logo"];
    
}

+ (NSString *)getBankCardType:(NSString *)bankCardtype {
    
    NSDictionary *bankCardTypeDic = @{@"00": @"未知",
                          @"01": @"借记账户",
                          @"02": @"贷记账户",
                          @"03": @"准贷记账户",
                          @"04": @"借贷合一账户",
                          @"05": @"预付费账户",
                          @"06": @"半开放预付费账户"};
    NSString *temp = [bankCardTypeDic objectForKey:bankCardtype];
    return temp==nil?@"":temp;
}

+ (NSString *)stringByInfoArray:(NSArray *)array stepetorStr:(NSString *)str {
    
    NSString *tempStr = [NSString string];
    for (int i = 0; i < array.count; i++) {
        NSString *string = array[i];
        if (string&&string.length>0) {
            if (i!=0) {
                tempStr = [tempStr stringByAppendingString:str];
            }
            tempStr = [tempStr stringByAppendingString:string];
        }
    }
    return tempStr;
}

+ (NSString *)stringByStepetorStr:(NSString *)str andInfo:(NSString *)info, ... {
    
    NSString *tempStr = [NSString string];

    
    va_list args;
    va_start(args, info);

    NSUInteger i = 0;
    NSString *otherString;
    if (info&&info.length>0) {
        tempStr = [tempStr stringByAppendingString:info];
        i = 1;
    }
    while ((otherString = va_arg(args, NSString *)))
    {
        //依次取得所有参数
        if (otherString&&otherString.length>0) {
            if (i!=0) {
                tempStr = [tempStr stringByAppendingString:str];
            }
            tempStr = [tempStr stringByAppendingString:otherString];
            i++;

        }
    }

    va_end(args);
    
    return tempStr;
}

+ (UILabel *)lineLabelWithFrame:(CGRect)frame color:(UIColor *)color {
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = color;
    lineLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.5);
    
    return lineLabel;
}

// 根据frame加线
+ (void)addLineWithView:(UIView *)view withLineFrame:(CGRect)lineFrame withColor:(UIColor *)color {
    UILabel *line = [[UILabel alloc] initWithFrame:lineFrame];
    line.backgroundColor = color;
    [view addSubview:line];
}

+ (NSMutableAttributedString *)setTextColor:(UIColor *)textColor  withRange:(NSRange)textRange withString:(NSString *)string
{
    NSMutableAttributedString *mutableString =[[NSMutableAttributedString alloc] initWithString:string];
    [mutableString addAttribute:NSForegroundColorAttributeName value:textColor range:textRange];
    return mutableString;
}

// 判断数据是否为空或空对象
+ (BOOL)dataIsNull:(id)string {
    if ([string isEqual:[NSNull null]] || string == nil || [string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString*)getMd5Password:(NSString *)password {
    return [NSString md5:password];
}

// 根据文本内容自动得到view高度
+ (CGSize)getHeightByString:(NSString *)string andWithViewWidth:(CGFloat)width andWithFontSize:(CGFloat)fontSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(width, 1000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return textSize;
}

// 给view添加边框
+ (void)changeRoundViewWithBorderView:(UIView *)aView withRadius:(float)radius withBorderColor:(UIColor *)bColor {
    aView.layer.masksToBounds = YES;
    aView.layer.cornerRadius = radius;
    aView.layer.borderWidth = 1.0;
    aView.layer.borderColor = [bColor CGColor];
}

// 给某个view添加手势
+ (void)addTapGestureInView:(UIView *)inView addTarget:(id)target action:(SEL)action withTag:(NSInteger)viewTag {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [tapGesture setCancelsTouchesInView:NO];
    tapGesture.numberOfTapsRequired = 1;
    inView.tag = viewTag;
    [inView addGestureRecognizer:tapGesture];
}

/**
 * 设置view属性，圆角、边框
 *
 * @param aView 需设置的视图
 * @param radius 圆角弧度
 * @param bColor 边框颜色
 * @param board 边框像素
 **/
+ (void)changeRoundViewWithBorderView:(UIView *)aView withRadius:(float)radius withBorderColor:(UIColor *)bColor board:(CGFloat)board {
    aView.layer.masksToBounds = YES;
    aView.layer.cornerRadius = radius;
    aView.layer.borderWidth = board;
    aView.layer.borderColor = [bColor CGColor];
}

// 日期选取器得到日期
+ (NSString *)getStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark --后台请求是否支付成功
/*
+(NSDictionary *)judgeIsPaySucceed:(NSString *)orderId{
    DPMyInfoModel *infoModel = [DPMyInfoModel getUserInfo];
    NSString *url=[NSString stringWithFormat:@"%@&pay_method=appalipay&api_version=%@&session=%@&orderId=%@&sign=%@",DP_JudgePayIsSucced,DP_Version,infoModel.session,orderId,@"3E739B061739EC89A3AF4D5141E7F931"];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSError *error;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setResponseSerializer:responseSerializer];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    //    NSError *error;
    NSMutableDictionary *requestdic=[requestOperation responseObject];//[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if ([[requestdic objectForKey:@"flag"] boolValue]) {
        return [requestdic objectForKey:@"result"];
    }
    return requestdic;
}
#pragma mark --获取预订单
+ (NSDictionary *)getWillPayOrder:(NSString *)orderId
{
//    DPMyInfoModel *infoModel = [DPMyInfoModel getUserInfo];
//    NSString *url=[NSString stringWithFormat:@"%@&pay_method=appalipay&api_version=%@&sessionID=%@&orderID=%@",DP_GetWillPayOrderDetail,DP_Version,infoModel.session,orderId];
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    NSError *error;
//    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
//    
//    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [requestOperation setResponseSerializer:responseSerializer];
//    [requestOperation start];
//    [requestOperation waitUntilFinished];
////    NSError *error;
//    NSMutableDictionary *requestdic=[requestOperation responseObject];//[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    if ([[requestdic objectForKey:@"flag"] boolValue]) {
//        return [requestdic objectForKey:@"result"];
//    }
//    return requestdic;
}
*/

// alloc一个UIImageView到一个view上边
+ (UIImageView *)allImageViewWithFrame:(CGRect)frame withImageName:(NSString *)imageName {
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:frame];
    addImageView.image = [UIImage imageNamed:imageName];
    return addImageView;
}

// 手机号正则验证
+ (BOOL)validateMobile:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     * 170
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|81|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//  生成UILabel对象
+ (UILabel *)allocLabelWithRect:(CGRect)rect withTextColor:(UIColor *)color withTextAligment:(NSTextAlignment)textAlignment withTextFontSize:(CGFloat)fontSize withTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = textAlignment;
    label.textColor = color;
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    label.text = title;
    return label;
}

//截取时间
+ (NSString *)returnTimeString:(NSString *)pointTime {
    NSArray *sepPointTime = [pointTime componentsSeparatedByString:@"T"];
    //年 月 日
    NSArray *nyr = [sepPointTime[0] componentsSeparatedByString:@"-"];
    //月 日
    NSString *yr = [NSString stringWithFormat:@"%@-%@",nyr[1],nyr[2]];
    //时分秒
    NSArray *sfm = [sepPointTime[1] componentsSeparatedByString:@":"];
    //时分
    NSString *sf = [NSString stringWithFormat:@"%@:%@",sfm[0],sfm[1]];
    
    return [NSString stringWithFormat:@"%@ %@",yr,sf];
}

#pragma mark --提交订单
//+(void)orderPay:(NSString *)orderId oderInfo:(Order *)order id:(id)delegate payType:(Paytype)type  success:(void (^)(NSDictionary* responseObject))success
//      exception:(void (^)(NSDictionary* responseObject))exception
//        failure:(void (^)(NSError *error))failure {
//    if (type == PaytypeALi) {
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).payController=delegate;
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).payTypeThirdParty=PaytypeALi;
//        
//        //将商品信息拼接成字符串
//        NSString *orderSpec = [order description];
//        NSLog(@"orderSpec = %@",orderSpec);
//        
//        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner(Alipay_PrivateKey);
//        NSString *signedString = [signer signString:orderSpec];
//        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = nil;
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        if (order) {
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"HHXC" callback:^(NSDictionary *resultDic) {
//                NSLog(@"reslut = %@",resultDic);
//                success(resultDic);
//                return ;
//            }];
//        }else {
//            
//        }
//    }else if(type == PaytypeWiXin){
//        //            //            //向微信注册
//        //        [WXApi registerApp:WeiXinAPPId  withDescription:@"demo 2.0"];
//        
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).payController=delegate;
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).payTypeThirdParty=PaytypeWiXin;
//        NSDictionary *_dic;
//        //    request.partnerId=@""
//        if ([_dic objectForKey:@"flag"]) {
//            exception(_dic);
//        }else{
//            //调起微信支付
//            //            //创建支付签名对象
//            //            payRequsestHandler *req1 = [[payRequsestHandler alloc]init];
//            //            //初始化支付签名对象
//            //            [req1 init:APP_ID mch_id:MCH_ID];
//            //            //设置密钥
//            //            [req1 setKey:PARTNER_ID];
//            //            if ([_dic objectForKey:@"params"]) {
//            //                [req1 setNotifyUrl:[NSString stringWithFormat:@"%@",[[_dic objectForKey:@"params"] objectForKey:@"notify_url"]]];
//            //                [req1 setOrderPrice:[NSString stringWithFormat:@"%@",[[_dic objectForKey:@"params"] objectForKey:@"total_fee"]]];
//            //                [req1 setOrderName:[NSString stringWithFormat:@"%@",[[_dic objectForKey:@"params"] objectForKey:@"body"]]];
//            //            }else{
//            //                return;
//            //            }
//            //            if ([_dic objectForKey:@"traceid"]) {
//            //                [req1 setOrderno:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"traceid"]]];
//            //            }else{
//            //                return;
//            //            }
//            //
//            //            if ([_dic objectForKey:@"nonceStr"]) {
//            //                [req1 setNoncestr:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"nonceStr"]]];
//            //            }else{
//            //                return;
//            //            }
//            //            获取到实际调起微信支付的参数后，在app端调起支付
//            //            NSMutableDictionary *dict = [req1 sendPay_demo];
//            //            if(dict == nil){
//            //                //错误提示
//            //                NSString *debug = [req1 getDebugifo];
//            //
//            //                NSLog(@"%@\n\n",debug);
//            //            }else{
//            //                 NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//            //                PayReq* req2            = [[PayReq alloc] init];
//            //                req2.openID              =[dict objectForKey:@"appid"];
//            //                req2.partnerId           =[dict objectForKey:@"partnerid"];
//            //                req2.prepayId            = [dict objectForKey:@"prepayid"];
//            //                req2.nonceStr            =[dict objectForKey:@"noncestr"];
//            //                req2.timeStamp           = stamp.intValue;
//            //                req2.package             =@"Sign=WXPay";// [_dic objectForKey:@"package"];
//            //                req2.sign                = [dict objectForKey:@"sign"];
//            //                NSMutableString *stamp  = [_dic objectForKey:@""][dict objectForKey:@"timestamp"];
//            PayReq* req             = [[PayReq alloc] init];
//            req.openID              =[_dic objectForKey:@"appid"];
//            req.partnerId           =[_dic objectForKey:@"partnerid"];//[dict objectForKey:@"partnerid"];
//            req.prepayId            = [_dic objectForKey:@"prepayid"];//[dict objectForKey:@"prepayid"];
//            req.nonceStr            =[_dic objectForKey:@"noncestr"];//[dict objectForKey:@"noncestr"];
//            req.timeStamp           =[[_dic objectForKey:@"timestamp"] intValue];//stamp.intValue;
//            req.package             = [_dic objectForKey:@"package"];//@"Sign=WXPay";//[
//            req.sign                = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"sign"]];//[dict objectForKey:@"sign"];
//            [WXApi sendReq:req];
//            //            }
//        }
//    }
//}

@end
