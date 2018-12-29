/**
 -  BKVponAdRequest.m
 -  BKSDK
 -  Created by ligb on 2016/12/23.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "BKVponAdRequest.h"
#import <AdSupport/ASIdentifierManager.h>
#import "BKVpadnAdView.h"
#import "BKNetworking.h"
#import "BKAdConfig.h"
#import <VpadnSDKAdKit/VpadnSDKAdKit.h>

@interface BKVponAdRequest()<VpadnBannerDelegate>
@end

@implementation BKVponAdRequest

+ (void)vponConfigRequest:(NSString *)page controller:(UIViewController *)ctr backVponView:(VpadnBannerView)block {
    
    NSString *device;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        device = @"iphone";
    } else {
        device = @"ipad";
    }
    
    NSString *vponConfigURL = [NSURL addBuildRequestUrl:@"https://bapi.edu-kingdom.com/ad/vpon_config.php?"];
    vponConfigURL = [NSString stringWithFormat:@"%@&device=%@", vponConfigURL, device];
    
    __weak typeof(ctr)weakCtr = ctr;
    [[BKNetworking share] get:vponConfigURL completion:^(BKNetworkModel *model, NSString *netErr) {
        if (model.status == 1) {
            if (!weakCtr) {
                return;
            }
            [self addVpadnBannerPage:page controller:weakCtr data:model.data bannerView:block];
        }
    }];
}


+ (void)addVpadnBannerPage:(NSString *)page controller:(UIViewController *)ctr data:(NSArray *)array bannerView:(VpadnBannerView)block {
    if ([page isEqualToString:@"threadView"]) {
        //帖子详情
        NSDictionary *data = array[0];
        NSString *adid = data[@"adid"];
        BOOL display = [data[@"display"] boolValue];
        if (display) {
            //帖子详情中有两个地方用到vpadn 广告
            //1.固定在第一个凭的底部  2.显示在帖子中第二楼层中 故这里需要返回两个广告对象
            BKVpadnAdView *vpadnV1 = [[BKVpadnAdView alloc] initWithBannerId:adid controller:ctr];
            BKVpadnAdView *vpadnV2 = [[BKVpadnAdView alloc] initWithBannerId:adid controller:ctr];
            block (@[vpadnV1,vpadnV2]);
        }
    }
}

@end
