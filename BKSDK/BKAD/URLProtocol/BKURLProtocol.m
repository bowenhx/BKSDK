/**
 -  BKURLProtocol.m
 -  BKMobile
 -  Created by HY on 16/12/13.
 -  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "BKURLProtocol.h"
#import "BKTool.h"
#import "BKSaveData.h"
#import "BKCleanCache.h"

//定义请求key值，防止无限循环
#define  URLProtocolHandledKey  @"URLProtocolHandledKey"

@interface BKURLProtocol () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation BKURLProtocol

/**
 *  是否拦截处理指定的请求，创建NSURLProtocol实例，NSURLProtocol注册之后，所有的NSURLConnection都会通过这个方法检查是否持有该Http请求。
 *  @param  request 指定的请求
 *  @return 返回YES表示要拦截处理，返回NO表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)){
        //根据key值，判断是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}


#pragma mark - NSURLProtocol Hold Relevant Method

/**
 *  如果需要对请求进行重定向，添加指定头部等操作，可以在该方法中进行
 *  @param  request 本地HttpRequest请求：request
 *  @return 直接转发
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


/** 主要判断两个request是否相同，如果相同的话可以使用缓存数据，通常只需要调用父类的实现。
 *  @method NSURLProtocol缓存系统设置：如果有两个URL请求，并且他们是相等的，那么这里可以使用相同的缓存空间
 *  @param  a  本地HttpRequest请求：request
 *  @return YES：使用缓存数据 NO：不使用
 */
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}


/**
  开始加载特定于协议的请求
 */
- (void)startLoading {
    
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    NSString *httpStr = [[newRequest URL] absoluteString];
//    NSLog(@"NSURLProtocol截取到的请求--- %@",httpStr);

    //拦截图片请求，并且保存到本地
    if (([BKTool isHaveString:@".jpg" inString:httpStr] || [BKTool isHaveString:@".png" inString:httpStr] || [BKTool isHaveString:@".jpeg" inString:httpStr] ) && ![BKTool isHaveString:@"type=jpeg" inString:httpStr]) {
        
        //截取图片url的后缀名，用来命名需要保存的图片
        NSArray *array = [httpStr componentsSeparatedByString:@"/"];
        NSString *imgName;
        if (array.count > 0) {
            imgName = [array objectAtIndex:array.count - 1];
        }
        
        //如果发现该图片有缓存数据，则使用本地资源加载
        NSData *cacheData = [BKSaveData readAdImageCacheByFile:imgName];
        if (cacheData) {
            NSString *mimeType = @"image/jpg";
            NSString *encoding = @"utf-8";
            //加载webview的方式 initWithURL:MIMEType:expectedContentLength:textEncodingName:
            //这个方式使用的比较少，但也更加自由，url是素材资源路径, 其中data是文件数据，MIMEType是文件类型，textEncodingName是编码类型
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                                MIMEType:mimeType
                                                   expectedContentLength:cacheData.length
                                                        textEncodingName:encoding];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:cacheData];
            [self.client URLProtocolDidFinishLoading:self];
            
        }else{
            
            //如果读取不到缓存，那就让请求继续进行
            [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:newRequest];
            self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
        }
        
        //把截取到的图片保存到本地
        [self writeImageData:httpStr saveImgName:imgName];
      
    }else{
        //打标签，防止请求无限循环
        [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:newRequest];
        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
    }
}


/**
  当前Connection连接取消的时候被调用
 */
- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}


#pragma mark - NSURLProtocol Delegate
//NSURLConnectionDataDelegate方法
//在处理网络请求的时候会调用到该代理方法，我们需要将收到的消息通过client返回给URL Loading System。
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}


#pragma mark - 保存图片

/**
 根据拦截到的图片请求，下载图片并缓存到本地，下次遇到相同请求，使用缓存

 @param imgUrl  拦截到的图片链接
 @param imgName 截取图片链接的最后一段来命名缓存的图片
 */
-(void)writeImageData:(NSString *)imgUrl saveImgName:(NSString *)imgName{
    
    //根据缓存的文件个数，和缓存时长等，清除缓存
    [BKCleanCache trimCacheDirByPath:BKDiskImageCacheFolder isAll:NO];

    //开辟一个线程来下载图片，保存到本地
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imgUrl]];
        [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:request];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [BKSaveData writeDataToAdImageCache:data fileName:imgName];
            }
        }] resume];
    });
}


@end
