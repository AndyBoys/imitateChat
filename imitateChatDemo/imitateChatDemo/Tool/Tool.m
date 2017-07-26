//
//  Tool.m
//
//  Created by Legso on 15/6/30.
//  Copyright (c) 2015年 Arthur. All rights reserved.
//

#import "Tool.h"
#import "CommonCrypto/CommonDigest.h"//MD5加密包

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue] //系统版本号

@implementation Tool

+ (NSString *)chineseToPinYin:(NSString*)sourceString
{
    
    if ([sourceString isEqualToString:@""])
    {
        return sourceString;
    }
    
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    if ([[(NSString *)sourceString substringToIndex:1] compare:@"长"] ==NSOrderedSame)
    {
        [source replaceCharactersInRange:NSMakeRange(0, 5)withString:@"chang"];
    }
    if ([[(NSString *)sourceString substringToIndex:1] compare:@"厦"] ==NSOrderedSame)
    {
        [source replaceCharactersInRange:NSMakeRange(0, 3)withString:@"xia"];
    }
    if ([[(NSString *)sourceString substringToIndex:1] compare:@"重"] ==NSOrderedSame)
    {
        [source replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    if ([[(NSString *)sourceString substringToIndex:1] compare:@"朝"] ==NSOrderedSame)
    {
        [source replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chao"];
    }
    return source;
}

+ (BOOL)isStringEmpty:(NSString*)aStr
{
    if (aStr == nil)
    {
        return NO;
    }
    if (aStr == NULL)
    {
        return NO;
    }
    if ([aStr isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    if ([[aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return NO;
    }
    if ([aStr isEqualToString:@"null"])
    {
        return NO;
    }
    
    return YES;
}

+(NSString *)ToMD5:(NSString*)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//得到view的viewController
+(UIViewController*)getViewController:(UIView*)view
{
    //事件响应者链拿到视图控制器
    id next = [view nextResponder];
    while (next != nil)
    {
        next = [next nextResponder];
        
        if ([next isKindOfClass:[UIViewController class]])
        {
            UIViewController *VC = (UIViewController *)next;
            return VC;
            break;
        }
    }
    
    return nil;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+(void)AutoCancelAlertView:(NSString*)aTitleString message:(NSString*)aMessageString
{
    UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:aTitleString
                                                        message:aMessageString
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    [AlertView show];
    [AlertView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:[NSNumber numberWithInt:0] afterDelay:2];
    
}


+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location
{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+(void)wiggleView:(UIView *)view
{
    CALayer*viewLayer=[view layer];
    
    //基本动画
    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration=0.2;//动画时长
    animation.repeatCount = 0;//重复100000次
    animation.autoreverses=YES;//动画结束时是否执行逆动画
    //设定动画的开始帧和结束帧
    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, -0.03, 0.0, 0.0, 0.03)];
    animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, 0.03, 0.0, 0.0, 0.03)];
    //为Layer添加设置完成的动画，可以给Key指定任意名字。
    [viewLayer addAnimation:animation forKey:@"wiggle"];
}

+ (void)rotateViewPI:(UIView *)view
{
    CGAffineTransform rotate = CGAffineTransformRotate(view.transform, M_PI);
    view.transform = rotate;
}

+ (NSString *)getDeviceCode
{
    NSString *code;
    if([[UIDevice currentDevice].systemVersion floatValue]>=7)
    {
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        NSString *uuidStr = [uuid UUIDString];
        code = uuidStr;
    }
    else
    {
        code = [self getMacAddress];
    }
    
    if(!code)
    {
        code = @"UUID_ERROR";
    }
    return code;
}
+ (NSString *) getMacAddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    
    free(buf);
    
    return [outstring uppercaseString];
}

+(NSString*)getVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

+(NSString*)getAppName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


+(NSString*)dateToDateString:(NSDate*)date formatter:(NSString*)formatter
{
    if (formatter && date)
    {
        NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
        [dateformat setDateFormat:formatter];
        return [dateformat stringFromDate:date];
    }
    else
    {
        return @"";
    }
    
}

+(NSString*)dateStringToDateString:(NSString*)timeString timeFormatter:(NSString *)timeFormatter newFormatter:(NSString*)newFormatter
{
    if (timeString && timeFormatter && newFormatter)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: timeFormatter];
        NSDate *destDate = [dateFormatter dateFromString:timeString];
        
        return [self dateToDateString:destDate formatter:newFormatter];
    }
    else
    {
        return @"";
    }
    
}

+(NSDate*)dateStringToDate:(NSString *)dateString formatter:(NSString*)formatter
{
    if (dateString && formatter)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: formatter];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        return [dateFormatter dateFromString:dateString];
    }
    else
    {
        return nil;
    }
}

+(NSDate*)getCurrentDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
    return date;
}

