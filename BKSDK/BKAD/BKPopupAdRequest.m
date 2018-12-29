/**
 -  BKPopupAdRequest.m
 -  BKSDK
 -  Created by HY on 16/12/07.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  弹窗广告的请求类
 */

#import "BKPopupAdRequest.h"
#import <AdSupport/ASIdentifierManager.h>
#import "BKNetworking.h"
#import "BKTool.h"
#import "BKAdConfig.h"

@interface BKPopupAdRequest() {
    CGFloat startAnimated;
    CGFloat displayTime;
    NSString *retain;
    BOOL isLoading;
}

@property (nonatomic, strong) NSDictionary  *dataDict;
@property (nonatomic, strong) NSString      *cacheURL;
@property (nonatomic, strong) NSString *adCacheDirectory;//缓存目录(可选)

@end

@implementation BKPopupAdRequest


#pragma mark - 单例
+ (BKPopupAdRequest *)shared {
    static BKPopupAdRequest *popupAdRequest;
    @synchronized(self) {
        if (!popupAdRequest) {
            popupAdRequest = [[super alloc] init];
        }
        return popupAdRequest;
    }
}


//初始化配置弹窗view
- (UIWindow *)popupWindow {
    
    CGRect frameScreen = [[UIScreen mainScreen] bounds];
    _popupWindow = [[UIWindow alloc] initWithFrame:CGRectMake(-frameScreen.size.width, 0, frameScreen.size.width, frameScreen.size.height)];
    [_popupWindow setWindowLevel:UIWindowLevelAlert];
    
    [_popupWindow setHidden:YES];
    return _popupWindow;
}


#pragma mark - 加载一个弹窗广告

- (void)requestPopupAdBlock:(TouchPopupAdBlock)touchPopup {
   
    if (!EXIST_ADVPON) {
        return;
    }
    NSString *device;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        device = @"iphone";
    } else {
        device = @"ipad";
    }
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    NSString *mAPPVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *requestString = [NSString stringWithFormat:@"%@?type=%@&page=%@&device=%@&adid=%@&swidth=%f&ver=%@&ranrom=%i",
                     _requestURL,
                     @"popup",
                     [BKTool stringByUrlEncoding:_pageName],
                     device,
                     DEF_ADID,
                     screenFrame.size.width,
                     mAPPVersion,
                     arc4random()];
    
    
    //如果有传递UID
    if (_uId) {
        requestString = [NSString stringWithFormat:@"%@&uid=%@", requestString, [BKTool stringByUrlEncoding:_uId]];
    }
    
    //如果有传递FID
    if (_fId) {
        requestString = [NSString stringWithFormat:@"%@&fid=%@", requestString, [BKTool stringByUrlEncoding:_fId]];
    }
    
    
    //如果没有设置广告目录
    if (!_adCacheDirectory) {
        _adCacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/adsCaches"];
        
        //广告设置缓存文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:[_adCacheDirectory stringByAppendingString:@"/"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_adCacheDirectory
                                      withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    [[BKNetworking share] get:requestString completion:^(BKNetworkModel *model, NSString *netErr) {
        if (model) {
            [self parserJsonWithJsonDict:model];
        }
    }];
    
    [self settingTouchPopupBlock:^(NSString *url) {
        touchPopup(url);
    }];
    
    _cacheURL = [_adCacheDirectory stringByAppendingFormat:@"/weatherAd_%@", _pageName];
}


