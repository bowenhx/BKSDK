/**
 -  VponAD_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：http://vpon-sdk.github.io/zh-cn/ios/
 -  内容摘要：VpadnBanner 只是一种UIView子类别，用来显示由使用者点击触发的小型HTML5广告。
 -  当前版本：4.2.0
 
 
 ##使用方法
 
 ##依赖框架:
        AdSupport,
        AssetsLibrary,
        AudioToolbox,
        AVFoundation,
        CoreFoundation,
        CoreGraphics,
        CoreLocation,
        CoreMedia,
        CoreMotion,
        CoreTelephony,
        EventKit,
        Foundation,
        MediaPlayer,
        MessageUI,
        MobileCoreServices,
        QuartzCore,
        Security,
        StoreKit,
        SystemConfiguration,
        UIKit
 
 

 ##代码
 
         //声明
         VpadnBanner*    vpadnAd; // 宣告使用VpadnBanner广告

 
         //初始化设定
         CGPoint origin = CGPointMake(0.0,screenHeight - CGSizeFromVpadnAdSize(VpadnAdSizeSmartBannerPortrait).height);
         vpadnAd = [[VpadnBanner alloc] initWithAdSize:VpadnAdSizeSmartBannerPortrait origin:origin];  // 初始化Banner物件
         vpadnAd.strBannerId = @"";   // 填入您的BannerId
         vpadnAd.delegate = self;       // 设定delegate接收protocol回传讯息
         vpadnAd.platform = @"TW";       // 台湾地区请填TW 大陆则填CN
         [vpadnAd setAdAutoRefresh:YES]; //如果为mediation则set NO
         [vpadnAd setRootViewController:self]; //请将window的rootViewController设定在此 以便广告顺利执行
         [self.view addSubview:[vpadnAd getVpadnAdView]]; // 将VpadnBanner的View加入此ViewController中
         [vpadnAd startGetAd:[self getTestIdentifiers]]; // 开始抓取Banner广告
     
 
     
        //代理
        #pragma mark VpadnAdDelegate method 接一般Banner广告就需要新增
        - (void)onVpadnAdReceived:(UIView *)bannerView{
            NSLog(@"广告抓取成功");
        }

        - (void)onVpadnAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
            NSLog(@"广告抓取失败");
        }

        - (void)onVpadnPresent:(UIView *)bannerView{
            NSLog(@"开启vpadn广告页面 %@",bannerView);
        }

        - (void)onVpadnDismiss:(UIView *)bannerView{
            NSLog(@"关闭vpadn广告页面 %@",bannerView);
        }

        - (void)onVpadnLeaveApplication:(UIView *)bannerView{
            NSLog(@"离开publisher application");
        }
 
 
 #################################################################################
 
 
 -  VponAD_Doc.h
 -  BKSDK
 -  Created by HY on 17/1/4.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：http://vpon-sdk.github.io/zh-cn/ios/
 -  内容摘要：vpon广告，新的版本无需引入依赖框架
 -  当前版本：4.6.3
 -  修改人员：吕鸿艳，2017/1/4修改
 -  修改记录：替换了新的VpadnSDK，该版本修改是在HKBK的V3.3.2版本，由于新增了需求“添加VPON广告位：帖子列表插入banner、首页列表插入banner、插屏广告”
 
 
    ## 使用方法同上,但不再需要引入任何依赖框架
 
 
 #################################################################################
 

 */


#import <Foundation/Foundation.h>

@protocol VponAD_Doc <NSObject>

@end
