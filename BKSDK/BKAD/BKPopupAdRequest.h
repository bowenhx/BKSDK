/**
 -  BKPopupAdRequest.h
 -  BKSDK
 -  Created by HY on 16/12/07.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  弹窗广告的请求类
 */

#import <Foundation/Foundation.h>
#import "BKPopupAdView.h"
@class BKPopupAdRequest;


/** 点击弹窗广告block */
typedef void (^TouchPopupAdBlock) (NSString *url);

@interface BKPopupAdRequest : NSObject<BKPopupAdViewDelegate> {
    CGRect _startFrame;
    CGRect _showFrame;
    NSTimer *displayTimer;
}

@property (nonatomic, copy) TouchPopupAdBlock touchPopupAdBlock;
@property (nonatomic, strong) BKPopupAdView *popupView;
@property (strong, nonatomic) UIWindow *popupWindow;//弹窗window
@property (nonatomic, strong) NSString *pageName;   //页面名称(必须)
@property (nonatomic, strong) NSString *requestURL; //请求地址(必须)
@property (nonatomic, strong) NSString *uId;        //用户ID(可选)
@property (nonatomic, strong) NSString *fId;        //板块ID(可选)
@property (nonatomic, assign) CGFloat  bottomHeight;//弹窗广告距离屏幕下方的距离


/**
 *  单例
 */
+ (BKPopupAdRequest *)shared;


/**
 *  请求一个弹框广告
 *
 *  @param touchPopup   点击弹窗广告的block
 */
- (void)requestPopupAdBlock:(TouchPopupAdBlock)touchPopup;


/**
 *  移除广告
 */
- (void)removePopupView;


@end