//解析弹窗广告数据
- (void)parserJsonWithJsonDict:(BKNetworkModel *)model {
    if (model.status == 1) {
        
        NSDictionary *dataDict = model.data;
        _dataDict = dataDict;
        //-------------------- 广告显示的间隔 （秒钟）--------------------{{
        NSMutableDictionary *currentDict;
        if ([[NSFileManager defaultManager] fileExistsAtPath:_cacheURL]) {
            currentDict = [NSMutableDictionary dictionaryWithContentsOfFile:_cacheURL];
        } else {
            
            currentDict = [NSMutableDictionary dictionaryWithObjects:[dataDict allValues] forKeys:[dataDict allKeys]];
            [currentDict setObject:[NSNumber numberWithFloat:0.0f] forKey:@"lastShowTime"];
        }
        //广告显示间隔的秒钟
        NSTimeInterval alertnation = [dataDict[@"alternation"] doubleValue];//后台设置的时间间隔
        NSTimeInterval cTimeFloat = [[NSDate new] timeIntervalSince1970];//当前系统时间
        NSTimeInterval lastShowTime = [currentDict[@"lastShowTime"] doubleValue];//最后保存的时间
        
        if (lastShowTime > 0) {
            if ((cTimeFloat - lastShowTime) < alertnation ) {
                 NSLog(@"cTimeFloat - lastShowTime =  %f",cTimeFloat - lastShowTime);
                return;
            } else {
                lastShowTime = cTimeFloat;
            }
        } else {
            lastShowTime = cTimeFloat;
        }
        [currentDict setObject:[NSNumber numberWithDouble:lastShowTime] forKey:@"lastShowTime"];
        [currentDict writeToFile:[_adCacheDirectory stringByAppendingFormat:@"/weatherAd_%@", _pageName] atomically:YES];
        //---------------------------}}
        //弹窗方式
        NSString *theWay = [dataDict objectForKey:@"theWay"];
        //广告网页地址
        NSString *contentURL = [dataDict objectForKey:@"contentUrl"];
        displayTime = [[dataDict objectForKey:@"displayTime"] floatValue];
        //出现动画的速度
        startAnimated = [[dataDict objectForKey:@"starTime"] floatValue];
        //关闭按钮是否显示
        BOOL isCloseBtn = [[dataDict objectForKey:@"isCloseButton"] boolValue];
        
        //缩放后的尺寸
        retain = [dataDict objectForKey:@"retain"];
        //尺寸
        NSString *sizeStr = [dataDict objectForKey:@"widthHeight"];
        NSArray *sizeArray = [sizeStr componentsSeparatedByString:@"x"];
        CGFloat x, y, width, height;
        width = [[sizeArray objectAtIndex:0] floatValue];
        height = [[sizeArray objectAtIndex:1] floatValue];
        
        float offsetY = 0.0f;
        
        CGRect defRect = [[UIScreen mainScreen] bounds];
        if ([theWay isEqualToString:@"Left"]) {
         
            x = 0.0f - width;
            y = defRect.size.height - height - offsetY;
            _startFrame = CGRectMake(x, y, width, height);
            _showFrame = CGRectMake((defRect.size.width - width)/2, y - offsetY, width, height);
            
        } else if ([theWay isEqualToString:@"Right"]) {
            
            x = defRect.size.width + width;
            y = defRect.size.height - height - offsetY;
            _startFrame = CGRectMake(x, y - offsetY, width, height);
            _showFrame = CGRectMake((defRect.size.width - width)/2, y, width, height);
            
        } else if([theWay isEqualToString:@"Center"]) {
            
            x = (defRect.size.width-width)/2;
            y = (defRect.size.height-height)/2 - offsetY;
            _startFrame = CGRectMake(x, y, width, height);
            _showFrame = CGRectMake((defRect.size.width - width)/2, (defRect.size.height - height - offsetY), width, height);
            
        } else if([theWay isEqualToString:@"Top"]) {
            
            x = (defRect.size.width - width)/2;
            y = 0 - height - offsetY;
            _startFrame = CGRectMake(x, y, width, height);
            _showFrame = CGRectMake((defRect.size.width - width)/2, (defRect.size.height - height - offsetY), width, height);
            
        } else if([theWay isEqualToString:@"Bottom"]) {
            
            x = (defRect.size.width - width)/2;
            y = defRect.size.height - offsetY;
            _startFrame = CGRectMake(x, y, width, height);
            _showFrame = CGRectMake((defRect.size.width - width)/2, (defRect.size.height - height - offsetY), width, height);
            
        }
        
        if (self.popupView) {
            [_popupView setFrame:CGRectMake(0, 0, width, height)];
            [_popupView webViewLoadURL:contentURL isCloseBtn:isCloseBtn];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //add view
                self.popupView = [[BKPopupAdView alloc] initWithFrame:CGRectMake(0, 0, width, height) withURL:contentURL isCloseBtn:isCloseBtn];
                [_popupView setDeleage:self];
                [_popupWindow addSubview:_popupView];
            });
        }
        
        isLoading = YES;
    }
}


