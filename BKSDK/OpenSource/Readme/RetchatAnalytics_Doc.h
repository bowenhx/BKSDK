/**
 -  RetchatAnalytics_Doc.h
 -  BKSDK
 -  Created by HY on 17/05/10.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  内容摘要：大数据统计，跟踪用户信息功能
 -  当前版本：v1.0
 
 
 ##使用方法
 
     1：选中target，在General面板下找到 Embedded Binaries ，点击 + ，添加该SDK .
 
     2：添加依赖框架：
            CoreTelephony.framework
            CoreLocation.framework
            AdSupport.framework
 
     3：导入框架：
            @import RetchatAnalytics;
 
     4：添加shell脚本：
            bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/RetchatAnalytics.framework/strip-frameworks.sh"
     
     5：使用方法：
             // THIS IS AN EXAMPLE OF INIT TRACKING OBJECT
             -(void)applicationDidBecomeActive:(UIApplication *)application { [[RetChatTrackerAgent sharedInstance] launch];
             }
 
             // THIS IS AN EXAMPLE OF SENDING TRACKING LOG
             NSDictionary* dicExtraData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"value",@"name", nil];
             [[RetChatTrackerAgent sharedInstance] sendClickEvent:@"007" siteMember:@"ralph" extraData:dicExtraData];
             dicExtraData = nil;
 
             // THIS IS AN EXAMPLE OF SENDING SITE-CLICK LOG
             [[RetChatTrackerAgent sharedInstance] sendClickEvent:@"button-1" siteMember:@"ralph-siteClk" extraData:nil];
             
             // THIS IS AN EXAMPLE OF SENDING RETAIR-CLICK LOG
             [[RetChatTrackerAgent sharedInstance] sendClickItem:@"009" siteMember:@"ralph-retClk" recommedID:1605L extraData:nil];

 */


#import <Foundation/Foundation.h>

@protocol RetchatAnalytics_Doc <NSObject>

@end
