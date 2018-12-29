/**
 -  BKBannerAdRequest.m
 -  BKSDK
 -  Created by HY on 16/12/05.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  banner广告的请求类
 */

#import "BKBannerAdRequest.h"
#import "BKNetworking.h"
#import "BKTool.h"
#import "BKAdConfig.h"
#import "BKVpadnAdView.h"

@interface BKBannerAdRequest()

@property (nonatomic, strong) NSString *cacheURL;
@property (nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation BKBannerAdRequest


#pragma mark - 初始化bannerArray
- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArray;
}


#pragma mark - 开始请求banner广告
- (void)startRequestBannerAdsForList:(GetBannerListBlock)getlistBlock touchBanner:(TouchBannerBlock)touchBanner {
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
                               @"banner",
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
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    BOOL isEkApp = [appName hasPrefix:@"教育"];
    
    //网络请求banner广告
    [[BKNetworking share] get:requestString completion:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            
        } else {
            if (model.status == 1) {
                
                if (self.bannerArray.count) {
                    [_bannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj = nil;
                    }];
                    [self.bannerArray removeAllObjects];
                }

                NSArray *adList = model.data;
                BKBannerAdView *bannerView = nil;
                BKVpadnAdView *vpadnAdView = nil;
                /**这里vpadn 广告获取有几种情况：
                 1.首页的vpadn广告只有一个，但banner 广告没有（目前是这样）
                 2.主题列表中有vpadn 和 banner 广告
                 */
                for (int i=0; i<adList.count; i++) {
                    NSDictionary *adDict = adList[i];
                    NSString *adType = adDict[@"type"];
                    CGFloat height = [adDict[@"height"] floatValue];
                    NSString *content = adDict[@"content"];
                    NSString *cURL = adDict[@"click_url"];
                    
                    if ([adType isEqualToString:@"vpon_adid"]) {
                        if ([_pageName isEqualToString:@"threadView"]) {
                            continue;//帖子详情中不需要添加vpad 广告
                        }
                        //vpadn 广告
                        vpadnAdView = [[BKVpadnAdView alloc] initWithBannerId:content controller:_controller];
                        vpadnAdView.space = [adDict[@"space"] integerValue];
                        
                    } else if (!isEkApp && [adType isEqualToString:@"image"]) {
                        //图片广告
                        bannerView = [[BKBannerAdView alloc] initWithImageURL:content withHeight:height clickBlock:^void(NSString *url) {
                            
                            touchBanner(url);
                            
                        }];
                    } else if (!isEkApp && [adType isEqualToString:@"html_code"]) {
                        //html代码广告
                        bannerView = [[BKBannerAdView alloc] initWithHtmlContent:content withHeight:height clickBlock:^void(NSString *url) {
                            
                            touchBanner(url);
                            
                        }];
                    } else if (!isEkApp && [adType isEqualToString:@"html_url"]) {
                        //html广告链接
                        bannerView = [[BKBannerAdView alloc] initWithHtmlURL:content withHeight:height clickBlock:^void(NSString *url) {
                            
                            touchBanner(url);
                            
                        }];
                    }
                    
                    if (bannerView) {
                        bannerView.clickeURL = cURL;
                        bannerView.number = i;
                        bannerView.space = [adDict[@"space"] integerValue];
                        [_bannerArray addObject:bannerView];
                    }
                    
                    if (vpadnAdView) {
                        //添加到数组里面
                        [_bannerArray addObject:vpadnAdView];
                    }
                    
                    bannerView = nil;
                    vpadnAdView = nil;
                }
                
                //返回请求到的banner列表
                if (self.bannerArray.count) {
                    
                    //注：这里复制添加广告view是为了解决 在列表页面滑动时广告闪动后消失，这是因为广告少于3个，循环引用一个所造成的，故多加两个
                    if (_controller && self.bannerArray.count < 3) {
                        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                        for (int i = 0; i < self.bannerArray.count; i++) {
                            UIView *adView = [self.bannerArray objectAtIndex:i];
                            if ([adView isKindOfClass:[BKVpadnAdView class]]) {
                                BKVpadnAdView *tempAdView = [self.bannerArray objectAtIndex:i];
                                BKVpadnAdView *vpadView = [[BKVpadnAdView alloc] initWithBannerId:tempAdView.bannerId controller:_controller];
                                [tempArr addObject:vpadView];
                            } else {
                                BKBannerAdView *tempAdView = [self.bannerArray objectAtIndex:i];
                                BKBannerAdView *bannerView = [[BKBannerAdView alloc] initWithHtmlURL:tempAdView.htmlURL withHeight:tempAdView.vHeight clickBlock:^void(NSString *url) {
                                    touchBanner(url);
                                }];
                                [tempArr addObject:bannerView];
                            }
                        }
                         [_bannerArray addObjectsFromArray:tempArr];
                    }
                    getlistBlock(_bannerArray);
                }
            } 
        }
    }];
    
    if (_fId) {
        _cacheURL = [_adCacheDirectory stringByAppendingFormat:@"/bannerad_%@_%@", _pageName, _fId];
    } else {
        _cacheURL = [_adCacheDirectory stringByAppendingFormat:@"/bannerad_%@", _pageName];
    }
}


@end
