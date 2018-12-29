/**
 -  BKNetworkModel.m
 -  BKSDK
 -  Created by HY on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "BKNetworkModel.h"

@implementation BKNetworkModel


- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];

    /**
    if ([key isEqualToString:@"status"]) {
        if ([value integerValue] == -2) {
            //清除用户基本信息，在使用网络的外层接口设置
        }
    }
     */
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
