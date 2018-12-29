/**
 -  AESCrypt_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/Gurpartap/AESCrypt-ObjC
 -  内容摘要：AESCrypt使用aes-256-cbc密码和base64编码对数据进行加密解密操作
 -  当前版本：无版本号
 
 
 ##使用方法
 
     1：在使用的类中导入:  #import "AESCrypt.h"
     
     2：举例：
         NSString *message = @"message";
         NSString *password = @"p123word";
 
     加密：
         NSString *encryptedData = [AESCrypt encrypt:message password:password];
         
     解密：
         NSString *message = [AESCrypt decrypt:encryptedData password:password];
 

 */


#import <Foundation/Foundation.h>

@protocol AESCrypt_Doc <NSObject>

@end
