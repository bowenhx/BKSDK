/**
 -  YYModel.h
 -  BKSDK
 -  Created by HY on 17/06/08.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/ibireme/YYModel
 -  内容摘要：json和模型的相互转换
 -  当前版本：v1.0.4
 
 
 ##使用方法
 
     // Convert json to model:
     User *user = [User yy_modelWithJSON:json];
     
     // Convert model to json:
     NSDictionary *json = [user yy_modelToJSONObject];
 
 */


#import <Foundation/Foundation.h>

@protocol YYModel_Doc <NSObject>

@end
