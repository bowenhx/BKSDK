/**
 -  AESCrypt_Doc.h
 -  BKSDK
 -  Created by HY on 17/06/08.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/SnapKit/Masonry
 -  内容摘要：一个使用简单方便的页面布局框架
 -  当前版本：v1.0.2
 
 
 ##使用方法
 
     1：在使用的类中导入:  #import "Masonry.h"
 
     举例：居中显示一个view
         [view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.center.equalTo(self.view);
             make.size.mas_equalTo(CGSizeMake(300, 300));
         }];
 
         看一下Masonry支持哪一些属性:
         @property (nonatomic, strong, readonly) MASConstraint *left;
         @property (nonatomic, strong, readonly) MASConstraint *top;
         @property (nonatomic, strong, readonly) MASConstraint *right;
         @property (nonatomic, strong, readonly) MASConstraint *bottom;
         @property (nonatomic, strong, readonly) MASConstraint *leading;
         @property (nonatomic, strong, readonly) MASConstraint *trailing;
         @property (nonatomic, strong, readonly) MASConstraint *width;
         @property (nonatomic, strong, readonly) MASConstraint *height;
         @property (nonatomic, strong, readonly) MASConstraint *centerX;
         @property (nonatomic, strong, readonly) MASConstraint *centerY;
         @property (nonatomic, strong, readonly) MASConstraint *baseline;


 */


#import <Foundation/Foundation.h>

@protocol Masonry_Doc <NSObject>

@end
