/**
 -  UIWindow+Util.h
 -  BKSDK
 -  Created by HY on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  获取到当前可见的页面
 */

#import <UIKit/UIKit.h>

@interface UIWindow (Util)


/**
 *  @brief  获取到当前可见的页面
 *
 *  @return 返回得到的当前页面
 */
- (UIViewController *)visibleViewController;


@end
