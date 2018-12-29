/**
 -  Keychain.h
 -  BKSDK
 -  Created by HY on 17/06/08.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  文件标示：https://developer.apple.com/documentation/security/keychain_services/keychains
 -  内容摘要：Keychain存储在iOS系统的内部数据库中,由系统进行管理和加密，哪怕APP被删除了，它存储在Keychain中的数据也不会被删除。
 -  当前版本：v1.2
 
 
 ##使用方法
 
     1: 需要开启，选中targets，找到Capabilities下的 Keychain Sharing 选项，开启
        注意：一定要开启，不打开的话进行Keychain操作将会返回一个34018的错误码
     
     2: 需要导入Framework：Security.framework
     
     3: 需要导入头文件：#import "KeychainItemWrapper.h"
     
     4: 具体实现
         //Identifier: 填写自定义的，标示app的字符串 accessGroup: 即bundleid
         KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"bkszTest" accessGroup:@"com.foremind.gugubaby"];
         
         //保存数据
         NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
         NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
         
         [keychain setObject:[NSString stringWithFormat:@"v:%@|b:%@",version,build] forKey:(id)kSecAttrService];
         
         //从keychain里取出存储的数据，用什么key存，就用什么key取
         NSString *pwd = [keychain objectForKey:(id)kSecAttrService];
         NSLog(@"---pwd=  %@",pwd);
         
         //清空keychain设置
         //[keychain resetKeychainItem];
 */


#import <Foundation/Foundation.h>

@protocol Keychain_Doc <NSObject>

@end
