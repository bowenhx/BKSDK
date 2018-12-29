/**
 -  BKPopupAdView.m
 -  BKSDK
 -  Created by HY on 16/12/07.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  弹窗广告view视图
 */

#import "BKPopupAdView.h"
#import <WebKit/WebKit.h>
#import "BKDefineFile.h"

@interface BKPopupAdView()<WKNavigationDelegate,WKUIDelegate>{
    WKWebView * wkWebView;
}

@property (nonatomic, strong) NSString *url;

@end

@implementation BKPopupAdView


#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame withURL:(NSString *)url isCloseBtn:(BOOL)isCloseBtn {
    self = [super initWithFrame:frame];
    if (self) {
        self.url = url;
        [self createControlWithIsCloseBtn:isCloseBtn];
    }
    return self;
}


#pragma mark - 创建弹窗广告的webview视图
- (void)createControlWithIsCloseBtn:(BOOL)isCloseBtn {
    //配置信息
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
    config.mediaPlaybackRequiresUserAction = NO;
    config.allowsInlineMediaPlayback = YES;
    wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) configuration:config];
    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    [wkWebView setBackgroundColor:[UIColor whiteColor]];
    [wkWebView setMultipleTouchEnabled:YES];
    [wkWebView setUserInteractionEnabled:YES];
    [wkWebView setContentMode:UIViewContentModeScaleToFill];
    [wkWebView setAutoresizesSubviews:YES];
    [wkWebView.scrollView setScrollEnabled:NO];
    //禁止下拉
    [wkWebView.scrollView setBounces:NO];
    [wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:wkWebView];
    
    //按钮：恢复大的形状
    _enlargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_enlargeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_enlargeBtn addTarget:self action:@selector(rePopopView:) forControlEvents:UIControlEventTouchUpInside];
    _enlargeBtn.hidden = YES;
    [self addSubview:_enlargeBtn];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"vi_ad_close"] forState:UIControlStateNormal];
    [_closeBtn setBackgroundColor:[UIColor clearColor]];
    [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closePopopView:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setHidden:isCloseBtn ? NO : YES];
    [self addSubview:_closeBtn];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(wkWebView, _enlargeBtn, _closeBtn);
    //webView layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[wkWebView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wkWebView]|" options:0 metrics:nil views:views]];
    
    //_enlargeBtn layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_enlargeBtn]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_enlargeBtn]|" options:0 metrics:nil views:views]];
    
    //_closeBtn layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_closeBtn(30)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_closeBtn(30)]" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_closeBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_closeBtn attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    
    //=============== webview load url ===================
    if ([_url rangeOfString:@"?"].location == NSNotFound) {
        
        _url = [_url stringByAppendingString:@"?from=babykingdom"];
    }else{
        _url = [_url stringByAppendingString:@"&from=babykingdom"];
    }
    
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:[NSURL URLWithString:_url]
                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                             timeoutInterval:60];
    
    [wkWebView loadRequest:request];
  
}


#pragma mark - 关闭按钮事件
- (IBAction)closePopopView:(id)sender {

    [self stopVideo];
    [wkWebView stopLoading];
  
    if ([_deleage respondsToSelector:@selector(popupViewRremoveFromSuperview:)]) {
        [_deleage popupViewRremoveFromSuperview:self];
    }
}


//停止加载视频
- (void)stopVideo {
    [wkWebView evaluateJavaScript:@"expanddiv();" completionHandler:nil];
}


//重新加载
- (void)webViewLoadURL:(NSString *)url isCloseBtn:(BOOL)isCloseBtn {
    
    [wkWebView setFrame:self.frame];
    [wkWebView stopLoading];
    
    [_closeBtn setHidden:isCloseBtn ? NO : YES];
    
    _url = url;
    //=============== webview load url ===================
    if ([_url rangeOfString:@"?"].location == NSNotFound) {
        
        _url = [_url stringByAppendingString:@"?from=babykingdom"];
    }else{
        _url = [_url stringByAppendingString:@"&from=babykingdom"];
    }
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:[NSURL URLWithString:_url]
                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                             timeoutInterval:60];
    
    [wkWebView loadRequest:request];
   
    NSLog(@"popup load");
    [self setNeedsDisplay];
}


#pragma mark - 恢复view初始大小（大的状态）
- (void)rePopopView:(UIButton *)button {
    [wkWebView evaluateJavaScript:@"expanddiv();" completionHandler:nil];
    if (self.deleage && [_deleage respondsToSelector:@selector(popupViewEnlargeBtnClicked:)]) {
        [_deleage popupViewEnlargeBtnClicked:self];
    }
}


#pragma - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] absoluteString];
    if ([url rangeOfString:@"from=babykingdom"].location != NSNotFound) {
        return YES;
    }
    if (self.deleage && [_deleage respondsToSelector:@selector(popupViewCliceWebURL:)]) {
        
        BOOL rt = [_deleage popupViewCliceWebURL:url];
        return rt;
    }
    
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self layoutIfNeeded];
    if (self.deleage && [_deleage respondsToSelector:@selector(popupViewWebViewFinishLoad:)]) {
        NSLog(@"popoup webViewDidFinishLoad");
        [_deleage popupViewWebViewFinishLoad:self];
    }
}


#pragma mark - WKNavigationDelegate
/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
    [self layoutIfNeeded];
    if (self.deleage && [_deleage respondsToSelector:@selector(popupViewWebViewFinishLoad:)]) {
        NSLog(@"popoup webViewDidFinishLoad");
        [_deleage popupViewWebViewFinishLoad:self];
    }
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

    if (navigationAction.navigationType == WKNavigationTypeLinkActivated ) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        if (self.deleage && [_deleage respondsToSelector:@selector(popupViewCliceWebURL:)]) {
            [_deleage popupViewCliceWebURL:url];
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


@end
