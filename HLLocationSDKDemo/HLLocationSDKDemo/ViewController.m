//
//  ViewController.m
//  HLLocationSDKDemo
//
//  Created by lhl on 15/5/6.
//  Copyright (c) 2015年 LHL. All rights reserved.
//

#import "ViewController.h"
#import "HLAllSDKLcationManager.h"
#import "HLGoTimer.h"
#import "FMDBHelpers.h"

#define DBPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/LocationDB.db"]
#define DBTableName @"LocationDB"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *locationResultTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self opreationDB];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startLocationService) userInfo:nil repeats:YES];
    [timer fire];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)startLocationService{
    NSNumber *count = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocationCount"];
    [[NSUserDefaults standardUserDefaults] setObject:@(count.integerValue+1) forKey:@"LocationCount"];

    /**
     *  系统定位
     */
    NSString *systemDate = [HLGoTimer startDateString];
    NSMutableString *resultStr = [NSMutableString string];
    [resultStr appendFormat:@"%@",[NSString stringWithFormat:@"当前第%@次定位",@(count.integerValue+1)]];

    [[HLAllSDKLcationManager shareInstance] startSystemLocationWithRes:^(CLLocation *loction, NSError *error) {
        if (error) {
            [resultStr appendFormat:@"系统定位耗时：%@s\n", @([HLGoTimer endDateString:systemDate])];
            [resultStr appendFormat:@"系统定位失败error = %@\n\n",error];
            
        } else {
            [resultStr appendFormat:@"系统定位耗时：%@s\n", @([HLGoTimer endDateString:systemDate])];
            [resultStr appendFormat:@"系统定位成功 = %@\n\n",loction];
        }
        self.locationResultTextView.text = resultStr;

        NSString *latlng = [NSString stringWithFormat:@"%@,%@", @(loction.coordinate.latitude), @(loction.coordinate.longitude)];
        NSString *duration = [NSString stringWithFormat:@"%@",@([HLGoTimer endDateString:systemDate])];
        
        FMDatabase *locationDB = [FMDatabase databaseWithPath:DBPATH];
        [locationDB open];

        NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
        [locationDic setObject:@(count.integerValue+1) forKey:@"第几次定位"];
        [locationDic setObject:@"系统" forKey:@"地图"];
        [locationDic setObject:latlng forKey:@"经纬度"];
        [locationDic setObject:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"当前时间"];
        [locationDic setObject:[NSString stringWithFormat:@"%@", duration] forKey:@"定位耗时"];
        [locationDic setObject:error?error:@"" forKey:@"定位错误"];
        
        [locationDB insertInto:DBTableName row:locationDic error:nil];
        [locationDB close];
    }];
    
    
    /**
     *  高德定位
     */
    
    NSString *gaodeDate = [HLGoTimer startDateString];
    [[HLAllSDKLcationManager shareInstance] startGaodeLocationWithReg:^(MAUserLocation *loction, NSError *error){

        if (error) {
            [resultStr appendFormat:@"高德定位耗时：%@s\n", @([HLGoTimer endDateString:gaodeDate])];
            [resultStr appendFormat:@"高德定位失败error = %@\n\n",error];
            
        } else {
            [resultStr appendFormat:@"高德定位耗时：%@s\n", @([HLGoTimer endDateString:gaodeDate])];
            [resultStr appendFormat:@"高德定位成功 = %@\n\n",loction.location];
        }
        self.locationResultTextView.text = resultStr;

        NSString *latlng = [NSString stringWithFormat:@"%@,%@", @(loction.location.coordinate.latitude), @(loction.location.coordinate.longitude)];
        NSString *duration = [NSString stringWithFormat:@"%@",@([HLGoTimer endDateString:gaodeDate])];
        
        FMDatabase *locationDB = [FMDatabase databaseWithPath:DBPATH];
        [locationDB open];

        NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
         [locationDic setObject:@(count.integerValue+1) forKey:@"第几次定位"];
        [locationDic setObject:@"高德" forKey:@"地图"];
        [locationDic setObject:latlng forKey:@"经纬度"];
        [locationDic setObject:[NSString stringWithFormat:@"%@",[NSDate date]] forKey: @"当前时间"];
        [locationDic setObject:[NSString stringWithFormat:@"%@", duration] forKey:@"定位耗时"];
        [locationDic setObject:error?error:@"" forKey:@"定位错误"];
        
        [locationDB insertInto:DBTableName row:locationDic error:nil];
        
        [locationDB close];
    }];
    
    
    
    /**
     *  腾讯定位
     */
    
    NSString *QmapDate = [HLGoTimer startDateString];
    [[HLAllSDKLcationManager shareInstance] startQmapLocationWithReg:^(QUserLocation *loction, NSError *error) {

        if (error) {
            [resultStr appendFormat:@"腾讯定位耗时：%@s\n", @([HLGoTimer endDateString:QmapDate])];

            [resultStr appendFormat:@"腾讯定位失败error = %@\n\n",error];
            
        } else {
            [resultStr appendFormat:@"腾讯定位耗时：%@s\n", @([HLGoTimer endDateString:QmapDate])];

            [resultStr appendFormat:@"腾讯定位成功 = %@\n\n",loction.location];
        }
        self.locationResultTextView.text = resultStr;

        NSString *latlng = [NSString stringWithFormat:@"%@,%@", @(loction.location.coordinate.latitude), @(loction.location.coordinate.longitude)];
        NSString *duration = [NSString stringWithFormat:@"%@",@([HLGoTimer endDateString:QmapDate])];
        
        FMDatabase *locationDB = [FMDatabase databaseWithPath:DBPATH];
        [locationDB open];
        
        NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
         [locationDic setObject:@(count.integerValue+1) forKey:@"第几次定位"];
        [locationDic setObject:@"腾讯" forKey:@"地图"];
        [locationDic setObject:latlng forKey:@"经纬度"];
        [locationDic setObject:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"当前时间"];
        [locationDic setObject:[NSString stringWithFormat:@"%@", duration] forKey:@"定位耗时"];
        [locationDic setObject:error?error:@"" forKey:@"定位错误"];
        
        [locationDB insertInto:DBTableName row:locationDic error:nil];
        
        [locationDB close];
    }];
    
    
    
    /**
     *  百度定位
     */
    
    NSString *bmkDate = [HLGoTimer startDateString];
    [[HLAllSDKLcationManager shareInstance] startBMKLocationWithReg:^(BMKUserLocation *loction, NSError *error){

        if (error) {
            [resultStr appendFormat:@"百度定位耗时：%@s\n", @([HLGoTimer endDateString:bmkDate])];

            [resultStr appendFormat:@"百度定位失败error = %@\n\n",error];
            
        } else {
            [resultStr appendFormat:@"百度定位耗时：%@s\n", @([HLGoTimer endDateString:bmkDate])];

            [resultStr appendFormat:@"百度定位成功 = %@\n\n",loction.location];
        }
        
        self.locationResultTextView.text = resultStr;

        NSString *latlng = [NSString stringWithFormat:@"%@,%@", @(loction.location.coordinate.latitude), @(loction.location.coordinate.longitude)];
        NSString *duration = [NSString stringWithFormat:@"%@",@([HLGoTimer endDateString:bmkDate])];
        
        FMDatabase *locationDB = [FMDatabase databaseWithPath:DBPATH];
        [locationDB open];

        NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
        [locationDic setObject:@(count.integerValue+1) forKey:@"第几次定位"];
        [locationDic setObject:@"百度" forKey:@"地图"];
        [locationDic setObject:latlng forKey:@"经纬度"];
        [locationDic setObject:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"当前时间"];
        [locationDic setObject:[NSString stringWithFormat:@"%@", duration] forKey:@"定位耗时"];
        [locationDic setObject:error?error:@"" forKey:@"定位错误"];
        
        [locationDB insertInto:DBTableName row:locationDic error:nil];
        
        [locationDB close];
    }];
}

- (void)opreationDB{
    if(![[NSFileManager defaultManager] fileExistsAtPath:DBPATH]){
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"LocationCount"];
        FMDatabase *locationDB = [FMDatabase databaseWithPath:DBPATH];
        [locationDB open];
        NSError *error = nil;
        [locationDB createTableWithName:DBTableName columns:@[@"第几次定位",@"地图", @"经纬度", @"当前时间", @"定位耗时", @"定位错误"] constraints:nil error:&error];
        NSLog(@"error %@", error);
        [locationDB close];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
