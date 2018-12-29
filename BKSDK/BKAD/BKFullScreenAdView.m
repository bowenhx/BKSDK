/**
 -  BKFullScreenAdView.m
 -  BKSDK
 -  Created by HY on 16/12/05.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  全屏广告view
 */

#import "BKFullScreenAdView.h"
#import <WebKit/WebKit.h>
#import "UIView+MJExtension.h"
#import "BKDefineFile.h"

@interface BKFullScreenAdView () {
    BOOL            hiddenClose;    //顶部的关闭按钮
    int             pause;          //广告加载完成后显示停顿的时间（秒）
    WKWebView       *wkWebView;     //加载广告的wkwebview
}

@property(nonatomic, strong) NSString       *loadUrl; //加载广告的url

@end


@implementation BKFullScreenAdView

- (void)dealloc {
    wkWebView.navigationDelegate = nil;
}

#pragma mark - 初始化全屏广告
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //全屏广告右上角关闭按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"vi_ad_close"] forState:UIControlStateNormal];
        [btn setIsAccessibilityElement:YES];
        [btn setAccessibilityTraits:UIAccessibilityTraitButton];
        [btn setAccessibilityLabel:@"關閉廣告"];
        [btn addTarget:self action:@selector(closeAdBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.closeBtn = btn;
        [self insertSubview:_closeBtn atIndex:20];

        //配置信息
        WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
        config.mediaPlaybackRequiresUserAction = NO;
        config.allowsInlineMediaPlayback = YES;
        wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) configuration:config];
        wkWebView.navigationDelegate = self;
        wkWebView.UIDelegate = self;
        [wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [wkWebView setBackgroundColor:[UIColor blackColor]];
        [wkWebView setMultipleTouchEnabled:YES];
        [wkWebView setUserInteractionEnabled:YES];
        [wkWebView setContentMode:UIViewContentModeScaleAspectFill];
        [wkWebView setAutoresizesSubviews:YES];
        [wkWebView.scrollView setShowsHorizontalScrollIndicator:NO];
        [wkWebView.scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:wkWebView];
        [self insertSubview:wkWebView belowSubview:_closeBtn];
     
        
        NSDictionary *views = NSDictionaryOfVariableBindings(wkWebView, _closeBtn);
        //webView layout
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wkWebView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wkWebView]|" options:0 metrics:nil views:views]];
   
        //_closeBtn layout
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_closeBtn(30)]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_closeBtn(30)]" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_closeBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_closeBtn attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    }
    return self;
}


#pragma mark - webview加载全屏广告url
- (void)loadWebViewWithURL:(NSString *)url {
    _loadUrl = url;
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:[NSURL URLWithString:_loadUrl]
                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                             timeoutInterval:60];
    [wkWebView loadRequest:request];
}


#pragma mark - 关闭按钮事件
- (void)closeAdBtnClick {
    [self.delegate fullScreenViewClose];
}


#pragma mark - 关闭广告后，停止加载webView
- (void)stopLoadingWebView {
    NSString *script = @"var videos = document.querySelectorAll(\"video\"); for (var i = videos.length - 1; i >= 0; i--) { videos[i].pause(); };";
    [wkWebView evaluateJavaScript:script completionHandler:nil];
    [wkWebView stopLoading];
}


#pragma mark - 播放视频
- (void)playVideo {
    NSString *script = @"var videos = document.querySelectorAll(\"video\"); for (var i = videos.length - 1; i >= 0; i--) { videos[i].play(); };";

    [wkWebView evaluateJavaScript:script completionHandler:nil];
}


#pragma mark - WKNavigationDelegate

/*
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(fullScreenWebViewDidFinishLoad)]) {
        [self.delegate fullScreenWebViewDidFinishLoad];
    }
    [self playVideo];
}


/*
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
 
    NSString *url = [[navigationAction.request URL] absoluteString];
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated  ) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenAdViewliceWebURL:)]) {
            [self.delegate fullScreenAdViewliceWebURL:url];
        }
    }
    
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

//支持window.open
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {

    if (!navigationAction.targetFrame.isMainFrame) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    }
    return nil;

}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
     NSLog(@"wkwebview error : %@", error.localizedDescription);
}

@end
