/**
 -  ZLPhotoLib_Doc.h
 -  BKSDK
 -  Created by HY on 16/11/30.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  文件标示：https://github.com/MakeZL/ZLPhotoLib
 -  内容摘要：是一个集合iOS相册多选/图片游览器多功能库
 -  当前版本：

 
 ##使用方法
 
 ##相册多选
 
         // 创建图片多选控制器
         ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
         // 默认显示相册里面的内容SavePhotos
         pickerVc.status = PickerViewShowStatusSavePhotos;
         // 选择图片的最小数，默认是9张图片最大也是9张
         pickerVc.minCount = 4;
         [pickerVc show];
         // block回调或者代理
         pickerVc.delegate = self;
        
         //A: 传值可以用代理，或者用block来接收，以下是block的传值
         __weak typeof(self) weakSelf = self;
         pickerVc.callBack = ^(NSArray *assets){
         weakSelf.assets = assets;
             [weakSelf.tableView reloadData];
         };

         // B:代理传值
         - (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
             self.assets = assets;
             [self.tableView reloadData];
         }

 

 ##图片浏览器 ZLPhotoPickerBrowserViewController
 
         ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
         // 传入点击图片View的话，会有微信朋友圈照片的风格
         pickerBrowser.toView = cell.imageView;
         // 淡入淡出效果
         pickerBrowser.status = UIViewAnimationAnimationStatusFade;
         // 数据源/delegate
         pickerBrowser.delegate = self;
         pickerBrowser.dataSource = self;
         // 是否可以删除照片
         pickerBrowser.editing = YES;
         pickerBrowser.editText = @"保存";
         // 当前显示的分页数
         pickerBrowser.currentIndexPath = indexPath;
         // 展示控制器
         [pickerBrowser show];

 */


#import <Foundation/Foundation.h>

@protocol ZLPhotoLib_Doc <NSObject>

@end
