//
//  HLAllSDKLcationManager.h
//  HLLocationSDKDemo
//
//  Created by lhl on 15/5/6.
//  Copyright (c) 2015年 LHL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QMapKit/QMapKit.h>
#import <MAMapKit/MAMapKit.h>
#import "BMapKit.h"

typedef void(^KSystemLocationBlock)(CLLocation *loction, NSError *error);
typedef void(^KBMKLocationBlock)(BMKUserLocation *loction, NSError *error);
typedef void(^KQMapLocationBlock)(QUserLocation *loction, NSError *error);
typedef void(^KMAMapLocationBlock)(MAUserLocation *loction, NSError *error);


@interface HLAllSDKLcationManager : NSObject

+ (void)installMapSDK;


+ (id)shareInstance;

/**
 *  启动系统定位
 *
 *  @param systemLocationBlock 系统定位成功或失败回调成功
 */
- (void)startSystemLocationWithRes:(KSystemLocationBlock)systemLocationBlock;

/**
 *  启动高德定位
 *
 *  @param maMapLocationBlock 高德定位成功或失败回调成功
 */
- (void)startGaodeLocationWithReg:(KMAMapLocationBlock)maMapLocationBlock;

/**
 *  启动腾讯地图定位
 *
 *  @param qMapLocationBlock 腾讯地图定位成功或失败回调成功
 */
- (void)startQmapLocationWithReg:(KQMapLocationBlock)qMapLocationBlock;

/**
 *  启动百度地图定位
 *
 *  @param bmkLocationBlock 百度地图定位成功或失败回调成功
 */
- (void)startBMKLocationWithReg:(KBMKLocationBlock)bmkLocationBlock;


@end
