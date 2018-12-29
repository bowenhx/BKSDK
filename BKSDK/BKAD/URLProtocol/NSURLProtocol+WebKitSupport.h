/**
 -  NSURLProtocol+WebKitSupport.h
 -  NSURLProtocol+WebKitSupport
 -  Created by yeatse on 2016/10/11.
 -  Copyright © 2016年 Yeatse. All rights reserved.
 -  链接： https://github.com/yeatse/NSURLProtocol-WebKitSupport
 -  作用：让wkwebview支持NSURLProtocol ，
 -  注意：这里有些函数使用了私有的api，作者说经过测试已经通过了苹果的审核
 
 使用方法：
 
     让 WKWebView 支持 NSURLProtocol ,注册NSURLProtocol
     [NSURLProtocol wk_registerScheme:@"https"];
     
     请求结束后，注销NSURLProtocol
     [NSURLProtocol wk_unregisterScheme:@"https"];
     
 */

#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)


/**
 WKWebView 注册 NSURLProtocol

 @param scheme http 或 https
 */
+ (void)wk_registerScheme:(NSString*)scheme;


/**
 WKWebView 注销 NSURLProtocol

 @param scheme http 或 https
 */
+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
