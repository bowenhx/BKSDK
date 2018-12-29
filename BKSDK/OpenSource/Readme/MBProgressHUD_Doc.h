/**
 -  MBProgressHUD_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/jdg/MBProgressHUD/
 -  内容摘要：用于项目中加载数据的loading指示器
 -  当前版本：0.7
 
 
 ##使用方法
 
    1：依赖框架：
         Foundation.framework
         UIKit.framework
         CoreGraphics.framework
    
 
    2：使用：
         方法-：
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];

         方法二：
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.mode = MBProgressHUDModeAnnularDeterminate;
         hud.labelText = @"Loading";
         [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
                hud.progress = progress;
         } completionCallback:^{
                [hud hide:YES];
         }];
 
 */

#import <Foundation/Foundation.h>

@protocol MBProgressHUD_Doc <NSObject>

@end
