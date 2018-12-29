/**
 -  BKBannerAdRequest.h
 -  BKSDK
 -  Created by HY on 16/12/05.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  banner广告的请求类
 */

#import <Foundation/Foundation.h>
#import "BKBannerAdView.h"

/** 获取请求到的banner数据列表 */
typedef void (^GetBannerListBlock) (NSArray *bannerList);

/** 点击banner广告，包含banner的链接 */
typedef void (^TouchBannerBlock) (NSString *url);


@interface BKBannerAdRequest : NSObject{
    
}

@property (nonatomic, copy) GetBannerListBlock getBannerListBlock;
@property (nonatomic, copy) TouchBannerBlock touchBannerBlock;
@property (nonatomic, strong) NSString *pageName;   //页面名称(必须)
@property (nonatomic, strong) NSString *requestURL; //请求地址(必须)
@property (nonatomic, strong) NSString *uId;        //用户ID(可选)
@property (nonatomic, strong) NSString *fId;        //板块ID(可选)
@property (nonatomic, strong) NSString *adCacheDirectory;//缓存目录(可选)
@property (nonatomic, strong) UIViewController *controller; //vpon广告需要，当前显示广告的页面

/**
 *  请求banner广告数据,block中可以得到请求到的数据列表，还可以直接处理点击事件
 *
 *  @param  getlistBlock  获取到请求返回的banner列表
 *  @param  touchBanner   处理点击banner的事件
 *
 */
- (void)startRequestBannerAdsForList:(GetBannerListBlock)getlistBlock touchBanner:(TouchBannerBlock)touchBanner;

@end
