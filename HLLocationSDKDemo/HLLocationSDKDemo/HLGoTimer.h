//
//  HLGoTimer.h
//  HLLocationSDKDemo
//
//  Created by lhl on 15/5/6.
//  Copyright (c) 2015年 LHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLGoTimer : NSObject


/**
 *  获取当前时间，内部会自定转换格式，得到字符串。 方法调用之前先调用此方法
 *
 *  @return 返回当前时间固定格式的字符串
 */
+ (NSString *)startDateString;



/**
 *  根据先前的时间，与现在的时间差进行相减，得到执行方法的时间
 *
 *  @param startDateStr 方法执行前的时间字符串
 *
 *  @return 返回执行了多少时间
 */
+ (float)endDateString:(NSString *)startDateStr;


@end
