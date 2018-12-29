/**
 -  SAMTextView_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/soffes/SAMTextView
 -  内容摘要：给UITextView添加一个placeholder属性
 

 ##使用方法：
 
     导入： #import "SAMTextView.h"
 
     方法一：
         _myTextView = [[SAMTextView alloc] init];
         [_myTextView setPlaceholder:@"你好，我是占位字符"];
     
     方法二：
         SAMTextView *textView = [[SAMTextView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 280.0f)];
         textView.placeholder = @"Type something…";
 
 */

#import <Foundation/Foundation.h>

@protocol SAMTextView_Doc <NSObject>

@end
