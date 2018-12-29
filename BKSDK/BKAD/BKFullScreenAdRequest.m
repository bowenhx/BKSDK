/**
 -  BKFullScreenAdRequest.m
 -  BKSDK
 -  Created by HY on 16/12/5.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  全屏广告请求类
 */

#import "BKFullScreenAdRequest.h"
#import "BKDefineFile.h"
#import "BKNetworking.h"
#import "BKTool.h"
#import "UIView+Util.h"

#define BKAD_ANIMATION_DURATION 0.3  //全屏广告显示的动画时间

@interface BKFullScreenAdRequest() {
    int    pause; //停顿时间，停顿*后再显示全屏广告
}

@property (nonatomic, assign) BOOL           isFullScreenShow; //yes代表当前有全屏广告显示，no代表没有
@property (nonatomic, strong) NSString       *cacheUrl;
@property (nonatomic, strong) NSString       *loadUrl;
@property (nonatomic, strong) BKFullScreenAdView *fullScreenAd;
@property (nonatomic, strong) BKVpadnAdView *vpadnView;
@property (nonatomic, strong) NSString *adCacheDirectory;//缓存目录(可选)

@end

@implementation BKFullScreenAdRequest


+ (BKFullScreenAdRequest *)shared {
    static BKFullScreenAdRequest *fullScreenRequest;
    @synchronized(self){
        if (!fullScreenRequest) {
            fullScreenRequest = [[super alloc] init];
        }
        return fullScreenRequest;
    }
}


- (UIWindow *)fullScreenWindow {
    if (!_fullScreenWindow) {
        CGRect frameScreen = [[UIScreen mainScreen] bounds];
        _fullScreenWindow = [[UIWindow alloc] initWithFrame:CGRectMake(-frameScreen.size.width, 0, frameScreen.size.width, frameScreen.size.height)];
        [_fullScreenWindow setWindowLevel:2001];//要把popup广告覆盖住，所以调高了全屏广告的层级//UIWindowLevelAlert
        
        UIView *viewColor = [[UIView alloc] initWithFrame:_fullScreenWindow.bounds];
        viewColor.backgroundColor = [UIColor clearColor];
        viewColor.tag = 250;
        [_fullScreenWindow addSubview:viewColor];
    }
    return _fullScreenWindow;
}


#pragma mark - 请求一个全屏广告
- (void)requestFullScreenAd:(TouchFullScreenAdBlock)touchScreenAd {
    [self settingTouchScreenAdBlock:^(NSString *url) {
        touchScreenAd(url);
    }];
    [self settingFullScreeAd];
}


//点击全屏广告的block传值
-(void)settingTouchScreenAdBlock:(TouchFullScreenAdBlock)block {
    self.touchFullScreenAdBlock = block;
}


//设置缓存
- (void)settingFullScreeAd {
    
    //如果没有设置广告目录
    if (!_adCacheDirectory) {
        _adCacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/adsCaches"];
        //广告设置缓存文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:[_adCacheDirectory stringByAppendingString:@"/"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_adCacheDirectory
                                      withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    if (_fId) {
        self.cacheUrl = [_adCacheDirectory stringByAppendingFormat:@"/%@_%@", _pageName,_fId];
    } else {
        self.cacheUrl = [_adCacheDirectory stringByAppendingFormat:@"/%@", _pageName];
    }
    
    [self requestFullScreeAd];
}


#pragma mark - 请求全屏广告
- (void)requestFullScreeAd {
    if (!EXIST_ADVPON) {
        return;
    }
    NSString *requestString;
    NSString *device;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        device = @"iphone";
    } else {
        device = @"ipad";
    }
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    NSString *mAPPVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    requestString = [NSString stringWithFormat:@"%@?type=%@&page=%@&device=%@&adid=%@&swidth=%f&ver=%@&ranrom=%i",
                     _requestURL, 
                     @"fullscreen",
                     [BKTool stringByUrlEncoding:_pageName],
                     device,
                     DEF_ADID,
                     screenFrame.size.width,
                     mAPPVersion,
                     arc4random()];
    //如果有传递UID
    if (_uId) {
        requestString = [NSString stringWithFormat:@"%@&uid=%@", requestString, _uId];
    }
    //如果有传递FID
    if (_fId) {
        requestString = [NSString stringWithFormat:@"%@&fid=%@", requestString, [BKTool stringByUrlEncoding:_fId]];
    }

    [[BKNetworking share] get:requestString completion:^(BKNetworkModel *model, NSString *netErr) {
        if (model) {
            [self parserJsonWithJsonDict:model];
        }
    }];
}


