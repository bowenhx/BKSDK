/**
 -  BKException.m
 -  BKSDK
 -  Created by HY on 16/11/21.
 -  Copyright © 2016年 HY. All rights reserved.
 */


#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/utsname.h>
#import "BKException.h"
#import "BKNetworking.h"
#import "BKDefineFile.h"
#import "BKSaveData.h"
#import "BKTool.h"

#define  ErrorLog @"errlog.plist"

@implementation BKException


#pragma mark - 使用AvoidCrash类，捕获到了崩溃，由于做了崩溃处理，这个时候APP不会闪退，直接上传app崩溃日志
+ (void)uploadExceptionByAvoidCrash:(NSString *)errorUrl token:(NSString *)token uuid:(NSString *)uuid crashInfo:(NSDictionary *)crashInfo {
    //获取设备类型
    NSString *deviceType = deviceVersion();
    //手机系统版本
    NSString* VersionCode = [[UIDevice currentDevice] systemVersion];
    __block NSString *netStr = @"wi－fi";
    [[BKNetworking share] checkNetworkBlock:^(NSString *netMeg, BOOL status) {
        netStr = netMeg;
    }];
    CGRect bounds = [UIScreen mainScreen].bounds;
    NSString *size = NSStringFromCGSize(bounds.size);
    
    NSString *text = [NSString stringWithFormat:@"Hardware Model : %@ \n Device Version : iOS %@ \n NetworkingType : %@ \n Devices Size : %@ \n Exception Type : %@ \n Version Code : %@ \n Class Name : %@ \n Crash Reason : %@ \n Thread Stack Info : %@",deviceType, VersionCode, netStr, size, crashInfo[@"errorName"], APP_VERSION, crashInfo[@"errorPlace"], crashInfo[@"errorReason"], crashInfo];
    
    NSDictionary *parameter = @{@"text":text,
                             @"machine":deviceType};
    
#ifdef DEBUG
    NSLog(@"打印debug 异常信息：%@",parameter);
#else
    if ([BKSaveData writeDicToFile:parameter fileName:ErrorLog]) {
        NSLog(@"AvoidCrash捕获错误日志成功： %@",parameter);
    }
    [self startExceptionHandler:errorUrl token:token uuid:uuid];
    
#endif
}


#pragma mark - 崩溃后APP闪退，错误日志暂时保存到本地，等下次进入APP上传崩溃日志
+ (void)startExceptionHandler:(NSString *)errorUrl token:(NSString *)token uuid:(NSString *)uuid {
    
    NSDictionary *tempDic = [BKSaveData readDicByFile:ErrorLog];
 
    //添加token，和uuid参数
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    [paramsDic setValue:token forKey:@"token"];
    [paramsDic setValue:uuid forKey:@"uuid"];
   
    if (tempDic.allKeys.count) {
        //上传错误日志信息
        [[BKNetworking share] post:errorUrl params:paramsDic precent:^(float precent) {
        } completion:^(BKNetworkModel *model, NSString *netErr) {
            if (!netErr) {
                NSLog(@"日志上传成功");
                [BKSaveData writeDicToFile:@{} fileName:ErrorLog];
            }
        }];
    }
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}


/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
NSString *deviceVersion() {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,3"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ( [deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"] ||[deviceString isEqualToString:@"iPad4,6"] ) return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    return deviceString;
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *crashPage = [BKTool getCrashViewMethod:arr];
    if (crashPage == nil) {
        crashPage = @"崩溃方法定位失败";
    }
    NSString *exReason = [exception reason];//crash 原因
    NSString *exType = [exception name];//异常类型
    //获取设备类型
    NSString *deviceType = deviceVersion();
    //手机系统版本
    NSString* VersionCode = [[UIDevice currentDevice] systemVersion];
    __block NSString *netStr = @"wi－fi";
    [[BKNetworking share] checkNetworkBlock:^(NSString *netMeg, BOOL status) {
        netStr = netMeg;
    }];
    CGRect bounds = [UIScreen mainScreen].bounds;
    NSString *size = NSStringFromCGSize(bounds.size);

    NSString *text = [NSString stringWithFormat:@"Hardware Model : %@ \n Device Version : iOS %@ \n NetworkingType : %@ \n Devices Size : %@ \n Exception Type : %@ \n  Version Code : %@ \n Error Place : %@ \n Crash Reason : %@ \n Thread Stack Info : %@ \n " ,deviceType ,VersionCode , netStr, size, exType, APP_VERSION, crashPage, exReason , arr];
    NSDictionary *info = @{
                           @"text":text,
                           @"machine":deviceType
                           };
    
#ifdef DEBUG
    NSLog(@"打印debug 异常信息：%@",info);
#else
    if ([BKSaveData writeDicToFile:info fileName:ErrorLog]) {
        NSLog(@"错误日志信息保持成功: %@",info);
    }
#endif
}

@end
