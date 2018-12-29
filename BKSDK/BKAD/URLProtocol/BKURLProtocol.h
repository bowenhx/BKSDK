/**
 -  BKURLProtocol.h
 -  BKMobile
 -  Created by HY on 16/12/13.
 -  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
 
 使用方法：
 
     // 注册拦截请求的NSURLProtocol
     [NSURLProtocol registerClass:[BKURLProtocol class]];
 
     //请求结束后注销NSURLProtocol
     [NSURLProtocol unregisterClass:[BKURLProtocol class]];
 
     定义一个NSURLProtocol的子类 在继承NSURLProtocol中，我们需要实现
     + (BOOL)canInitWithRequest:(NSURLRequest *)request, 定义拦截请求的URL规则
     - (void)startLoading, 对于拦截的请求，系统创建一个NSURLProtocol对象执行startLoading方法开始加载请求
     - (void)stopLoading，对于拦截的请求，NSURLProtocol对象在停止加载时调用该方法
     + (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request，可选方法，对于需要修改请求头的请求在该方法中修改
 
 */

#import <Foundation/Foundation.h>

@interface BKURLProtocol : NSURLProtocol

@end
