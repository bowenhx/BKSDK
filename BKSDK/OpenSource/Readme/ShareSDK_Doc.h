/**
 -  ShareSDK_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：http://wiki.mob.com/ios简洁版快速集成/
 -  内容摘要：用于项目中的分享和一键登录功能（该SDK也包含短信和邮件功能）
 -  当前版本：3.5.0
 -  warning：分享的缩略图，必须小于32K，否则无法分享
 
 
 ##使用方法示例
 
     ##依赖框架：
 
         必须添加的依赖库如下：
             libicucore.tbd
             libz.tbd
             libstdc++.tbd
             JavaScriptCore.framework
         新浪微博SDK依赖库
             ImageIO.framework
             libsqlite3.dylib
         QQ好友和QQ空间SDK依赖库
             libsqlite3.dylib
         微信SDK依赖库
             libsqlite3.dylib
     
     
     
     ##导入头文件：
     
         #import <ShareSDK/ShareSDK.h>
         #import <ShareSDKConnector/ShareSDKConnector.h>
         
         //腾讯开放平台（对应QQ和QQ空间）SDK头文件
         #import <TencentOpenAPI/TencentOAuth.h>
         #import <TencentOpenAPI/QQApiInterface.h>
         
         //微信SDK头文件
         #import "WXApi.h"
         
         //新浪微博SDK头文件
         #import "WeiboSDK.h"
         //新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
     
 
     
 ##初始化第三方平台
     
         - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
         {
             //
             *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
             *  在将生成的AppKey传入到此方法中。
             *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
             *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
             *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
             //
 
            [ShareSDK registerApp:@"iosv1101"
                  activePlatforms:@[
                                    @(SSDKPlatformTypeSinaWeibo),
                                    @(SSDKPlatformTypeMail),
                                    @(SSDKPlatformTypeSMS),
                                    @(SSDKPlatformTypeCopy),
                                    @(SSDKPlatformTypeWechat),
                                    @(SSDKPlatformTypeQQ),
                                    @(SSDKPlatformTypeRenren),
                                    @(SSDKPlatformTypeGooglePlus)]
                         onImport:^(SSDKPlatformType platformType)
             {
                 switch (platformType)
                 {
                     case SSDKPlatformTypeWechat:
                         [ShareSDKConnector connectWeChat:[WXApi class]];
                         break;
                     case SSDKPlatformTypeQQ:
                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                         break;
                     case SSDKPlatformTypeSinaWeibo:
                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                         break;
                     case SSDKPlatformTypeRenren:
                         [ShareSDKConnector connectRenren:[RennClient class]];
                         break;
                     default:
                         break;
                 }
             }
                  onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
             {
                 switch (platformType)
                 {
                     case SSDKPlatformTypeSinaWeibo:
                         //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                         [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                   appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                                 redirectUri:@"http://www.sharesdk.cn"
                                                    authType:SSDKAuthTypeBoth];
                         break;
                     case SSDKPlatformTypeWechat:
                         [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                               appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                         break;
                     case SSDKPlatformTypeQQ:
                         [appInfo SSDKSetupQQByAppId:@"100371282"
                                              appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                            authType:SSDKAuthTypeBoth];
                         break;
                     case SSDKPlatformTypeRenren:
                         [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                         appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                                      secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                                       authType:SSDKAuthTypeBoth];
                         break;
                     case SSDKPlatformTypeGooglePlus:
                         [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                                   clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                                    redirectUri:@"http://localhost"];
                         break;
                     default:
                         break;
                 }
             }];
            return YES;
            }
            (注意：每一个case对应一个break不要忘记填写，不然很可能有不必要的错误，新浪微博的外部库如果不要客户端分享或者不需要加关注微博的功能可以不添加，否则要添加，QQ，微信，google＋这些外部库文件必须要加)



 ##实现分享功能

        //例如QQ的分享，创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，且大小小于32k，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupQQParamsByText:@"分享内容"
                                           title:@"分享标题"
                                             url:[NSURL URLWithString:@"http://mob.com"]
                                      thumbImage:self.vShareThumbImage
                                           image:nil
                                            type:SSDKContentTypeWebPage
                              forPlatformSubType:SSDKPlatformSubTypeQQFriend];
            //分享
            [ShareSDK share:SSDKPlatformSubTypeQQFriend
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nilcancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
             ];
        }



 ##实现一键登录功能

        //例如QQ的登录
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
             }
             else
             {
                 NSLog(@"%@",error);
             }
         }];
 
 */

#import <Foundation/Foundation.h>

@protocol ShareSDK_Doc <NSObject>

@end
