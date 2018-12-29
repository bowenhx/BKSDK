/**
 -  BKException.h
 -  BKSDK
 -  Created by HY on 16/11/21.
 -  Copyright © 2016年 HY. All rights reserved.
 -  开启一个捕获崩溃异常的方法，当遇到崩溃情况时候，把崩溃信息写到本地，再次打开app会从本地读取崩溃信息文件，然后上传到后台
 */

#import <Foundation/Foundation.h>

@interface BKException : NSObject

/**
 * @brief ##把捕获到的崩溃记录，上传到后台
 * 逻辑：app由于某些原因崩溃，app闪退，所以先把崩溃原因保存到本地。下次进入app读取存储的崩溃信息，上传到后台
 *
 * @param errorUrl  上传错误日志的地址，例：@"?mod=misc&op=log"
 * @param token     当前用户的token
 * @param uuid      用户id
 */
+ (void)startExceptionHandler:(NSString *)errorUrl token:(NSString *)token uuid:(NSString *)uuid;


/**
 * @brief ##把捕获到的崩溃记录，上传到后台
 * 逻辑：app由于某些原因崩溃，由于使用了AvoidCrash库，并没有闪退，把崩溃的记录直接上传到后台
 *
 * @param errorUrl  上传错误日志的地址，例：@"?mod=misc&op=log"
 * @param token     当前用户的token
 * @param uuid      用户id
 */
+ (void)uploadExceptionByAvoidCrash:(NSString *)errorUrl token:(NSString *)token uuid:(NSString *)uuid crashInfo:(NSDictionary *)crashInfo;


@end
