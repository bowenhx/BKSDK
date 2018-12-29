/**
 -  AvoidCrash_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/chenfanfang/AvoidCrash
 -  内容摘要：这个框架利用runtime技术对一些常用并且容易导致崩溃的方法进行处理，可以有效的防止崩溃。
 -  当前版本：1.5.1
 
 
 ##使用方法
 
     - 在AppDelegate中导入:  #import "AvoidCrash.h"
 
     - 在AppDelegate的didFinishLaunchingWithOptions方法中添加如下代码，让AvoidCrash生效
         [AvoidCrash becomeEffective];
     
     - 若你想要获取崩溃日志的所有详细信息，只需添加通知的监听，监听的通知名为:AvoidCrashNotification
     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         [AvoidCrash becomeEffective];
         //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
         return YES;
     }
     
     - (void)dealwithCrashMessage:(NSNotification *)note {
         //注意:所有的信息都在userInfo中
         //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
         NSLog(@"%@",note.userInfo);
     }
 
 
 
 ##目前可以防止崩溃的方法有
 
     - NSArray
         - `1. NSArray的快速创建方式 NSArray *array = @[@"chenfanfang", @"AvoidCrash"];  //这种创建方式其实调用的是2中的方法`
         - `2. +(instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt`
         - `3. - (id)objectAtIndex:(NSUInteger)index`
 
 
 
     - NSMutableArray
         - `1. - (id)objectAtIndex:(NSUInteger)index`
         - `2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx`
         - `3. - (void)removeObjectAtIndex:(NSUInteger)index`
         - `4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index`
 
 
 
     - NSDictionary
         - `1. NSDictionary的快速创建方式 NSDictionary *dict = @{@"frameWork" : @"AvoidCrash"}; //这种创建方式其实调用的是2中的方法`
         - `2. +(instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt`
 
 
 
     - NSMutableDictionary
         - `1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey`
         - `2. - (void)removeObjectForKey:(id)aKey`
     
 
 
     - NSString
         - `1. - (unichar)characterAtIndex:(NSUInteger)index`
         - `2. - (NSString *)substringFromIndex:(NSUInteger)from`
         - `3. - (NSString *)substringToIndex:(NSUInteger)to {`
         - `4. - (NSString *)substringWithRange:(NSRange)range {`
         - `5. - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement`
         - `6. - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange`
         - `7. - (NSString *)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement`
 
 
 
     - NSMutableString
         - `1. 由于NSMutableString是继承于NSString,所以这里和NSString有些同样的方法就不重复写了`
         - `2. - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString`
         - `3. - (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc`
         - `4. - (void)deleteCharactersInRange:(NSRange)range`
 
 
 
     - KVC
         -  `1.- (void)setValue:(id)value forKey:(NSString *)key`
         -  `2.- (void)setValue:(id)value forKeyPath:(NSString *)keyPath`
         -  `3.- (void)setValue:(id)value forUndefinedKey:(NSString *)key //这个方法一般用来重写，不会主动调用`
         -  `4.- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues`
 
 
 
     - NSAttributedString
         -  `1.- (instancetype)initWithString:(NSString *)str`
         -  `2.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr`
         -  `3.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs`
 
 
 
     - NSMutableAttributedString
         -  `1.- (instancetype)initWithString:(NSString *)str`
         -  `2.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs`
 
 */

#import <Foundation/Foundation.h>

@protocol AvoidCrash_Doc <NSObject>

@end
