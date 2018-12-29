/**
 -  MemoryUsege.h
 -  BKMobile
 -  Created by HY on 16/12/20.
 -  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
 -  显示内存，CPU的使用情况,yes显示，no不显示
 
    使用方法：
 
         #import "MemoryUsege.h"
         [[MemoryUsege share] showMemoryView:YES];
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BKMemoryUsege : NSObject

@property (nonatomic, strong) UILabel *lab;

/**
 单例

 @return MemoryUsege
 */
+ (BKMemoryUsege *)share;


/**
 显示内存，cpu使用

 @param isShow yes：显示  no：不显示
 */
-(void)showMemoryView:(BOOL)isShow;

@end
