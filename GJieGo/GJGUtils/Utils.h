//
//  Utils.h
//  PlayMusicTool
//
//  Created by 陈 宏 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "Order.h"
//#import "DataSigner.h"

typedef enum{
    ALiPaySucceed=9000,//订单支付成功
    ALiPayProcessing=8000,//正在处理中
    ALiPayFailure=4000,//订单支付失败
    ALiPayCancel=6001,//用户中途取消
    ALiPayNetLinkError=6002 //网络连接出错
}ALiPayResultType;

//支付类型
typedef enum{
    PaytypeWiXin=0,//微信支付
    PaytypeALi,//支付宝支付
}Paytype;

typedef enum {
    NONE=0, //没有网络
    IS3G, //3G网络
    ISWIFI,  //
    ERROR //顺序循环
} NetWorkType;


typedef enum {
    WeekType=0,
    MonthType,
}TimeStateType;

@interface Utils : NSObject

+(Utils *)sharesInstance;

+(NSString *)getDefaultFilePathString:(NSString *)fileName;

+(NSString *)getDocumentFilePathString:(NSString *)fileName;

+(NSString *)getLibraryFilePathString:(NSString *)fileName;

+(NSString *)getCacheFilePathString:(NSString *)fileName;

+(NSString *)getCachePathString;

+(NSString *)getTempPathString;

+(NSString *)getTempFilePathString:(NSString *)fileName;

+(NSString *)getResourceFilePathString:(NSString *) resourceName ofType:(NSString*)typeName;

///删除目录下所有文件
+(void)removeFile:(NSString *)folderPath;

//获得存储文件的路径
+ (NSString *)getSaveFilePath:(NSString *)fileName;

///保存文件
+ (void)saveFilePath:(NSString *)filepath fileData:(id)info andEncodeObjectKey:(NSString *)key;
///读取文件
+ (NSData *)loadDataFromFile:(NSString *)fileName anddencodeObjectKey:(NSString *)key;
///获得配置信息
+ (NSString *)loadClientVersionKey:(NSString *)key;

//文件是否存在在某路径下
+ (BOOL)isHaveFileAtPath:(NSString *)path;

//判断文件夹是否存在
+(BOOL)judgeFileExist:(NSString * )fileName;

+(long long) fileSizeAtPath:(NSString*) filePath;
+(long long)folderSize:(const char *)folderPath ;

+(NSInteger)weiBoCountWord:(NSString*)s;
//去掉前后空格
+ (NSString *) getDisposalStr:(NSString *)s;
+ (NSString *)md5:(NSData *)data;

+(BOOL)isEmail:(NSString *)input;
+(BOOL)isMobileNum:(NSString *)input;
+(BOOL)isIdentityCardNo:(NSString *)input;
+(BOOL)isYouBian:(NSString*)input;
/// 判断是不是数字
+(BOOL)isNumber:(NSString *)input;

///  把 毫秒 转为时间 yyyy-mm-dd HH:mm:ss
+ (NSString *)millisecondConvertedToDay:(unsigned long long )time;

+ (NSString *)millisecondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format;

///  把 秒 转为时间 yyyy-mm-dd HH:mm:ss
+ (NSString *)secondToDateByFormatter:(unsigned long long)time formattter:(NSString * ) format;

///把字符串时间转为指定的格式
+ (NSString *)translateDateString:(NSString *)translateDateString format:(NSString *)format toFormat:(NSString *)tofarmt;
///根据指定日期返回周几 从周日开始，周日为0
+ (NSString *)getWeekdayFromDate:(NSString *)dateStr formatter:(NSString *)matter;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

//修改图片的size
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;

+(NSString *)ToHex:(long long int)tmpid;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//得到日期开始和结束时间
+(NSArray *)getStartDayAndEndDay:(TimeStateType)type;

/**
 * @brief 计算字符串的高度.
 *
 * @param  fontSize  字体型号.
 * @param  width  视图的宽度.
 *
 */
+ (CGFloat)heightForString:(NSString *)string fontSize:(float)fontSize andWidth:(float)width;

/**
 * @brief 计算字符串的长度.
 *
 * @param  fontSize  字体型号.
 * @param  height  视图的高度.
 *
 */
+ (CGFloat)widthForString:(NSString *)string fontSize:(float)fontSize andHeight:(float)height;

