//
//  HLSDKAllLcationManager.m
//  HLLocationSDKDemo
//
//  Created by lhl on 15/5/6.
//  Copyright (c) 2015年 LHL. All rights reserved.
//



// com.lhl.yongche
#define BaiduMapApk @"GD6nyxquAGUVMjRQTnyx3Wf5"
#define GaodeMapApk @"dbedafe5dc34aad898c0fa80482f7ad8"
#define TencentMapApk @"WMBBZ-Q23AJ-OJ5FE-F6N5D-QJDN2-36B7B"

#import "HLAllSDKLcationManager.h"

@interface HLAllSDKLcationManager()<BMKGeneralDelegate, BMKLocationServiceDelegate, MAMapViewDelegate, CLLocationManagerDelegate>
{
    
}

@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;
@property (nonatomic, readwrite, strong) MAMapView *amapView;
//@property (nonatomic, readwrite, strong) QMapView *qmapView;
@property (nonatomic, readwrite, strong) BMKLocationService *locService;


@property (nonatomic, readwrite, copy) KSystemLocationBlock kSystemLocationBlock;
//@property (nonatomic, readwrite, copy) KQMapLocationBlock   kQMapLocationBlock;
@property (nonatomic, readwrite, copy) KMAMapLocationBlock  kMAMapLocationBlock;
@property (nonatomic, readwrite, copy) KBMKLocationBlock    kBMKLocationBlock;

@end

@implementation HLAllSDKLcationManager

+ (id)shareInstance{
    static id helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HLAllSDKLcationManager alloc]  init];
//        [helper installMapSDK];
    });
    return helper;
}


+ (void)installMapSDK{
//    [QMapServices sharedServices].apiKey = TencentMapApk;
    
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    [manager start:BaiduMapApk generalDelegate:nil];
    [MAMapServices sharedServices].apiKey = GaodeMapApk;
}

///**
// *返回网络错误
// *@param iError 错误号
// */
//- (void)onGetNetworkState:(int)iError{
//    NSLog(@"百度地图授权网络错误");
//}
//
///**
// *返回授权验证错误
// *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
// */
//- (void)onGetPermissionState:(int)iError{
//    NSLog(@"百度地图授权网络失败");
//}

#pragma mark - 苹果
/**
 *  苹果系统自带地图定位
 */
- (void)startSystemLocationWithRes:(KSystemLocationBlock)systemLocationBlock{
    self.kSystemLocationBlock = systemLocationBlock;
    
    if(!self.locationManager){
        self.locationManager =[[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//        self.locationManager.distanceFilter=10;
        if ([UIDevice currentDevice].systemVersion.floatValue >=8) {
            [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
    }
    self.locationManager.delegate=self;
    [self.locationManager startUpdatingLocation];//开启定位
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currLocation=[locations lastObject];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    
    self.kSystemLocationBlock(currLocation, nil);
}
/**
 *定位失败，回调此方法
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];

    self.kSystemLocationBlock(nil, error);
}


#pragma mark - 百度
/**
 *  百度地图定位
 */
- (void)startBMKLocationWithReg:(KBMKLocationBlock)bmkLocationBlock{
    self.kBMKLocationBlock = bmkLocationBlock;
    
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    if (!self.locService) {
        self.locService = [[BMKLocationService alloc]init];
        self.locService.delegate = self;
    }
    //启动LocationService
    [self.locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.locService stopUserLocationService];
    
    self.kBMKLocationBlock(userLocation, nil);
}


/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    [self.locService stopUserLocationService];
    
    self.kBMKLocationBlock(nil, error);
}

#pragma mark - 高德
/**
 *  高德地图定位
 */
- (void)startGaodeLocationWithReg:(KMAMapLocationBlock)maMapLocationBlock{
    self.kMAMapLocationBlock = maMapLocationBlock;
    
    if (!self.amapView) {
         self.amapView = [[MAMapView alloc] init];
    }
    self.amapView.delegate = self;
    self.amapView.showsUserLocation = YES;
}


// 回调方法和其他地图方法重合，最下面合并成一个方法




#pragma mark - 腾讯

///**
// *  腾讯地图定位
// */
//- (void)startQmapLocationWithReg:(KQMapLocationBlock)qMapLocationBlock{
//    self.kQMapLocationBlock = qMapLocationBlock;
//    
//    if (!self.qmapView) {
//        self.qmapView = [[QMapView alloc] init];
//    }
//    self.qmapView.delegate = self;
//    [self.qmapView setShowsUserLocation:YES];
//}
//
//- (void)mapViewWillStartLocatingUser:(QMapView *)mapView
//{
//    //获取开始定位的状态
//}
//
//- (void)mapViewDidStopLocatingUser:(QMapView *)mapView
//{
//    //获取停止定位的状态
//}

// 回调方法和其他地图方法重合，最下面合并成一个方法


/*!
 @brief 位置或者设备方向更新后，会调用此函数
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 @param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
-(void)mapView:(id)mapView didUpdateUserLocation:(id)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 高德
    if ([mapView isKindOfClass:[MAMapView class]]) {
        MAUserLocation *ulocation = userLocation;
        
        [self.amapView setShowsUserLocation:NO];

        
        if(updatingLocation)
        {
            //取出当前位置的坐标
//            NSLog(@"latitude : %f,longitude: %f",ulocation.coordinate.latitude,ulocation.coordinate.longitude);
            self.kMAMapLocationBlock(ulocation, nil);
        }
    }
    
//    // 腾讯
//    else if ([mapView isKindOfClass:[QMapView class]]){
//        QUserLocation *ulocation = userLocation;
//        
//        [self.qmapView setShowsUserLocation:NO];
//        
//        if(updatingLocation)
//        {
//            //取出当前位置的坐标
////            NSLog(@"latitude : %f,longitude: %f",ulocation.coordinate.latitude,ulocation.coordinate.longitude);
//            self.kQMapLocationBlock(ulocation, nil);
//        }
//    }
}

/*!
 @brief 定位失败后，会调用此函数
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败");
    // 高德
    if ([mapView isKindOfClass:[MAMapView class]]) {
        self.kMAMapLocationBlock(nil, error);
    }
    
    
//    // 腾讯
//    else if ([mapView isKindOfClass:[QMapView class]]){
//        self.kQMapLocationBlock(nil, error);
//    }
}




@end
