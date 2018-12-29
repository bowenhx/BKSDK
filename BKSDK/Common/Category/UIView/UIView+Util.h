/**
 -  UIView+Util.h
 -  BKSDK
 -  Created by HY on 16/12/29.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  UIView的扩充，方便了调用，可以直接获取屏幕或当前view的宽高，坐标点等
 */

#import <UIKit/UIKit.h>

@interface UIView (Util)

//获取view坐标点
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;

@property (assign, nonatomic, readonly) CGFloat maxX;
@property (assign, nonatomic, readonly) CGFloat minX;
@property (assign, nonatomic, readonly) CGFloat midX;
@property (assign, nonatomic, readonly) CGFloat maxY;
@property (assign, nonatomic, readonly) CGFloat minY;
@property (assign, nonatomic, readonly) CGFloat midY;
@property (assign, nonatomic, readonly) CGFloat maxW;
@property (assign, nonatomic, readonly) CGFloat maxH;


/**
 *  获取子视图的父视图
 *
 *  @return 父视图
 */
- (UIViewController*)myViewController;

@end
