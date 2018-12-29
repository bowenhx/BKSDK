/**
 -  BKPopupAdView.h
 -  BKSDK
 -  Created by HY on 16/12/07.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  弹窗广告view视图
 */

#import <UIKit/UIKit.h>
@class BKPopupAdView;

@protocol BKPopupAdViewDelegate<NSObject>

@optional


/**
 *  移除一个弹框广告
 *
 *  @param popupView 弹窗view
 */
- (void)popupViewRremoveFromSuperview:(BKPopupAdView *)popupView;


/**
 *  点击放大广告view对应的点击事件
 *
 *  @param popupView 当前的弹窗view
 */
- (void)popupViewEnlargeBtnClicked:(BKPopupAdView *)popupView;


/**
 *  点击弹窗广告，打开的链接地址
 *
 *  @param url 链接地址
 *
 *  @return YES让浏览器自己返回； NO 处理链接地址，可以弹出到其他的ViewController
 */
- (BOOL)popupViewCliceWebURL:(NSString *)url;


/**
 *  显示弹窗广告的webview加载完成
 *
 *  @param popubView 当前的弹框view
 */
- (void)popupViewWebViewFinishLoad:(BKPopupAdView *)popubView;


@end


@interface BKPopupAdView : UIView<UIWebViewDelegate>

@property (assign, nonatomic) id<BKPopupAdViewDelegate> deleage;
@property (nonatomic, strong) UIButton *closeBtn; //修改 关闭按钮
@property (nonatomic, strong) UIButton *enlargeBtn; //作用于view小的时候，恢复变大


/**
 *  初始化弹窗广告view
 *
 *  @param frame        弹窗view位置大小
 *  @param url          加载弹窗广告的链接地址
 *  @param isCloseBtn   是否显示关闭弹窗的按钮，YES：显示  NO:不显示
 *
 *  @return YES让浏览器自己返回； NO 处理链接地址，可以弹出到其他的ViewController
 */
- (id)initWithFrame:(CGRect)frame withURL:(NSString *)url isCloseBtn:(BOOL)isCloseBtn;


/**
 *  如果弹窗广告存在，重新加载
 *
 *  @param url          加载弹窗广告的链接地址
 *  @param isCloseBtn   是否显示关闭弹窗的按钮，YES：显示  NO:不显示
 */
- (void)webViewLoadURL:(NSString *)url isCloseBtn:(BOOL)isCloseBtn;


/**
 *  停止视频播放
 */
- (void)stopVideo;


@end
