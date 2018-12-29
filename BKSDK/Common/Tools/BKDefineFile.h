/**
 -  BKDefineFile.h
 -  BKSDK
 -  Created by HY on 16/11/16.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  常用的宏定义，包含
 -  获取当前版本号
 -  获取屏幕宽高
 -  定义了所有屏幕尺寸大小
 -  判断手机设备是ipad或iphone
 -  获取view坐标点
 -  判断当前设备的系统版本
 -  定义了设置RGB颜色
 -  定义了弱引用/强引用
 -  只在Debug模式下打印日志等宏定义
 */


#ifndef DefineFile_h
#define DefineFile_h

//系统定义
#define APP_DELEGATE     (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define APP_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//获取屏幕宽度与高度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds

//定义屏幕尺寸
#define IPHONE4         ([UIScreen mainScreen].bounds.size.height == 480)
#define IPHONE5         ([UIScreen mainScreen].bounds.size.height == 568)
#define IPHONE6         ([UIScreen mainScreen].bounds.size.height == 667)
#define IPHONE6P        ([UIScreen mainScreen].bounds.size.height == 736)
#define IPHONEX         ([UIScreen mainScreen].bounds.size.height == 812)
#define BOTTOM_TABBAR_HEIGHT   (([UIScreen mainScreen].bounds.size.height == 812) ? 83 : 49)
#define NAV_BAR_HEIGHT         (([UIScreen mainScreen].bounds.size.height == 812) ? 88 : 64)
#define IPHONEX_BottomAddHeight (([UIScreen mainScreen].bounds.size.height == 812) ? 34 : 0) //iphoneX的底部增加了34pt的高度

//判断iPad，iPhone
#define IS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//View坐标(x,y)和宽高(width,height),注意这里即将废弃，使用UIView的分类来实现
#define X(v)            (v).frame.origin.x
#define Y(v)            (v).frame.origin.y
#define WIDTH(v)        (v).frame.size.width
#define HEIGHT(v)       (v).frame.size.height
#define HEIGHTADDY(v)   (v).frame.size.height + (v).frame.origin.y
#define WIDTHADDX(v)    (v).frame.size.width + (v).frame.origin.x

//判断当前的iPhone系统版本
#define iOS8            ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iOS9            ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define iOS10           ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define iOS11           ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)

//设置RGB颜色/设置RGBA颜色
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

//弱引用/强引用
#define WEAKSELF(type)          try{}@finally{} __weak typeof(type) type##Weak = type;
#define STRONGSELF(type)        __strong typeof(type) type = weak##type;

//打印日志
#ifdef  DEBUG
#define DLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

#endif /* DefineFile_h */

@interface BKDefineFile : NSObject
@end