#pragma mark - 显示广告
- (void)showPopupView {
    //判断是在加载广告
    if (isLoading) {
        //修改窗口的frame
        [_popupWindow setFrame:_startFrame];
        [_popupWindow setHidden:NO];
        
        [UIView animateWithDuration:startAnimated animations:^{
            [_popupWindow setFrame:CGRectMake(_showFrame.origin.x, _showFrame.origin.y-_bottomHeight, _showFrame.size.width, _showFrame.size.height)];
            
        } completion:^(BOOL finished) {
            if (displayTime > 0) {
                if ([retain isEqualToString:@"0x0"]) {
                    displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayTime target:self selector:@selector(removePopupView) userInfo:nil repeats:NO];
                }else{
                    displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayTime target:self selector:@selector(popupViewNarrow) userInfo:nil repeats:NO];
                }
            }
        }];
    }
    isLoading = NO;
}


#pragma mark - 缩小弹窗广告view
- (void)popupViewNarrow {
    if (displayTimer && [displayTimer isValid]) {
        [displayTimer invalidate];
        displayTimer = nil;
    }
    //NSString *retain = [_dataDict objectForKey:@"retain"];
    NSArray *sizeArray = [retain componentsSeparatedByString:@"x"];
    CGFloat width = [[sizeArray objectAtIndex:0] floatValue];
    CGFloat height = [[sizeArray objectAtIndex:1] floatValue];
    
    CGRect defRect = [[UIScreen mainScreen] bounds];
    CGRect newFrame = CGRectMake((defRect.size.width - width) / 2, _showFrame.origin.y + (_showFrame.size.height - height), width, height);
    
    //回收动画的速度
    CGFloat endAnimated = [[_dataDict objectForKey:@"endTime"] floatValue];
    
    [UIView animateWithDuration:endAnimated animations:^{//底部有导航栏，减去导航栏高度
        [_popupWindow setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y-_bottomHeight, width, height)];
        [_popupView setFrame:CGRectMake(0, 0, width, height)];
        _popupView.enlargeBtn.hidden = NO;
    }];
}


#pragma mark - 放大弹窗广告view
- (void)popupViewEnlarge {
    if (displayTimer && [displayTimer isValid]) {
        [displayTimer invalidate];
        displayTimer = nil;
    }

    _popupView.enlargeBtn.hidden = YES;
    
    //回收动画的速度
    CGFloat endAnimated = [[_dataDict objectForKey:@"endTime"] floatValue];
    [UIView animateWithDuration:endAnimated animations:^{//底部有导航栏，减去导航栏高度
        [_popupWindow setFrame:CGRectMake(_showFrame.origin.x, _showFrame.origin.y-_bottomHeight, _showFrame.size.width, _showFrame.size.height)];
        [_popupView setFrame:CGRectMake(0, 0, _showFrame.size.width, _showFrame.size.height)];
        //[_popupView changeWebViewFrame];
        _popupView.closeBtn.transform = CGAffineTransformIdentity;
        
        CGFloat displayTim = [[_dataDict objectForKey:@"displayTime"] floatValue];
        if (displayTim > 0) {
            displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayTim target:self selector:@selector(popupViewNarrow) userInfo:nil repeats:NO];
        }
    }];
}


#pragma mark - 关闭移除view
- (void)removePopupView {
    //动画时间到了自动移除
    if (displayTimer && [displayTimer isValid]) {
        [displayTimer invalidate];
        displayTimer = nil;
    }
    if (self.popupView) {
        //回收动画的速度
        CGFloat endAnimated = [[_dataDict objectForKey:@"endTime"] floatValue];
        
        [UIView animateWithDuration:endAnimated animations:^{
            [_popupWindow setFrame:_startFrame];
            [_popupWindow setHidden:YES];
            [_popupView stopVideo];
        }];
    }
}


#pragma mark popupView deleage
- (void)popupViewRremoveFromSuperview:(BKPopupAdView *)popupView {
    //点击移除
    if (displayTimer && [displayTimer isValid]) {
        [displayTimer invalidate];
        displayTimer = nil;
    }
    [_popupView stopVideo];
    [_popupWindow setHidden:YES];
}


- (void)popupViewEnlargeBtnClicked:(BKPopupAdView *)popupView {
    [self popupViewEnlarge];
}


- (BOOL)popupViewCliceWebURL:(NSString *)url {
    [self removePopupView];
    return YES;
}


- (void)popupViewWebViewFinishLoad:(BKPopupAdView *)popubView {
    //webview加载完成后显示广告
    [self showPopupView];
}


//block
- (void)settingTouchPopupBlock:(TouchPopupAdBlock)block {
    self.touchPopupAdBlock = block;
}

@end

