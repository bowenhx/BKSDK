/**
 -  BKVponAdRequest.h
 -  BKSDK
 -  Created by ligb on 2016/12/23.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  http://vpon-sdk.github.io/zh-cn/ios/banner/
 -  vpon广告，请求横幅广告，主要用于帖子详情中生成两个banner广告
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class BKVpadnAdView;

typedef void (^VpadnBannerView) (NSArray <BKVpadnAdView *> *banners);


@interface BKVponAdRequest : NSObject

/**
 请求横幅广告

 @param page  页面名称
 @param ctr   当前需要添加横幅广告的UIViewController
 @param block 返回请求到的BKVpadnAdView
 */
+ (void)vponConfigRequest:(NSString *)page controller:(UIViewController *)ctr backVponView:(VpadnBannerView)block;

@end
