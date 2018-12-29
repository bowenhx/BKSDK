/**
 -  BKVpadnAdView.h
 -  BKSDK
 -  Created by ligb on 2016/12/23.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  http://vpon-sdk.github.io/zh-cn/ios/
 -  vpon广告，初始化横幅广告，插屏广告，原生广告
 */

#import <UIKit/UIKit.h>
#import <VpadnSDKAdKit/VpadnSDKAdKit.h>
#import <AdSupport/ASIdentifierManager.h>

//刷新vpon 在帖子列表正常显示的通知
static NSString *VponRefreshNotification = @"vponRefreshNotification";


@protocol BKVpadnAdViewDelegate <NSObject>

/**
 全屏广告代理方法

 @param show 布尔值，yes代表可以显示全屏广告，no代表不显示
 */
- (void)mShowVponInterstitialAd:(BOOL)show;

@end


@interface BKVpadnAdView : UIView

/** delegate */
@property (nonatomic, assign) id <BKVpadnAdViewDelegate> vponDelegate;

//横幅广告
@property (nonatomic, strong) VpadnBanner *bannerAd;

//插屏广告
@property (nonatomic, strong) VpadnInterstitial *interstitialAd;

//原生广告
@property (nonatomic, strong) VpadnNativeAd *nativeAd;

@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, assign) CGFloat vHeight;//高度
@property (nonatomic, assign) NSInteger space;//广告间隔数

//vpadn native ad view <native 广告,元素包括adIcon和adTitle,用在帖子详情页面的浮动广告位上>
@property (nonatomic , strong) UIView *floatView;

/**
 vpadn banner ad view <banner 广告>
 @param bannerId key in your natvie ad id
 @param ctr      youer controller
 @return vpadn banner ad
 */
- (instancetype)initWithBannerId:(NSString *)bannerId controller:(UIViewController *)ctr;


/**
 interstitial ad view <插屏广告>
 @param bannerId key in your natvie ad id
 @return interstitial ad
 */
- (instancetype)initWithInterstitialId:(NSString *)bannerId;


/**
 vpadn native ad view <native 广告>
 @param bannerId key in your natvie ad id
 @return vpadn native ad
 */
- (instancetype)initWithVpadnNativeBannerId:(NSString *)bannerId;

@end
