/**
 -  BKVpadnAdView.m
 -  BKSDK
 -  Created by ligb on 2016/12/23.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#define ICON_W      45 //vpadn native ad icon width
#define SPACE_Y     0

#import "BKVpadnAdView.h"
#import "BKDefineFile.h"
#import "UIView+Util.h"

@interface BKVpadnAdView ()<VpadnBannerDelegate , VpadnInterstitialDelegate , VpadnNativeAdDelegate>

/*普通只有大图广告*/
@property (strong, nonatomic) UIImageView *adCoverMedia;
/*帖子详情中浮动广告中的元素*/
@property (strong, nonatomic) UIImageView *adIcon;
@property (strong, nonatomic) UILabel *adTitle;
@property (nonatomic , assign) float adCoverHeight;
@property (nonatomic , assign) float tempAdHeight;

@end

@implementation BKVpadnAdView

#pragma mark - dealloc
- (void)dealloc {
    if (_nativeAd) {
        [self.nativeAd unregisterView];
        self.nativeAd.delegate = nil;
        self.adCoverMedia.image = nil;
    }
    
    NSLog(@">>>\n %s",__func__);
}

#pragma mark - 横幅广告
- (instancetype)initWithBannerId:(NSString *)bannerId controller:(UIViewController *)ctr {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // create an CGPoint origin for the banner to show in the middle of the bannerView
        CGPoint origin = CGPointMake((SCREEN_WIDTH - VpadnAdSizeBanner.size.width)/2.0f , 0);
       
        // Set up bannerAd
        _bannerAd = [[VpadnBanner alloc] initWithAdSize:VpadnAdSizeBanner origin:origin];
        _bannerAd.strBannerId = bannerId; // 填入您的BannerId
        _bannerAd.platform = @"TW"; // 台灣地區請填TW 大陸則填CN
        _bannerAd.delegate = self;
        [_bannerAd setAdAutoRefresh:NO]; //关闭vpon自动刷新功能
        [_bannerAd setRootViewController:ctr];
        UIView *adView = [_bannerAd getVpadnAdView];
        CGRect rect = CGRectZero;
        rect.size = adView.frame.size;
        rect.size.width = SCREEN_WIDTH;
        self.frame = rect;
        [self addSubview:adView];
        
        [_bannerAd startGetAd:nil];
        //test 传uuid
        //[_bannerAd startGetAd:[self getTestIdentifiers]];
        
        self.vHeight = CGRectGetHeight(adView.frame);
        self.bannerId = bannerId;
        self.controller = ctr;
    }
    return self;
}


#pragma mark - 插屏广告
- (instancetype)initWithInterstitialId:(NSString *)bannerId {
    self = [super initWithFrame:SCREEN_BOUNDS];
    if (self) {
        // Set up interstitialAd
        _interstitialAd = [[VpadnInterstitial alloc] init];
        _interstitialAd.strBannerId = bannerId; // 填入您的Interstitial BannerId
        _interstitialAd.platform = @"TW"; // 台灣地區請填TW 大陸則填CN
        _interstitialAd.delegate = self;
        [_interstitialAd getInterstitial:nil];
        //test 传uuid
//        [_interstitialAd getInterstitial:[self getTestIdentifiers]];
    }
    return self;
}


#pragma mark - 原生广告
- (instancetype)initWithVpadnNativeBannerId:(NSString *)bannerId {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        /**
         CoverImage	1200 x 627px (可等比例缩放，不可变形，不可裁切)
         Icon	128 x 128px (可等比例缩放，不可变形，不可裁切)
         */
        CGRect rect = CGRectZero;
        rect.size.width = SCREEN_WIDTH;
        
        float scale = 1200 / 627.0;
        //记录图片的高度
        self.adCoverHeight = SCREEN_WIDTH / scale;
        //计算self.view 的整个高度 + 30 显示广告运营商
        rect.size.height = self.adCoverHeight + SPACE_Y + 30;
        self.frame = rect;
        self.tempAdHeight = rect.size.height;
        self.vHeight = 1;
        
        [self addItemView];
        
        self.nativeAd = [[VpadnNativeAd alloc] initWithBannerID:bannerId];
        self.nativeAd.delegate = self;
        [self.nativeAd loadAdWithTestIdentifiers:@[]];
        //test 传uuid
//        [self.nativeAd loadAdWithTestIdentifiers:[self getTestIdentifiers]];
        
        self.bannerId = bannerId;
    }
    return self;
}


//添加ItemView
- (void)addItemView {
    //广告大图
    _adCoverMedia = [[UIImageView alloc] initWithFrame:CGRectMake(0, SPACE_Y, SCREEN_WIDTH, _adCoverHeight)];
    
    //赞助商
    UILabel *labAd = [[UILabel alloc] initWithFrame:CGRectMake(5, HEIGHTADDY(_adCoverMedia)+5, 100, 20)];
    labAd.text = @"Sponsored";
    labAd.textColor = [UIColor darkGrayColor];
    labAd.font = [UIFont systemFontOfSize:14];
    labAd.hidden = YES;
    labAd.tag = 55;
    
    //***注意 SDK这里的颜色要调整，因为SDK服务于多个项目
//    labAd.textColor = [UIColor colorNavBg];
//    labAd.layer.borderColor = [UIColor colorNavBg].CGColor;
    
    [self addSubview:_adCoverMedia];
    [self addSubview:labAd];
}