+(NSString*)getWeekNameFromDate:(NSDate*)date
{
    if (date && [date isKindOfClass:[NSDate class]])
    {
        NSCalendar          *calendar = [NSCalendar currentCalendar];
        NSDateComponents    *comps;
        if (SYSTEMVERSION >= 8.0)
        {
            comps = [calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:date];
        }
        else
        {
            comps =[calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:date];
        }
        
        NSInteger weekday = [comps weekday];
        
        NSArray *arrays = [NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
        
        if (weekday>0 && weekday<=[arrays count])
        {
            return [arrays objectAtIndex:weekday-1];
        }
    }
    
    return @"";
}

+(NSString*)getWeekNameFromString:(NSString*)dateString formatter:(NSString *)formatter
{
    if (dateString && [dateString isKindOfClass:[NSString class]])
    {
        NSDate *destDate = [self dateStringToDate:dateString formatter:formatter];
        return [self getWeekNameFromDate:destDate];
    }
    return @"";
}

+ (CGSize)calculateLabelWithString:(NSString *)text labelSize:(CGSize)labelSize font:(UIFont *)font
{
    if (SYSTEMVERSION>=7.0)
    {
       return [text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else
    {
       return [text sizeWithFont:font constrainedToSize:labelSize lineBreakMode:NSLineBreakByWordWrapping];
    }
}


+ (void)drawText:(NSString *)text rect:(CGRect)frame color:(UIColor *)color font:(UIFont *)font
{
    if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
    {
        
        NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes= [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,color,NSForegroundColorAttributeName,nil];
        [text drawInRect:frame withAttributes:attributes];
    }
    else
    {
        [color setFill];
        [text drawInRect:frame withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    }
}


+ (UIImagePickerController *)getPhotoAlbumWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = delegate;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    else
    {
        NSLog(@"该设备没有相册!");
    }
    return imagePicker;
}

+ (UIImagePickerController *)getCameraWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = delegate;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        NSLog(@"该设备没有相机!");
    }
    return imagePicker;
}


/**
 *  创建文件夹
 *  @param folderName 文件夹名
 */
+ (NSString *)createFolder:(NSString *)folderName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/%@/",[paths lastObject],folderName];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManage fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    if (!existed)
    {
        [fileManage createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}


+ (UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

+(NSString*)GetWeekNameFromStringIsNow:(NSString*)adateString
{
    if (adateString && [adateString isKindOfClass:[NSString class]])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
        NSDate *destDate = [dateFormatter dateFromString:adateString];
        return [self GetWeekNameFromDateIsNow:destDate];
    }
    return @"";
}

+(NSString*)GetWeekNameFromDateIsNow:(NSDate*)adate
{
    if (adate && [adate isKindOfClass:[NSDate class]])
    {
        NSDate *nowDate = [NSDate date];
        if ([[Tool dateFormatString:@"yyyyMMdd" setDate:adate] compare:[Tool dateFormatString:@"yyyyMMdd" setDate:nowDate]] == NSOrderedSame)
        {
            return @"今天";
        }
        
        
        NSCalendar          *calendar = [NSCalendar currentCalendar];
        NSDateComponents    *comps;
        comps =[calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal)
                           fromDate:adate];
        NSInteger weekday = [comps weekday];
        
        NSArray *arrays = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
        
        if (weekday>0 && weekday<=[arrays count])
        {
            return [arrays objectAtIndex:weekday-1];
        }
    }
    return @"";
}

/*
 *时间格式化
 *输入 Fromat的格式   和    NSDate
 *返回 正常时间
 */
+(NSString*)dateFormatString:(NSString*)afromat setDate:(NSDate*)adate
{
    if (afromat && adate)
    {
        NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
        [dateformat setDateFormat:afromat];
        return [dateformat stringFromDate:adate];
    }
    return @"";
}

/*
 *天气图标
 *
 *根据天气code得到天气图标
 *返回 白天天气图标
 */
+(UIImage*)getDayWeatherImage:(NSString*)aWeatherCode
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"day_%@.png",aWeatherCode]];
    if (image)
    {
        return image;
    }
    return [UIImage imageNamed:@"day_NA.png"];
}

+(UIImage *)getNightWeatherImage:(NSString *)aWeatherCode
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"night_%@.png",aWeatherCode]];
    if (image)
    {
        return image;
    }
    return [UIImage imageNamed:@"night_NA.png"];
}

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect )rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/*
 *保存数据进入默认设置中
 */
