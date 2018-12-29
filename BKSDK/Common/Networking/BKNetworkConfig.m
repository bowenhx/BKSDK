/**
 -  BKNetworkConfig.m
 -  BKSDK
 -  Created by HY on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "BKNetworkConfig.h"

@implementation BKNetworkConfig


+ (BKNetworkConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (id)init {
    self = [super init];
    if (self) {
        _parameterDic = [NSDictionary dictionary];
    }
    return self;
}

@end