//解析数据
- (void)parserJsonWithJsonDict:(BKNetworkModel *)model {
    if (model.status == 1) {

        NSDictionary *dataDict = model.data;
        NSString *controllerName = [dataDict objectForKey:@"currentControllerName"];
    
        if ([controllerName isEqualToString:_pageName]) {
            [self resolveDataOfDefault:dataDict];
        }
    }
}


//处理请求到的数据
- (void)resolveDataOfDefault:(NSDictionary *)aDict {
    
    //先判断广告是否需要显示,以防止status 出现其他数字，故给int 值
    int statusOfAd = [[aDict objectForKey:@"status"] intValue];
    if (statusOfAd != 1) {
        return;
    }
    
    NSMutableDictionary *oldDict ;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_cacheUrl]) {
        oldDict = [NSMutableDictionary dictionaryWithContentsOfFile:_cacheUrl];
    } else {
        oldDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
        [oldDict setObject:[NSNumber numberWithDouble:0.0] forKey:@"lastShowTime"];
        [oldDict setObject:@"9999" forKey:@"adsOfHomeCount"];
    }
    
    //判断广告每天只加载一次(web端设置)
    NSString *showInDate = [BKTool getTodyDate:@"MMdd"];
    NSString *oldShowInDate = [oldDict objectForKey:@"adsOfHomeCount"];
    if ([showInDate isEqualToString:oldShowInDate]) {
        //每天展示一次判斷
        //TODO : 再次进入同一个主题列表界面的话,该字段必大于0,必return,有疑问
        if ([aDict[@"vieweveryday"] integerValue] > 0) {
            return;
        }
    }
    
    [oldDict setObject:showInDate forKey:@"adsOfHomeCount"];
    
    //隐藏关闭按钮
    _fullScreenAd.closeBtn.hidden = [aDict[@"hiddenclose"] boolValue];
    
    //广告加载完成后显示停顿的时间（秒）
    pause = [[aDict objectForKey:@"pause"] intValue];
    
    //广告显示间隔的秒钟
    NSTimeInterval delay = [aDict[@"delay"] doubleValue];
    NSTimeInterval todayTime =  [[NSDate new] timeIntervalSince1970];
    //计算当前时间与上一次显示的时间间隔
    NSTimeInterval delayTime = todayTime - [oldDict[@"lastShowTime"] doubleValue];
    NSLog(@"后台返回的时间:%f   现在的时间:%f   上次的时间:%f   时间差:%f",delay,todayTime,[oldDict[@"lastShowTime"] doubleValue],delayTime);
    //比较这个时间间隔，小于时 不需要显示，大于时需要继续执行
    if (delayTime < delay) {
        return;
    }
    
    //拼接广告url
    NSString *adsUrl = [aDict objectForKey:@"url"];
    if ([adsUrl rangeOfString:@"?"].location == NSNotFound) {
        adsUrl = [adsUrl stringByAppendingFormat:@"?random=%i", arc4random()];
    }
    
    //顯示廣告
    NSString *isPad;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        isPad = @"0";
    }else{
        isPad = @"1";
    }
    
    _loadUrl = [NSString stringWithFormat:@"%@&isPad=%@", adsUrl, isPad];
    
    if ([oldDict writeToFile:_cacheUrl atomically:YES]) {
        NSLog(@"全屏广告缓存数据写入成功\n: %@",oldDict);
    }
    
    //判断要显示的广告类型
    if ([aDict[@"type"] isEqualToString:@"vpon_adid"]) {
        [self showVpadnAdView:aDict[@"url"]];
    }
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    BOOL isEkApp = [appName hasPrefix:@"教育"];
    if (!isEkApp) {
         [self fullScreenWebViewLoad];
    }
    
}


