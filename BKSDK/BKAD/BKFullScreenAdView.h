/**
 -  BKFullScreenAdView.h
 -  BKSDK
 -  Created by HY on 16/12/05.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  全屏广告view
 */


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class BKFullScreenAdView;


//-----------------------------Delegate-----------------------------
@protocol BKFullScreenAdViewDelegate<NSObject>

@required

/**
 *  关闭广告
 */
- (void)fullScreenViewClose;

@optional
/**
 *  点击全屏广告链接
 *
 *  @param url 点击的连接地址
 */
- (BOOL)fullScreenAdViewliceWebURL:(NSString *)url;

/**
 *  webview加载完成
 */
- (void)fullScreenWebViewDidFinishLoad;

@end;
//-----------------------------Delegate-end----------------------------


@interface BKFullScreenAdView : UIView<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (assign, nonatomic)id<BKFullScreenAdViewDelegate> delegate;

@property (nonatomic, strong) UIButton      *closeBtn;//关闭按钮


/**
 *  关闭广告后，停止加载webView
 */
- (void)stopLoadingWebView;


/**
 *  webview加载全屏广告url
 *
 *  @param url 广告URL
 */
- (void)loadWebViewWithURL:(NSString *)url;


@end
