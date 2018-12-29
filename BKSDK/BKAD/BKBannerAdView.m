/**
 -  BKBannerAdView.m
 -  BKSDK
 -  Created by HY on 16/12/5.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  banner广告的View视图
 */

#import "BKBannerAdView.h"
#import "BKDefineFile.h"
#import "UIImageView+WebCache.h"
#import <WebKit/WebKit.h>

@interface BKBannerAdView()<WKNavigationDelegate,WKUIDelegate>


@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, readwrite) NSString *imageURL;    //图片地址
@property (nonatomic, readwrite) NSString *htmlURL;     //html地址
@property (nonatomic, readwrite) NSString *htmlContent; //html代码

@end

@implementation BKBannerAdView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self bannerAdStartLoad];
}


#pragma mark - 加载banner广告内容
- (void)bannerAdStartLoad {
    //判断广告类别
    switch (_bannerType) {
        //图片广告
        case BKBannerViewTypeImage: {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"bkad_loading"]];
            break;
        }
        //html链接广告
        case BKBannerViewTypeHtml: {
            if ([_htmlURL rangeOfString:@"?"].location == NSNotFound) {
                
                _htmlURL = [_htmlURL stringByAppendingString:@"?from=babykingdom"];
            } else {
                _htmlURL = [_htmlURL stringByAppendingString:@"&from=babykingdom"];
            }
            NSURLRequest *request = [NSURLRequest
                                     requestWithURL:[NSURL URLWithString:_htmlURL]
                                     cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                     timeoutInterval:60];
            [_wkWebView loadRequest:request];
            break;
        }
        //html代码广告
        case BKBannerViewTypeHtmlCode: {
            [_wkWebView loadHTMLString:_htmlContent baseURL:nil];
            break;
        }
        default:
            break;
    }
}


#pragma mark - 初始化一个图片广告
- (id)initWithImageURL:(NSString *)imageURL withHeight:(CGFloat)height clickBlock:(ClickBannerView)clickBlock {
    self = [super init];
    _imageView = [[UIImageView alloc] init];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_imageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickImaage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, btn);
    NSDictionary *metrics = @{@"height": [NSNumber numberWithFloat:height]};
    
    //imageView layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:metrics views:views]];
    
    //btn layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|" options:0 metrics:metrics views:views]];
    
    _imageURL = imageURL;
    _bannerType = BKBannerViewTypeImage;
    _vHeight = height;
    [self settingTouchBannerBlock:^(NSString *url) {
        clickBlock(url);
    }];
    
    return self;
}


#pragma mark - 初始化一个html链接广告
- (id)initWithHtmlURL:(NSString *)htmlURL withHeight:(CGFloat)height clickBlock:(ClickBannerView)clickBlock {
    self = [super init];
    
    //配置信息
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc] init];
    config.mediaPlaybackRequiresUserAction = NO;//开启自动播放
    config.allowsInlineMediaPlayback = YES;         //内联播放
    config.mediaPlaybackAllowsAirPlay = YES;
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64) configuration:config];
    _wkWebView.backgroundColor = [UIColor clearColor];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    [_wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];//自动布局必须
    [_wkWebView.scrollView setScrollEnabled:NO];//禁止滚动
    [self addSubview:_wkWebView];
 
    NSDictionary *metrics = @{@"height": [NSNumber numberWithFloat:height]};
    NSDictionary *views = NSDictionaryOfVariableBindings(_wkWebView);
    //webview layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_wkWebView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_wkWebView]|" options:0 metrics:metrics views:views]];
    
    _htmlURL = htmlURL;
    _bannerType = BKBannerViewTypeHtml;
    _vHeight = height;
    [self settingTouchBannerBlock:^(NSString *url) {
        clickBlock(url);
    }];
    return self;
}


#pragma mark - 初始化一个html内容广告
- (id)initWithHtmlContent:(NSString *)htmlConten withHeight:(CGFloat)height clickBlock:(ClickBannerView)clickBlock {
    self = [super init];
    
    _wkWebView = [[WKWebView alloc] init];
    _wkWebView.navigationDelegate = self;
    [_wkWebView setTranslatesAutoresizingMaskIntoConstraints:NO];//自动布局必须
    [_wkWebView.scrollView setScrollEnabled:NO];//禁止滚动
    [self addSubview:_wkWebView];
    
    NSDictionary *metrics = @{@"height": [NSNumber numberWithFloat:height]};
    NSDictionary *views = NSDictionaryOfVariableBindings(_wkWebView);
    //webview layout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_wkWebView]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_wkWebView]|" options:0 metrics:metrics views:views]];
    
    _htmlContent = htmlConten;
    _bannerType = BKBannerViewTypeHtmlCode;
    _vHeight = height;
    [self settingTouchBannerBlock:^(NSString *url) {
        clickBlock(url);
    }];
    
    return self;
}


#pragma mark - block 传值
-(void)settingTouchBannerBlock:(ClickBannerView)block{
    _clickBannerView = block;
}


#pragma mark - 点击图片广告
- (void)clickImaage {
    _clickBannerView(_clickeURL);
}


#pragma mark - 播放视频
- (void)playVideo {
    NSString *playerJS = @"var videos = document.querySelectorAll(\"video\"); for (var i = videos.length - 1; i >= 0; i--) { var ivideo = videos[i]; ivideo.setAttribute(\"webkit-playsinline\",\"\"); ivideo.play(); };";
    [_wkWebView evaluateJavaScript:playerJS completionHandler:nil];
}


#pragma mark - 停止播放视频
- (void)stopVideo{
    NSString *script = @"var videos = document.querySelectorAll(\"video\"); for (var i = videos.length - 1; i >= 0; i--) { videos[i].pause(); };";
    [_wkWebView evaluateJavaScript:script completionHandler:nil];
}

#pragma mark - WKNavigationDelegate ios8以上

/*
 *  当内容开始加载完成时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    NSLog(@"%s", __FUNCTION__);
    [self playVideo];
}


/*
 *  在发送请求之前，决定是否跳转到该请求
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  
    NSString *url = [[navigationAction.request URL] absoluteString];
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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

