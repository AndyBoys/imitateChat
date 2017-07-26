//
//  Tool.h
//
//  各种实用工具类
//
//  Created by Legso on 15/6/30.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface Tool : NSObject

/**
 @brief 汉字转拼音
 @param sourceString :要转换的汉字
 @return 汉字拼音
 */
+ (NSString *)chineseToPinYin:(NSString*)sourceString;

/**
 @brief 字符串是否为空
 @param aStr:要检查的字符串
 @return YES 不为空 NO 为空
 */
+ (BOOL)isStringEmpty:(NSString*)aStr;

/**
 @brief 是否是有效的电话号码
 */

/**
 @brief MD5加密
 @param inPutText : 要加密的字符串
 @return 加密后的字符串
 */
+(NSString *)ToMD5:(NSString*)inPutText;

/**
 @brief 获取View视图的控制器
 @param view 要获取控制器的视图
 @return UIViewController : 视图的控制器
 */
+(UIViewController*)getViewController:(UIView*)view;

/**
 @brief 将一个 NSString = @“#FF0000”转换成 RGB的方法
 @param color :#FF0000
 @return UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 @brief 提示弹出框 能自动消失
 @param aTitleString : 标题
 @param aMessageString : 信息
 */
+(void)AutoCancelAlertView:(NSString*)aTitleString message:(NSString*)aMessageString;

/**
 @brief 判断是不是在中国
 @param location经纬度
 @return NO在中国范围  YES不在中国范围
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/**
 @brief 抖动动画
 @param view 要抖动的视图
 */
+(void)wiggleView:(UIView *)view;

/**
 @brief 旋转视图180度
 @param view 要旋转的视图
 */
+ (void)rotateViewPI:(UIView *)view;

/**
 @brief 获取设备码 UUID
 @return 返回设备码
 */
+ (NSString *)getDeviceCode;


/**
 @brief 获取软件版本号
 @return 返回软件版本号
 */
+(NSString*)getVersion;


/**
 @brief 获取软件名
 @return 返回软件名
 */
+(NSString*)getAppName;


/**
 @brief 时间格式化
 @param fromat 需要的时间格式
 @param date 要格式的时间
 @return 格式后的北京时间
 */
+(NSString*)dateToDateString:(NSDate*)date formatter:(NSString*)formatter;

/**
 @brief 时间格式化
 @param newFromat 需要的时间格式
 @param timerString 要格式的时间字符串
 @param timeFormatter 要格式时间的时间格式
 @return 返回格式后的北京时间
 */
+(NSString*)dateStringToDateString:(NSString*)timeString timeFormatter:(NSString *)timeFormatter newFormatter:(NSString*)newFormatter;


/**
 @brief 时间字符串转换为时间
 @param formatter 时间格式
 @param dateString 时间字符串
 @return 返回北京时间
 */


+(NSDate*)dateStringToDate:(NSString *)dateString formatter:(NSString*)formatter;


/**
 @brief 获取北京时区的当前时间
 @return 返回北京时区的当前时间
 */
+(NSDate*)getCurrentDate;


/**
 @brief 根据时间获取星期
 @param date 时间
 @return 返回星期
 */
+(NSString*)getWeekNameFromDate:(NSDate*)date;


/**
 @brief 根据时间字符串返回星期
 @param dateString 时间字符串
 @param formatter 时间字符串格式
 @return 返回星期
 */
+(NSString*)getWeekNameFromString:(NSString*)dateString formatter:(NSString *)formatter;


/**
 @brief 计算UILabel的大小
 @param text UILabel显示文本
 @param labelSize UILabel的大小
 @param font UILabel的字体
 */
+ (CGSize)calculateLabelWithString:(NSString *)text labelSize:(CGSize)labelSize font:(UIFont *)font;

/**
 @brief 绘制文字
 @param text  需要被绘制的文字
 @param frame 绘制文字的rect
 */
+ (void)drawText:(NSString *)text rect:(CGRect)frame color:(UIColor *)color font:(UIFont *)font;


/**
 @brief 进入相册
 @param delegate 代理
 */
+ (UIImagePickerController *)getPhotoAlbumWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;


/**
 @brief 调用相机
 @param delegate 代理
 */
+ (UIImagePickerController *)getCameraWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

/**
 *  @brief在Document中创建文件夹
 *  @param folderName 文件夹名
 */
+ (NSString *)createFolder:(NSString *)folderName;


/**
 *  @brief  截屏
 *
 *  @param view 截取视图
 *
 *  @return 返回截取后的图片
 */
+ (UIImage *)captureImageFromView:(UIView *)view;

/**
 *  @brief 修改图片大小
 *
 *  @param image      原图片
 *  @param targetSize 图片的新大小
 *
 *  @return 修改尺寸后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

+(NSString*)GetWeekNameFromStringIsNow:(NSString*)adateString;

+(NSString*)GetWeekNameFromDateIsNow:(NSDate*)adate;

+(NSString*)dateFormatString:(NSString*)afromat setDate:(NSDate*)adate;

+(UIImage*)getDayWeatherImage:(NSString*)aWeatherCode;

+(UIImage *)getNightWeatherImage:(NSString *)aWeatherCode;

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect )rect;

+(void)saveUserDefaultsInfo:(id)amessage :(NSString*)aKeyString;

+(id)readUserDefaultsInfo:(NSString*)aKeyString;

+(void)removeUserDefaults:(NSString*)aKeyString;


/**
 * 返回空气质量指数-色斑图
 */
+(UIColor *)getAqiTextcolor:(NSString *)aqistr;

/**
 * 返回空气质量
 */
+(NSString *)getAirQualityWihtAQI:(NSInteger)AQI;



/**  中文转拼音  */
+ (NSString *)pinYinWithString:(NSString *)chinese;


/**
 创建 UITextField

 @param frame frame 相对于父视图布局
 @return return value UITextField
 */
+(UITextField *)getTextFieldWithFrame:(CGRect)frame;



/**
 Description

 @param frame frame description
 @return return value description
 */
+(UILabel *)getLabelWithFrame:(CGRect)frame;



/**
 Description

 @param frame frame description
 @return return value description
 */
+(UIButton *)getButtonWithFrame:(CGRect)frame;


/**
 获取文字的宽

 @param content content description
 @return return value description
 */
+(CGFloat)getMessageLength:(NSString *)content;


/**
 获取文字的宽和高

 @param content content description
 @param size size description
 @param font font description
 @return return value description
 */
+(CGSize)getHeightWithMessage:(NSString *)content size:(CGSize )size font:(UIFont *)font;

@end
