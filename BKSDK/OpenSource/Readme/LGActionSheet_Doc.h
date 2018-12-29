/**
 -  LGActionSheet_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/Friend-LGA/LGActionSheet
 -  内容摘要：LGActionSheet可以多样化的定制UIActionSheet弹出视图，实现你的需求
 -  当前版本：2.0
 
 
 ##使用方法：

         @warning：LGActionSheet有很多设置可以自定义弹出视图样式，字体颜色，字体大小等属性
         LGActionSheet *actionSheet = [[LGActionSheet alloc] initWithTitle:nil
                                                              buttonTitles:@[@"大號",@"中號",@"小號"]
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                             actionHandler:nil
                                                             cancelHandler:nil
                                                        destructiveHandler:nil];

         Delegate：
         - (void)actionSheet:(LGActionSheet *)actionSheet buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index{
                //可以根据index索引，处理点击事件
         }
 
 */

#import <Foundation/Foundation.h>

@protocol LGActionSheet_Doc <NSObject>

@end