//vpon全屏广告显示逻辑
- (void)showVpadnAdView:(NSString *)bannerId {
    _vpadnView = [[BKVpadnAdView alloc] initWithInterstitialId:bannerId];
    _vpadnView.vponDelegate = self;
}


#pragma mark - 显示vpon全屏广告的代理方法
- (void)mShowVponInterstitialAd:(BOOL)show {
    if (show) {
        if (!_isFullScreenShow) {
            _isFullScreenShow = YES;
            [_vpadnView.interstitialAd show];
        }
    } else {
        [_vpadnView removeFromSuperview];
        _isFullScreenShow = NO;
    }
}


//显示全屏广告view
- (void)fullScreenWebViewLoad {
    if (self.fullScreenAd == nil) {
        self.fullScreenAd = [[BKFullScreenAdView alloc] initWithFrame:[_fullScreenWindow bounds]];
        _fullScreenAd.delegate = self;
        [self.fullScreenWindow addSubview:_fullScreenAd];
    }
    [_fullScreenWindow setHidden:YES];
    [_fullScreenAd loadWebViewWithURL:_loadUrl];
    UIView *viewColor = [_fullScreenWindow viewWithTag:250];
    if ([self.pageName isEqualToString:@"loginSuccess"]) {
        //登录成功后，会显示一次全屏广告，非全屏居中显示，并且背景透明
        _fullScreenAd.frame = CGRectInset(_fullScreenWindow.bounds, 50, 100);
        viewColor.backgroundColor = [UIColor grayColor];
        viewColor.alpha = .6;
    } else {
        _fullScreenAd.frame = _fullScreenWindow.bounds;
        viewColor.backgroundColor = [UIColor clearColor];
    }
}


#pragma makr - delegate  View页面，点击了全屏广告的代理
- (BOOL)fullScreenAdViewliceWebURL:(NSString *)url {
    [self removeFullScreenAd];
    return YES;
}


#pragma mark - BKFullScreenAdView加载完成后的代理方法
- (void)fullScreenWebViewDidFinishLoad {
    //广告加载完成后，延迟pause秒再显示
    [self performSelector:@selector(showAdView) withObject:nil afterDelay:pause];
}


//view的代理 ，点击了view上面的关闭按钮
- (void)fullScreenViewClose {
    [self removeFullScreenAd];
}


//显示广告view
- (void)showAdView {
    if (!_isFullScreenShow && !_vpadnView.interstitialAd.isReady) {
        _isFullScreenShow = YES;
        [_fullScreenWindow setHidden:NO];
        [UIView animateWithDuration:BKAD_ANIMATION_DURATION animations:^{
            [_fullScreenWindow setFrame:[[UIScreen mainScreen] bounds]];
        }];
    }
}


#pragma mark - 关闭全屏广告
- (void)removeFullScreenAd {
    if (_isFullScreenShow) {
        _isFullScreenShow = NO;
        //关闭的时候记录下最后打开的时间
        NSTimeInterval cTimeFloat = [[NSDate new] timeIntervalSince1970];
        NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithContentsOfFile:_cacheUrl];
        [aDict setObject:[NSNumber numberWithDouble:cTimeFloat] forKey:@"lastShowTime"];
        [aDict writeToFile:_cacheUrl atomically:YES];

        //关闭动画
        [UIView animateWithDuration:BKAD_ANIMATION_DURATION animations:^{
            CGRect defRect = [[UIScreen mainScreen] bounds];
            [_fullScreenWindow setFrame:CGRectMake(-defRect.size.width, 0, defRect.size.width, defRect.size.height)];
        } completion:^(BOOL finished) {
            [_fullScreenAd stopLoadingWebView];
            [_fullScreenWindow setHidden:YES];
            _fullScreenAd = nil;
            _fullScreenWindow = nil;
        }];
    }
}


@end
