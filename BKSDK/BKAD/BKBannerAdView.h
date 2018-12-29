/**
 -  BKBannerAdView.h
 -  BKSDK
 -  Created by HY on 16/12/5.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  banner广告的View视图
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BKBannerAdView;

typedef enum{
    BKBannerViewTypeImage       = 0,    //图片广告
    BKBannerViewTypeHtml        = 1,    //html链接广告
    BKBannerViewTypeHtmlCode    = 2     //html代码广告
}BKBannerViewType;


/** 点击banner广告block */
typedef void (^ClickBannerView)(NSString *url);


@interface BKBannerAdView : UIView <UIWebViewDelegate>

@property(nonatomic,copy)ClickBannerView clickBannerView;           //block
@property (nonatomic, assign)   BKBannerViewType bannerType;        //广告类型：图片，html链接，html代码
@property (nonatomic, assign)   CGFloat vHeight;                    //高度
@property (nonatomic, readonly) NSString *imageURL;                 //图片链接
@property (nonatomic, readonly) NSString *htmlURL;                  //HTML链接
@property (nonatomic, readonly) NSString *htmlContent;              //html代码
@property (nonatomic, strong)   NSString *clickeURL;                //点击的链接地址
@property (nonatomic, assign)   NSInteger number;                   //第几条广告
@property (nonatomic, assign) NSInteger space;//广告间隔数


/**
 *  初始化一个图片广告
 *
 *  @param  imageURL 广告图片地址
 *  @param  height   广告View的高度
 *  @param  clickBlock   处理点击banner广告事件的block
 *
 *  @return 广告View
 */
- (id)initWithImageURL:(NSString *)imageURL withHeight:(CGFloat)height clickBlock:(ClickBannerView)clickBlock;;


/**
 *  初始化一个HTML链接的广告
 *
 *  @param  htmlURL html链接地址的广告
 *  @param  height  广告View的高度
 *  @param  clickBlock   处理点击banner广告事件的block
 *
 *  @return 广告View
 */
- (id)initWithHtmlURL:(NSString *)htmlURL withHeight:(CGFloat)height clickBlock:(ClickBannerView)clickBlock;;


/**
 *  初始化一个HTML内容的广告
 *
 *  @param  htmlConten html内容的广告
 *  @param  height     广告View的高度
 *  @param  clickBlock   处理点击banner广告事件的block
 *
 *  @return 广告View
 */
- (id)initWithHtmlContent:(NSString *)htmlConten withHeight:(CGFloat)height clickBlock:(ClickBannerView)clickBlock;;


/**
 *  播放视频
 */
- (void)playVideo;


/**
 *  停止视频播放
 */
- (void)stopVideo;


@end