+(void)saveUserDefaultsInfo:(id)amessage :(NSString*)aKeyString
{
//    if (amessage && aKeyString)
//    {
//        
//        NSString *newPath = [NSString stringWithFormat:@"%@/userSettingInfo.plist",KDocumentsPath];
//        
//        if (![Tool isFileExitPath:newPath])
//        {
//            NSDictionary *setDictionary = [[NSDictionary alloc] init];
//            [setDictionary writeToFile:newPath atomically:YES];
//        }
//        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:newPath]];
//        [dic setObject:amessage forKey:aKeyString];
//        [dic writeToFile:newPath atomically:YES];
//    }
}
//读取
+(id)readUserDefaultsInfo:(NSString*)aKeyString
{
//    if (aKeyString)
//    {
//        NSString *newPath = [NSString stringWithFormat:@"%@/userSettingInfo.plist",KDocumentsPath];
//        
//        if ([Tool isFileExitPath:newPath])
//        {
//            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:newPath];
//            id data = [dic valueForKeyPath:aKeyString];
//            if (data)
//            {
//                return data;
//            }
//        }
//    }
    return nil;
}

//删除
+(void)removeUserDefaults:(NSString*)aKeyString
{
//    if (aKeyString)
//    {
//        NSString *newPath = [NSString stringWithFormat:@"%@/userSettingInfo.plist",KDocumentsPath];
//        
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:newPath]];
//        [dic removeObjectForKey:aKeyString];
//        [dic writeToFile:newPath atomically:YES];
//    }
}

/*
 *函数名称:isFileExitPath
 *函数功能:判断aPath路径下面的文件是否存在
 *参数说明:
 *  输入:aPath--文件路径
 *  输出:是否存在
 */
+(BOOL)isFileExitPath:(NSString*)aPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:aPath])
    {
        
        return YES;
    }
    return NO;
}

//设置aqi上面的颜色
+(UIColor *)getAqiTextcolor:(NSString *)aqistr
{
    UIColor *selfcolor;
    NSInteger numberint=aqistr.intValue;
    if (numberint<=50)
    {
        selfcolor=RGBACOLOR(0, 241, 19, 1.0f);
    }
    else if (numberint<=100)
    {
        selfcolor=RGBACOLOR(255, 255, 1, 1.0f);
    }
    else if (numberint<=150)
    {
        selfcolor=RGBACOLOR(255, 127, 0, 1.0f);
    }
    else if (numberint<=200)
    {
        selfcolor=RGBACOLOR(255, 0, 0, 1.0f);
    }
    else if (numberint<=300)
    {
        selfcolor=RGBACOLOR(255, 0, 255, 1.0f);
    }
    else if (numberint<=5000)
    {
        selfcolor=RGBACOLOR(153, 102, 51, 1.0f);
    }
    return selfcolor;
}


+(NSString *)getAirQualityWihtAQI:(NSInteger)AQI
{
    NSString *airQualityStr = @"-";
   if(AQI>=0 && AQI<=50)
   {
       airQualityStr = @"优";
   }
    else if (AQI>50 && AQI<=100)
    {
        airQualityStr = @"良";
    }
    else if (AQI>100 && AQI<=150)
    {
        airQualityStr = @"轻度污染";
    }
    else if (AQI>150 && AQI<=200)
    {
        airQualityStr = @"中度污染";
    }
    else if (AQI>200 && AQI<=300)
    {
        airQualityStr = @"重度污染";
    }
    else if (AQI>300 && AQI<=500)
    {
        airQualityStr = @"严重污染";
    }
    
    return airQualityStr;
}


/**  中文转拼音  */
+ (NSString *)pinYinWithString:(NSString *)chinese
{
    NSString  * pinYinStr = [NSString string];
    if (chinese.length){
        NSMutableString * pinYin = [[NSMutableString alloc]initWithString:chinese];
        //1.先转换为带声调的拼音

        if(CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", pinYin);
        }
        //2.再转换为不带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin: %@", pinYin);
            //3.去除掉首尾的空白字符和换行字符
            pinYinStr = [pinYin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            4.去除掉其它位置的空白字符和换行字符
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    return pinYinStr;
}



/**
 *  日期： 2017年6月1日更新
 *  作者：向生军
 **/
+(UIButton *)getButtonWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.tintColor = [UIColor clearColor];
//    [button.layer setMasksToBounds:YES];
//    [button.layer setBorderWidth:1];
//    [button.layer setBorderColor:[[UIColor grayColor] CGColor]];
    return button;
}


+(UILabel *)getLabelWithFrame:(CGRect)frame
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textColor  =[UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

+(UITextField *)getTextFieldWithFrame:(CGRect)frame
{
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.font = [UIFont systemFontOfSize:15];
    field.textColor = [UIColor blackColor];
    field.borderStyle=UITextBorderStyleLine;
    return field;
}

+(CGFloat)getMessageLength:(NSString *)content
{
    return [content sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil]].width;
}

+(CGSize)getHeightWithMessage:(NSString *)content size:(CGSize )size font:(UIFont *)font
{
    
  return  [content boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys: font,NSFontAttributeName, nil] context:nil].size;
    

}


@end
