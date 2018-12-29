/**
 -  BKAdConfig.h
 -  BKSDK
 -  Created by HY on 16/12/5.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  广告类的配置文件
 -  1：定义了全局变量，决定是否加载广告
 -  2：定义广告标示符
 */

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>

//vpon的插屏广告配置
#define VPON_Config     @"http://iphone2.baby-kingdom.com/ad/vpon_config.php?"

//判断是否加载广告  1为加载，0为不加载
#define EXIST_ADVPON    1

//定义广告标示符
#define DEF_ADID  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]

@interface BKAdConfig : NSObject

@end






