- (UIView *)floatView {
    if (!_floatView) {
        _floatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ICON_W)];
        
        _adIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, ICON_W, ICON_W)];
        //标题
        _adTitle = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(_adIcon) + 10, 2, SCREEN_WIDTH - ICON_W - 10, 20)];
        _adTitle.font = [UIFont boldSystemFontOfSize:16];
        //赞助商
        UILabel *labAd = [[UILabel alloc] initWithFrame:CGRectMake(X(_adTitle), HEIGHTADDY(_adTitle)+2, 100, 20)];
        labAd.text = @"Sponsored";
        labAd.textColor = [UIColor darkGrayColor];
        labAd.font = [UIFont systemFontOfSize:14];
        
        [_floatView addSubview:_adIcon];
        [_floatView addSubview:_adTitle];
        [_floatView addSubview:labAd];
    }
    return _floatView;
}


#pragma mark - 测试方法
- (NSArray *)getTestIdentifiers {
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return [NSArray arrayWithObjects:
            idfa,
//            @"FF44D0B2-C10F-49C3-A54A-D240CA703922",
            nil];
}


#pragma mark - VpadnBannerDelegate
- (void)onVpadnGetAd:(UIView *)bannerView {
    DLog(@"開始抓取廣告");
}

- (void)onVpadnAdReceived:(UIView *)bannerView {
    DLog(@"廣告抓取成功");
}

- (void)onVpadnAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    DLog(@"廣告抓取失敗 %@", error);//rror Domain=NO_FILL Code=-25 "(null)"
    if (error) {
        if (self.vponDelegate && [self.vponDelegate respondsToSelector:@selector(mShowVponInterstitialAd:)]) {
            [self.vponDelegate mShowVponInterstitialAd:NO];
        }
    }
}

- (void)onVpadnDismiss:(UIView *)bannerView {
    DLog(@"關閉vpadn廣告頁面 %@",bannerView);
}

- (void)onVpadnLeaveApplication:(UIView *)bannerView {
    DLog(@"離開publisher application");
}


#pragma mark - VpadnInterstitialDelegate
- (void)onVpadnInterstitialAdReceived:(UIView *)bannerView {
    //NSLog(@"插屏廣告抓取成功");
    [self performSelector:@selector(showInterstitial) withObject:nil afterDelay:1.f];
}

- (void)showInterstitial {
    // [self.interstitialAd show]; 放到外层，控制vpon的显示
    if (self.interstitialAd) {
        if (self.vponDelegate && [self.vponDelegate respondsToSelector:@selector(mShowVponInterstitialAd:)]) {
            [self.vponDelegate mShowVponInterstitialAd:YES];
        }
    }
}

- (void)onVpadnInterstitialAdFailed:(UIView *)bannerView {
    NSLog(@"插屏廣告抓取失敗");
}

- (void)onVpadnInterstitialAdDismiss:(UIView *)bannerView {
    //NSLog(@"關閉插屏廣告頁面 %@",bannerView);
    _interstitialAd = nil;
    bannerView = nil;
    if (self.vponDelegate && [self.vponDelegate respondsToSelector:@selector(mShowVponInterstitialAd:)]) {
        [self.vponDelegate mShowVponInterstitialAd:NO];
    }
}

- (void)onVpadnInterstitialAdClicked {
    //NSLog(@"单击插屏广告");
}


#pragma mark - VpadnNativeAdDelegate
- (void)onVpadnNativeAdReceived:(VpadnNativeAd *)nativeAd {
    NSLog(@"VpadnNativeAd onVpadnNativeAdReceived");
    // icon
    __block typeof(self) safeSelf = self;
    [nativeAd.icon loadImageAsyncWithBlock:^(UIImage * _Nullable image) {
        safeSelf.adIcon.image = image;
        safeSelf.vHeight = safeSelf.tempAdHeight;
        UILabel *labText = [safeSelf viewWithTag:55];
        labText.hidden = NO;
    }];

    // media cover
    [nativeAd.coverImage loadImageAsyncWithBlock:^(UIImage * _Nullable image) {
        safeSelf.adCoverMedia.image = image;
       
        safeSelf.vHeight = safeSelf.tempAdHeight;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VponRefreshNotification object:nil];
    }];
    
    // text
    self.adTitle.text = nativeAd.title;
    
    //注册点击整个view事件
    [self.nativeAd registerViewForInteraction:self withViewController:self.controller];
   
    //注册点击整个view事件
    [self.nativeAd registerViewForInteraction:self.floatView withViewController:self.controller];

}

- (void)onVpadnNativeAd:(VpadnNativeAd *)nativeAd didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"VpadnNativeAd didFailToReceiveAdWithError: %@", error);
}

- (void)onVpadnNativeAdPresent:(VpadnNativeAd *)nativeAd {
    NSLog(@"VpadnNativeAd onVpadnNativeAdPresent");
}

- (void)onVpadnNativeAdDismiss:(VpadnNativeAd *)nativeAd {
    NSLog(@"VpadnNativeAd onVpadnNativeAdDismiss");
}

- (void)onVpadnNativeAdLeaveApplication:(VpadnNativeAd *)nativeAd {
    NSLog(@"NativeAdViewController onVpadnNativeAdLeaveApplication");
}

@end
