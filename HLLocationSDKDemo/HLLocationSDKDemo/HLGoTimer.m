//
//  HLGoTimer.m
//  HLLocationSDKDemo
//
//  Created by lhl on 15/5/6.
//  Copyright (c) 2015年 LHL. All rights reserved.
//

#import "HLGoTimer.h"

@implementation HLGoTimer

/**
 *  获取当前时间，内部会自定转换格式，得到字符串。 方法调用之前先调用此方法
 *
 *  @return 返回当前时间固定格式的字符串
 */
+ (NSString *)startDateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"] // 输出格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSSSS"];  // 输出格式
    
    //[dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"]; // 输出格式
    // 时间字符串
    return [dateFormatter stringFromDate:[NSDate date]];
}


/**
 *  根据先前的时间，与现在的时间差进行相减，得到执行方法的时间
 *
 *  @param startDateStr 方法执行前的时间字符串
 *
 *  @return 返回执行了多少秒
 */
+ (float)endDateString:(NSString *)startDateStr
{
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    
    [formatters setDateStyle:NSDateFormatterMediumStyle];
    [formatters setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"] // 输出格式
    
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSSSS"];  // 输出格式
    
    
    NSDate *dateS = [formatters dateFromString:startDateStr];
    float endFloat = [[NSDate date] timeIntervalSinceDate:dateS];
    return endFloat;
}


@end
