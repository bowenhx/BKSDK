/**
 -  UIAlertView_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/jivadevoe/UIAlertView-Blocks
 -  内容摘要：系统自带的UIAlertView只能支持delegate方式,如果你有二个或多个UIAlertView, 你需要在委托方法中进行判断是哪个UIAlertView实例的产生的委托, 接着又要判断是响应哪个button。在这里对UIAlertView添加了block块支持，可以直接处理点击事件
 -  当前版本：1.0
 
 
 ##使用方法：
 
     [[[UIAlertView alloc] initWithTitle:@"Delete This Item?"
                                 message:@"Are you sure you want to delete this really important thing?"
                        cancelButtonItem:[RIButtonItem itemWithLabel:@"Yes" action:^{
                                     // Handle "Cancel"
                                 }]
                        otherButtonItems:[RIButtonItem itemWithLabel:@"Delete" action:^{
                                     // Handle "Delete"
                                 }], nil] show];
 
 */

#import <Foundation/Foundation.h>

@protocol UIAlertView_Doc <NSObject>

@end
