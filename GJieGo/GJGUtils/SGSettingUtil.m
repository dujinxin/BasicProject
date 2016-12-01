//
//  SGSettingUtil.m
//  SGShow
//
//  Created by fanshijian on 15-3-13.
//  Copyright (c) 2015年 fanshijian. All rights reserved.
//

#import "SGSettingUtil.h"
#import "NSString+MD5.h"
#import <AddressBook/AddressBook.h>
#import "SGSettingUtil.h"
#import "Utils.h"
#import "AppMacro.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation SGSettingUtil
//// 获取手机通讯录中所有的手机号码
//+ (NSMutableArray *)getAllPhoneNum{
//    NSMutableArray *array = [NSMutableArray array];
//    return array;
//}
/**
 * 解析字符串成键值对 <id=8242DAF5-EE30-407C-AC02-26B1A5C94AC0&ext=PNG>
 */
+ (NSDictionary *)dictionaryParseFromString:(NSString *)string
{
    if ( nil == string )
    {
        return nil;
    }
    
    NSMutableDictionary *retDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    NSArray *key_values = [string componentsSeparatedByString:@"&"];
    
    for ( NSString *key_value in key_values )
    {
        NSArray *keyAndValue = [key_value componentsSeparatedByString:@"="];
        
        @try {
            [retDict setObject:[keyAndValue objectAtIndex:1] forKey:[keyAndValue objectAtIndex:0]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            
        }
    }
    return retDict;
}

// 获取省份列表
+ (NSArray *)getProvinces {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ProvincesList" ofType:@"plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *provinceArray = [plistDict objectForKey:@"Provinces"];
    return provinceArray;
}

// 判断数据是否为空或空对象
+ (BOOL)dataIsNull:(id)string {
    if ([string isEqual:[NSNull null]] || string == nil) {
        return YES;
    }
    return NO;
}

// 判断数据是否为空或空对象(如果字符串的话是否为@"")
+ (BOOL)dataAndStringIsNull:(id)string {
    if ([string isEqual:[NSNull null]] || string == nil || [string isEqual:@""]) {
        return YES;
    }
    return NO;
}

/*
// 密码＋key md5
+ (NSString *)getMd5Password:(NSString *)password {
    return [NSString md5:[NSString stringWithFormat:@"%@%@",password,kPasswordKey]];
}
*/

// 设置label的 部分字体颜色
+ (void)setAttributeLabel:(UILabel *)label font:(UIFont *)font color:(UIColor *)color rangeArray:(NSArray *)array {
    if (label.text != nil) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
        for (NSString *string in array) {
            NSRange range = [label.text rangeOfString:string];
            //设置字号
            [str addAttribute:NSFontAttributeName value:font range:range];
            //设置文字颜色
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        label.attributedText = str;
    }
}

// 根据城市代码得到对应的城市
+ (NSString *)getCityNameByCityCode:(NSString *)cityCode {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProvincesList" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *ary = [dic objectForKey:@"Provinces"];
    for (NSDictionary *tmpDic in ary) {
        if ([[tmpDic objectForKey:@"code"] isEqualToString:cityCode]) {
            return [tmpDic objectForKey:@"value"];
        }
    }
    
    return nil;
}

// 处理手机号格式
+ (NSString*)telephoneWithReformat:(NSString *)tmpString
{
    NSString *resultString =[NSString stringWithString:tmpString];
    if ([resultString containsString:@"-"])
    {
        resultString = [resultString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([resultString containsString:@" "])
    {
        resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([resultString containsString:@"("])
    {
        resultString = [resultString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([resultString containsString:@")"])
    {
        resultString = [resultString stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    // 最后再次去掉空格
//    NSString *finalString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString * finalString = [resultString stringByTrimmingCharactersInSet:whitespace];
    return finalString;
}

/*
// 根据手机号获取对应的姓名
+ (NSString *)getPhoneNameByPhoneNum:(NSString *)phoneNum {
    // Create addressbook data model
    ABAddressBookRef addressBooks = nil;
    //判断当前系统的版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        //如果不小于6.0，使用对应的api获取通讯录，注意，必须先请求用户的同意，如果未获得同意或者用户未操作，此通讯录的内容为空
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);//等待同意后向下执行//为了保证用户同意后在进行操作，此时使用多线程的信号量机制，创建信号量，信号量的资源数0表示没有资源，调用dispatch_semaphore_wait会立即等待。若对此处不理解，请参看GCD信号量同步相关内容。
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
            //如果用户同意，才会执行此block里面的方法
            //此方法发送一个信号，增加一个资源数
            dispatch_semaphore_signal(sema);});
        //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
        //当用户选择同意，block的方法被执行， sema资源数为1；
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        SGAddressBookModel *addressBook = [[SGAddressBookModel alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.rowSelected = NO;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                if (valuesRef != NULL) {
                    CFRelease(valuesRef);
                }
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++)
            {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *tmpStr =[NSString stringWithFormat:@"%@",value];
                        //NSString *resultStr =[tmpStr telephoneWithReformat:tmpStr];
                        addressBook.tel = [SGSettingUtil telephoneWithReformat:tmpStr];
                        if ([phoneNum isEqual:addressBook.tel])
                        {
                            // fansj
                            CFRelease(value);
                            CFRelease(allPeople);
                            CFRelease(valuesRef);
                            CFRelease(abName);
                            if(abLastName != NULL) CFRelease(abLastName);
                            if(abFullName != NULL) CFRelease(abFullName);
                            return addressBook.name;
                        }
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    CFRelease(allPeople);
    if(addressBooks != NULL)CFRelease(addressBooks);
    
    return nil;
}


// 获取手机通讯录中所有的手机号码
+ (NSMutableArray *)getAllPhoneNum {
    // Create addressbook data model
    NSMutableArray *addressBookPhoneNumArray = [NSMutableArray array];
    
    ABAddressBookRef addressBooks = nil;
    //判断当前系统的版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        //如果不小于6.0，使用对应的api获取通讯录，注意，必须先请求用户的同意，如果未获得同意或者用户未操作，此通讯录的内容为空
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);//等待同意后向下执行//为了保证用户同意后在进行操作，此时使用多线程的信号量机制，创建信号量，信号量的资源数0表示没有资源，调用dispatch_semaphore_wait会立即等待。若对此处不理解，请参看GCD信号量同步相关内容。
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
            //如果用户同意，才会执行此block里面的方法
            //此方法发送一个信号，增加一个资源数
            dispatch_semaphore_signal(sema);});
        //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
        //当用户选择同意，block的方法被执行， sema资源数为1；
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        SGAddressBookModel *addressBook = [[SGAddressBookModel alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        addressBook.rowSelected = NO;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                if (valuesRef != NULL) {
                    CFRelease(valuesRef);
                }
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++)
            {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString *tmpStr =[NSString stringWithFormat:@"%@",value];
                        addressBook.tel = [SGSettingUtil telephoneWithReformat:tmpStr];
                        
                        SGUserModel *model = [SGUserInfo getUserInfo];
                        // 验证手机号并且把自己的手机号过滤掉
                        if ([SGVerifyUtil checkPhoneNum:addressBook.tel]) {
                            if (![addressBook.tel isEqualToString:model.telephone]) {
                                [addressBookPhoneNumArray addObject:addressBook.tel];
                            }
                        }
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    
    CFRelease(allPeople);
    CFRelease(addressBooks);
    
    return addressBookPhoneNumArray;
}

// 获取手机通讯录授权情况
+ (BOOL)getAddressBookAuthorizationStatus {
    ABAddressBookRef addressBook = NULL;
    __block BOOL accessGranted = NO;
    if (&ABAddressBookRequestAccessWithCompletion != NULL)
    {
        // we're on iOS 6
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    return accessGranted;
}
 */

// 根据文本内容自动得到view高度
+ (CGSize)getHeightByString:(NSString *)string andWithViewWidth:(CGFloat)width andWithFontSize:(CGFloat)fontSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(width, 1000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return textSize;
}

// 给某个view加线(上下线)
+ (void)addLineWithView:(UIView *)view withUpLineFrame:(CGRect)upFrame withDownLineFrame:(CGRect)downFrame withColor:(UIColor *)color {
    UILabel *upLine = [[UILabel alloc] initWithFrame:upFrame];
    upLine.backgroundColor = color;
    [view addSubview:upLine];
    
    UILabel *downLine = [[UILabel alloc] initWithFrame:downFrame];
    downLine.backgroundColor = color;
    [view addSubview:downLine];
}

// 根据frame加线
+ (void)addLineWithView:(UIView *)view withLineFrame:(CGRect)lineFrame withColor:(UIColor *)color {
    UILabel *line = [[UILabel alloc] initWithFrame:lineFrame];
    line.backgroundColor = color;
    [view addSubview:line];
}

// 设置一段字符串显示两种颜色
+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor withTextFontSize:(CGFloat)fontSize {
    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    if (oneStr) {
        NSRange range1 = NSMakeRange(0, oneStr.length);
        [registerStr setAttributes:@{NSForegroundColorAttributeName:oneColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                             range:range1];
    }
    if (otherStr) {
        NSRange range2 = NSMakeRange(oneStr.length, otherStr.length);
        
        [registerStr setAttributes:@{NSForegroundColorAttributeName:otherColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                             range:range2];
    }
    
    return registerStr;
}

// 设置一段字符串显示两种颜色,并且设置每段字符串的字体大小
+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor  oneStrFontSize:(CGFloat)oneSize otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor otherStrFontSize:(CGFloat)otherSize {
    NSMutableAttributedString *registerStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    if (oneStr) {
        NSRange range1 = NSMakeRange(0, oneStr.length);
        [registerStr setAttributes:@{NSForegroundColorAttributeName:oneColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:oneSize]}
                             range:range1];
    }
    if (otherStr) {
        NSRange range2 = NSMakeRange(oneStr.length, otherStr.length);
        
        [registerStr setAttributes:@{NSForegroundColorAttributeName:otherColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:otherSize]}
                             range:range2];
    }
    
    return registerStr;
}

// 给某个view添加手势
+ (void)addTapGestureInView:(UIView *)inView addTarget:(id)target action:(SEL)action withTag:(NSInteger)viewTag {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [tapGesture setCancelsTouchesInView:NO];
    tapGesture.numberOfTapsRequired = 1;
    inView.tag = viewTag;
    [inView addGestureRecognizer:tapGesture];    
}

//  绘制有色矩形view
+ (UIView *)drawColorViewWithRect:(CGRect)rect withColor:(UIColor *)color {
    UIView *colorView = [[UIView alloc] initWithFrame:rect];
    colorView.backgroundColor = color;
    return colorView;
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

//  生成UIButton对象
+ (UIButton *)allocBtnWithRect:(CGRect)rect withBtnType:(UIButtonType)btnType withBtnTitle:(NSString *)btnTitle withTitleColor:(UIColor *)titleColor withTitleFontSize:(CGFloat)fontSize addTarget:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:btnType];
    btn.frame = rect;
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

// 判断字符串为空或者全为空格
+ (BOOL)isBlankString:(NSString *)string {
        if (string == nil) {
            return YES;
        }
        if (string == NULL) {
            return YES;
        }
        if ([string isKindOfClass:[NSNull class]]) {
            return YES;
        }
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
            return YES;
        }
        return NO;
}

// 从字符串中提取里边的数字
+ (NSInteger)findNumFromStr:(NSString *)string {
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    // Result.
    NSInteger number = [numberString integerValue];
    return number;
}

// 获取字符串字节数
+ (NSInteger)charNumberForString:(NSString*)str {
    NSInteger strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}


// 传入两个view使两个view处于水平同一条线上
+ (void)changeViewHorizontalCenterWithOneView:(UIView *)oneView withOtherView:(UIView *)otherView {
    CGPoint oneViewCenter  = oneView.center;
    
    CGPoint resultOtherCenter;
    resultOtherCenter.x = otherView.center.x;
    resultOtherCenter.y = oneViewCenter.y;
    otherView.center = resultOtherCenter;
}

// 对UIImage进行base64转码
+ (NSString *)base64WithImage:(UIImage *)image {
    NSMutableDictionary *systeminfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"systeminfo"]];
    float o = 0.1;
    if (!image){//如果没有图则不操作
        return @"";
    }
    image = [self scaleImage:image toWidth:image.size.width/3 toHeight:image.size.height/3];
    if (systeminfo){//如果有系统设置信息
        if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"大"]){
            o=0.7;
        }
        if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"中"]){
            o=0.5;
        }
        if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"小"]){
            o=0.2;
        }
    }
    NSData* pictureData = UIImageJPEGRepresentation(image,o);
    NSString* pictureDataString = [self base64EncodingWithData:pictureData];
    return pictureDataString;
}

#pragma mark - 内部调用方法
+ (UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight {
    int width=0;
    int height=0;
    int x=0;
    int y=0;
    
    if (image.size.width<toWidth){
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }else if (image.size.height<toHeight){
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }else if (image.size.width>toWidth){
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }else if (image.size.height>toHeight){
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }else{
        height = toHeight;
        width = toWidth;
    }
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return subImage;
}

+ (NSString *)base64EncodingWithData:(NSData *)imageData;
{
    if ([imageData length] == 0)
        return @"";
    
    char *characters = malloc((([imageData length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [imageData length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [imageData length])
            buffer[bufferLength++] = ((char *)[imageData bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