///将字符串转换为按照指定间隔分隔的字符串
+ (NSString *)translateToCardString:(NSString *)string interval:(NSInteger)interval;

///设置一段字符串显示两种颜色
+ (NSAttributedString *)getDifferentColorString:(NSString *)totalStr oneStr:(NSString *)oneStr color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherColor:(UIColor *)otherColor;

///设置一段字符串显示两种字体
+ (NSAttributedString *)getDifferentFontString:(NSString *)totalStr oneStr:(NSString *)oneStr font:(UIFont *)oneFont color:(UIColor *)oneColor otherStr:(NSString *)otherStr ortherFont:(UIFont *)otherFont ortherColor:(UIColor *)otherColor;
/*设置一段字符，显示不同的字体颜色
 *info: @[@[string,color,font],@[string,color,font],@[string,color,font]]
 *totalStr:完整的字符串
 */
+ (NSAttributedString *)getDifferentFontStringWithTotalString:(NSString *)totalStr andInfo:(NSArray *)info;

+ (NSString *)getBankName:(NSString *)bankCode;
+ (NSString *)getBankLogo:(NSString *)bankCode;
+ (NSString *)getBankCardType:(NSString *)bankCardtype;

///将多个字符串的结合，按照指定的间隔符进行分割，拼接成一个字符串
+ (NSString *)stringByStepetorStr:(NSString *)str andInfo:(NSString *)info,...NS_REQUIRES_NIL_TERMINATION;
+ (NSMutableAttributedString *)getLineSpaceString:(NSString *)string lineSpace:(CGFloat)space alignment:(NSTextAlignment)alignment;

///返回一条线
+ (UILabel *)lineLabelWithFrame:(CGRect)frame color:(UIColor *)color;

// 根据frame加线
+ (void)addLineWithView:(UIView *)view withLineFrame:(CGRect)lineFrame withColor:(UIColor *)color;

//UILabel设置文本颜色
+ (NSMutableAttributedString *)setTextColor:(UIColor *)textColor  withRange:(NSRange)textRange withString:(NSString *)string;

// 判断数据是否为空或空对象
+ (BOOL)dataIsNull:(id)string;

// 登录密码md5
+ (NSString *)getMd5Password:(NSString *)password;

// 根据文本内容自动得到view高度
+ (CGSize)getHeightByString:(NSString *)string andWithViewWidth:(CGFloat)width andWithFontSize:(CGFloat)fontSize;

// 给view添加边框
+ (void)changeRoundViewWithBorderView:(UIView *)aView withRadius:(float)radius withBorderColor:(UIColor *)bColor;

// 给某个view添加手势
+ (void)addTapGestureInView:(UIView *)inView addTarget:(id)target action:(SEL)action withTag:(NSInteger)viewTag;

/**
 * 设置view属性，圆角、边框
 *
 * @param aView 需设置的视图
 * @param radius 圆角弧度
 * @param bColor 边框颜色
 * @param board 边框像素
 **/
+ (void)changeRoundViewWithBorderView:(UIView *)aView withRadius:(float)radius withBorderColor:(UIColor *)bColor board:(CGFloat)board;

// 日期选取器得到日期
+ (NSString *)getStringFromDate:(NSDate *)date;

// 改变线条颜色和高度
+ (void)changeLineHeightAndColor:(UILabel *)line;

// alloc一个UIImageView到一个view上边
+ (UIImageView *)allImageViewWithFrame:(CGRect)frame withImageName:(NSString *)imageName;

//检测手机号是否合法
+ (BOOL)validateMobile:(NSString *)mobileNum;

//  生成UILabel对象
+ (UILabel *)allocLabelWithRect:(CGRect)rect withTextColor:(UIColor *)color withTextAligment:(NSTextAlignment)textAlignment withTextFontSize:(CGFloat)fontSize withTitle:(NSString *)title;
//截取时间
+ (NSString *)returnTimeString:(NSString *)pointTime;

#pragma mark -- 支付
//+(void)orderPay:(NSString *)orderId oderInfo:(Order *)order id:(id)delegate payType:(Paytype)type  success:(void (^)(NSDictionary* responseObject))success
//      exception:(void (^)(NSDictionary* responseObject))exception
//        failure:(void (^)(NSError *error))failure;

@end
