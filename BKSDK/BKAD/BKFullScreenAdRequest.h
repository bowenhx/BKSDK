/**
 -  BKFullScreenAdRequest.h
 -  BKSDK
 -  Created by HY on 16/12/5.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  全屏广告请求类
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BKFullScreenAdView.h"
#import "BKAdConfig.h"
#import "BKVpadnAdView.h"

/** 点击全屏广告block */
typedef void (^TouchFullScreenAdBlock) (NSString *url);

@interface BKFullScreenAdRequest : NSObject <BKFullScreenAdViewDelegate, BKVpadnAdViewDelegate>

@property (nonatomic, copy) TouchFullScreenAdBlock touchFullScreenAdBlock;
@property (nonatomic, strong) UIWindow *fullScreenWindow;//存放全屏广告的window(必须)
@property (nonatomic, strong) NSString *requestURL;//请求地址(必须)
@property (nonatomic, strong) NSString *pageName;//页面名称(必须)
@property (nonatomic, strong) NSString *uId;//用户ID(可选)
@property (nonatomic, strong) NSString *fId;//板块ID(可选)


/**
 *  单例
 *  @return BKFullScreenAdRequest
 */
+ (BKFullScreenAdRequest *)shared;


/**
 *  请求一个全屏广告
 *
 *  @param touchScreenAd   点击全屏广告的block，包含一个点击链接
 */
- (void)requestFullScreenAd:(TouchFullScreenAdBlock)touchScreenAd;


/**
 *  关闭全屏广告
 */
- (void)removeFullScreenAd;


@end
